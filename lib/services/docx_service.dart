import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';

class DocxService {
  /// Loads the base template bytes either from assets or from the local filesystem
  static Future<List<int>> loadTemplateBytes() async {
    try {
      final byteData = await rootBundle.load('format/Format.docx');
      return byteData.buffer.asUint8List();
    } catch (_) {
      // Fallback for desktop when running from project folder
      final file = File('format/Format.docx');
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      throw Exception(
          'Format.docx not found in assets or format/ folder.');
    }
  }

  /// Generates the filled docx file bytes from a submission
  static Future<Uint8List> generateDocx({
    required MonitoringSubmission submission,
    List<int>? templateBytes,
  }) async {
    final bytes = templateBytes ?? await loadTemplateBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    ArchiveFile? docXmlFile;
    for (final file in archive) {
      if (file.name == 'word/document.xml') {
        docXmlFile = file;
        break;
      }
    }

    if (docXmlFile == null) {
      throw Exception('word/document.xml not found inside Format.docx archive.');
    }

    var content = utf8.decode(docXmlFile.content as List<int>);

    // 1. Semester Replacement (ODD vs EVEN)
    final semUpper = submission.semesterType.toUpperCase();
    if (semUpper.contains('EVEN')) {
      content = content.replaceAll(RegExp(r'\(ODD\)'), '(EVEN)');
    } else {
      content = content.replaceAll(RegExp(r'\(EVEN\)'), '(ODD)');
    }

    // 2. Program and Date replacement
    // Leave date blank as requested ("dont update the date leave it blank like A.Y and SFR")
    final progDisplay =
        '${submission.programName} (${submission.programCode})';

    content = content.replaceAll(
      RegExp(r'Program:\s*-\s*SFR:\s*-\s*1/___\s*Date:'),
      'Program: - $progDisplay      SFR: - 1/___     Date: ',
    );

    // 2b. Leave HOD blank and set NBA Status
    // "then leave the HOD part blank too"
    content = content.replaceAll(
      'Regular/In-charge with Qualification/without classification',
      '                                                          ',
    );
    // "then add another option NBA Status with dropdown options as Accredited/ Applied/ Not Applied"
    content = content.replaceAll(
      'Accredited/ Applied/ Not Applied',
      submission.nbaStatus.isNotEmpty
          ? submission.nbaStatus
          : '                         ',
    );

    // 2c. Weeks to be considered for monitoring replacement
    // Replace template placeholder "FY 5 Weeks, SY 10 Weeks, TY 3 Weeks" with real data from 3-year dropdowns
    final fyWeeks =
        '${submission.weeksDoneYear1} ${submission.weeksDoneYear1 == 1 ? "Week" : "Weeks"}';
    final syWeeks =
        '${submission.weeksDoneYear2} ${submission.weeksDoneYear2 == 1 ? "Week" : "Weeks"}';
    final tyWeeks =
        '${submission.weeksDoneYear3} ${submission.weeksDoneYear3 == 1 ? "Week" : "Weeks"}';
    final realWeeksConsidered = 'FY $fyWeeks, SY $syWeeks, TY $tyWeeks';

    content = content.replaceAll(
      RegExp(r'FY\s*\d+\s*Weeks?,\s*SY\s*\d+\s*Weeks?,\s*TY\s*\d+\s*Weeks?'),
      realWeeksConsidered,
    );

    // 3. Table Rows Replacement
    final tblMatch =
        RegExp(r'<w:tbl[\s>].*?<\/w:tbl>', dotAll: true).firstMatch(content);
    if (tblMatch != null) {
      final tblXml = tblMatch.group(0)!;
      final rowRegex = RegExp(r'<w:tr[\s>].*?<\/w:tr>', dotAll: true);
      final allRows =
          rowRegex.allMatches(tblXml).map((m) => m.group(0)!).toList();

      if (allRows.length >= 6) {
        final headerRows = allRows.sublist(0, 4); // Rows 0..3 (table headers)
        final templateRowTop = allRows[4];
        final templateRowBottom = allRows[5];

        final newRows = <String>[];
        newRows.addAll(headerRows);

        final count = submission.rows.length;

        // Generate row pairs for each submitted entry
        for (var i = 0; i < count; i++) {
          final entry = submission.rows[i];
          final sr = i + 1;
          final entryWeeksDone = submission.getWeeksDoneForEntry(entry);

          final topRow = _makeTopRow(
            template: templateRowTop,
            srNo: sr,
            entry: entry,
            weeksDone: entryWeeksDone,
          );

          final bottomRow = _makeBottomRow(
            template: templateRowBottom,
            entry: entry,
          );

          newRows.add(topRow);
          newRows.add(bottomRow);
        }



        final trStartIndex = tblXml.indexOf('<w:tr');
        final newTblXml =
            '${tblXml.substring(0, trStartIndex)}${newRows.join('')}</w:tbl>';
        content = content.replaceRange(tblMatch.start, tblMatch.end, newTblXml);
      }
    }

    // Repack the docx archive
    final newArchive = Archive();
    for (final file in archive) {
      if (file.name == 'word/document.xml') {
        final newBytes = utf8.encode(content);
        newArchive.addFile(ArchiveFile(file.name, newBytes.length, newBytes));
      } else {
        newArchive.addFile(file);
      }
    }

    final outputBytes = ZipEncoder().encode(newArchive);
    if (outputBytes == null) {
      throw Exception('Failed to encode docx zip archive.');
    }
    return Uint8List.fromList(outputBytes);
  }

  static String _formatPrescribedHours(String raw, [int prescribedWeeks = 10]) {
    final t = raw.trim();
    if (t.isEmpty || t.toUpperCase() == 'NA' || t == '-' || t == '0') {
      return 'NA';
    }
    final numVal = double.tryParse(t);
    if (numVal != null) {
      final total = numVal * prescribedWeeks;
      if (total == total.roundToDouble()) {
        return total.toInt().toString();
      }
      return total.toStringAsFixed(1);
    }
    return t;
  }

  static String calcMultipliedHours(String raw, int weeksDone) {
    final t = raw.trim();
    if (t.isEmpty || t.toUpperCase() == 'NA' || t == '-' || t == '0') {
      return 'NA';
    }
    final numVal = double.tryParse(t);
    if (numVal == null) {
      return 'NA';
    }
    final total = numVal * weeksDone;
    if (total == total.roundToDouble()) {
      return total.toInt().toString();
    }
    return total.toStringAsFixed(1);
  }

  static String _makeTopRow({
    required String template,
    required int srNo,
    required MonitoringRowEntry entry,
    required int weeksDone,
  }) {
    final cellRegex = RegExp(r'<w:tc[\s>].*?<\/w:tc>', dotAll: true);
    final topCells =
        cellRegex.allMatches(template).map((m) => m.group(0)!).toList();

    if (topCells.length < 18) {
      return template;
    }

    // Cell 0: Sr. No.
    topCells[0] = topCells[0]
        .replaceAll(RegExp(r'<w:t>1\.</w:t>'), '<w:t>$srNo.</w:t>');

    // Cell 1: Faculty Name
    topCells[1] = topCells[1].replaceAll(
      RegExp(
          r'<w:r><w:rPr><w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr><w:t>ABC</w:t></w:r><w:r><w:rPr><w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr><w:br/><w:t>\(Sample Format\)</w:t></w:r>'),
      '<w:r><w:rPr><w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr><w:t>${_escapeXml(entry.facultyName)}</w:t></w:r>',
    );

    // Cell 2: Branch / Sem / Scheme
    topCells[2] = topCells[2].replaceAll(
      RegExp(r'<w:t>ME3K</w:t>'),
      '<w:t>${_escapeXml(entry.branchSemScheme)}</w:t>',
    );

    // Cell 3: Qualification
    topCells[3] = topCells[3].replaceAll(
      RegExp(r'<w:t>M\.E\.</w:t>'),
      '<w:t>${_escapeXml(entry.qualification)}</w:t>',
    );

    // Cell 4: Faculty Approved
    topCells[4] = topCells[4].replaceAll(
      RegExp(r'<w:t>Regular \+ Approved</w:t>'),
      '<w:t>${_escapeXml(entry.facultyApproved)}</w:t>',
    );

    // Cell 5: Course Abbreviation and Code
    topCells[5] = topCells[5].replaceAll(
      RegExp(r'<w:t>PDR-313311</w:t>'),
      '<w:t>${_escapeXml(entry.courseAbbreviationCode)}</w:t>',
    );

    // Cell 6, 7, 8: Multiplied contact hours = (Prescribed Hrs * weeksDone)
    final thMult = calcMultipliedHours(entry.thPrescribed, weeksDone);
    final prMult = calcMultipliedHours(entry.prPrescribed, weeksDone);
    final tuMult = calcMultipliedHours(entry.tuPrescribed, weeksDone);

    topCells[6] = topCells[6].replaceAll(
      RegExp(r'<w:t>19</w:t>'),
      '<w:t>${_escapeXml(thMult)}</w:t>',
    );
    topCells[7] = topCells[7].replaceAll(
      RegExp(r'<w:t>40</w:t>'),
      '<w:t>${_escapeXml(prMult)}</w:t>',
    );
    topCells[8] = topCells[8].replaceAll(
      RegExp(r'<w:t>NA</w:t>'),
      '<w:t>${_escapeXml(tuMult)}</w:t>',
    );

    // Cell 9: K1 II-C-2 → Yes / No (small, not bold)
    topCells[9] = topCells[9]
        .replaceAll(
          '<w:rPr><w:b/><w:bCs/><w:sz w:val="28"/><w:szCs w:val="28"/></w:rPr>',
          '<w:rPr><w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr>',
        )
        .replaceAll(
          RegExp(r'<w:t>√</w:t>'),
          '<w:t>${_escapeXml(entry.k1)}</w:t>',
        );

    // Cell 10: K2-A / K2-B II-C-3 → Yes / No (small, not bold)
    topCells[10] = topCells[10]
        .replaceAll(
          '<w:rPr><w:b/><w:bCs/><w:sz w:val="28"/><w:szCs w:val="28"/></w:rPr>',
          '<w:rPr><w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr>',
        )
        .replaceAll(
          RegExp(r'<w:t>√</w:t>'),
          '<w:t>${_escapeXml(entry.k2)}</w:t>',
        );

    // Cell 11: K3 → Yes / No (small, not bold)
    topCells[11] = topCells[11]
        .replaceAll(
          '<w:rPr><w:b/><w:bCs/><w:sz w:val="28"/><w:szCs w:val="28"/></w:rPr>',
          '<w:rPr><w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr>',
        )
        .replaceAll(
          RegExp(r'<w:t>√</w:t>'),
          '<w:t>${_escapeXml(entry.k3)}</w:t>',
        );

    // Cell 12: K6- SLA Created/Maintained/Refined → Records Checked / Records Not Checked
    topCells[12] = topCells[12].replaceAll(
      RegExp(r'<w:t>Records Checked</w:t>'),
      '<w:t>${_escapeXml(entry.k6)}</w:t>',
    );

    // Cell 13: K-7 CT-1 → Yes / No (small, not bold)
    topCells[13] = topCells[13]
        .replaceAll(
          '<w:rPr><w:b/><w:bCs/><w:sz w:val="28"/><w:szCs w:val="28"/></w:rPr>',
          '<w:rPr><w:sz w:val="20"/><w:szCs w:val="20"/></w:rPr>',
        )
        .replaceAll(
          RegExp(r'<w:t>√</w:t>'),
          '<w:t>${_escapeXml(entry.k7)}</w:t>',
        );

    // Cell 14: Student Feedback about Curriculum Covered -> Yes / No
    topCells[14] = topCells[14].replaceAll(
      RegExp(r'<w:t>100%</w:t>'),
      '<w:t>${_escapeXml(entry.studentFeedback)}</w:t>',
    );

    // Cell 15: Curriculum Implementation Aspects -> keep blank
    topCells[15] = topCells[15].replaceAll(
      RegExp(r'<w:t>Checked with CO/PO Mapping</w:t>'),
      '<w:t></w:t>',
    );

    // Cell 16: Average Attendance -> keep blank
    topCells[16] = topCells[16]
        .replaceAll(RegExp(r'<w:t>TH - 95\.45%</w:t>'), '<w:t></w:t>')
        .replaceAll(RegExp(r'<w:t>Avg\. PR-96\.28%</w:t>'), '<w:t></w:t>');

    // Cell 17: Remarks -> keep blank
    topCells[17] = topCells[17].replaceAll(
      RegExp(r'<w:t>CIAAN formats are ok</w:t>'),
      '<w:t></w:t>',
    );

    final trPr = template.substring(0, template.indexOf('<w:tc'));
    return '$trPr${topCells.join()}</w:tr>';
  }

  static String _makeBottomRow({
    required String template,
    required MonitoringRowEntry entry,
  }) {
    final cellRegex = RegExp(r'<w:tc[\s>].*?<\/w:tc>', dotAll: true);
    final bottomCells =
        cellRegex.allMatches(template).map((m) => m.group(0)!).toList();

    if (bottomCells.length < 18) {
      return template;
    }

    // Cell 6, 7, 8: Prescribed contact hours for TH, PR, TU
    final thPres = _formatPrescribedHours(entry.thPrescribed);
    final prPres = _formatPrescribedHours(entry.prPrescribed);
    final tuPres = _formatPrescribedHours(entry.tuPrescribed);

    // Remove <w:b/> and <w:bCs/> to keep text small and non-bold
    bottomCells[6] = bottomCells[6]
        .replaceAll('<w:b/>', '')
        .replaceAll('<w:bCs/>', '')
        .replaceAll(
          RegExp(r'<w:t>20</w:t>'),
          '<w:t>${_escapeXml(thPres)}</w:t>',
        );

    bottomCells[7] = bottomCells[7]
        .replaceAll('<w:b/>', '')
        .replaceAll('<w:bCs/>', '')
        .replaceAll(
          RegExp(r'<w:t>40</w:t>'),
          '<w:t>${_escapeXml(prPres)}</w:t>',
        );

    bottomCells[8] = bottomCells[8].replaceAll(
      RegExp(r'<w:t>NA</w:t>'),
      '<w:t>${_escapeXml(tuPres)}</w:t>',
    );

    final trPr = template.substring(0, template.indexOf('<w:tc'));
    return '$trPr${bottomCells.join()}</w:tr>';
  }

  static String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  /// Sentinel return value indicating browser initiated download
  static const String webDownloadSentinel = 'BROWSER_DOWNLOAD_SUCCESS';

  /// Saves the docx or file with a custom location picker (Save As dialog)
  /// On Desktop, prompts the user to select directory and filename.
  /// On Web, automatically initiates browser file download.
  static Future<String?> saveDocxWithPicker({
    required Uint8List bytes,
    required String filename,
    String? dialogTitle,
    List<String> allowedExtensions = const ['docx'],
  }) async {
    try {
      if (kIsWeb) {
        await FilePicker.saveFile(
          fileName: filename,
          bytes: bytes,
          type: FileType.custom,
          allowedExtensions: allowedExtensions,
        );
        return webDownloadSentinel;
      }

      final uri = await FilePicker.saveFile(
        dialogTitle: dialogTitle ?? 'Save Document As (Select Location)',
        fileName: filename,
        bytes: bytes,
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (uri == null) {
        // User cancelled dialog
        return null;
      }

      if (kIsWeb || uri.scheme == 'blob' || uri.scheme == 'data') {
        return webDownloadSentinel;
      }

      final String filePath =
          uri.scheme == 'file' ? uri.toFilePath() : uri.path;

      // Ensure file exists and contains the bytes on desktop
      final file = File(filePath);
      if (!await file.exists() || (await file.length()) == 0) {
        await file.writeAsBytes(bytes);
      }
      return filePath;
    } catch (e) {
      // If dialog fails for any reason, fallback to default Downloads folder
      return await saveDocxToDefaultDisk(bytes, filename);
    }
  }

  /// Saves the docx file directly to the default Downloads/Documents directory without prompting
  static Future<String?> saveDocxToDefaultDisk(
      Uint8List bytes, String filename) async {
    try {
      if (kIsWeb) {
        await FilePicker.saveFile(
          fileName: filename,
          bytes: bytes,
          type: FileType.custom,
          allowedExtensions: ['docx', 'xlsx'],
        );
        return webDownloadSentinel;
      }

      Directory? dir;
      try {
        dir = await getDownloadsDirectory();
      } catch (_) {}
      dir ??= await getApplicationDocumentsDirectory();

      final filePath = '${dir.path}${Platform.pathSeparator}$filename';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return filePath;
    } catch (e) {
      // Fallback to saving in current workspace/format directory
      final fallbackPath = 'format${Platform.pathSeparator}$filename';
      await File(fallbackPath).writeAsBytes(bytes);
      return fallbackPath;
    }
  }

  /// Legacy alias
  static Future<String?> saveDocxToDisk(
      Uint8List bytes, String filename) async {
    return saveDocxToDefaultDisk(bytes, filename);
  }

  /// Opens the folder containing the file and highlights it in Windows Explorer
  static Future<void> showInFolder(String filePath) async {
    if (kIsWeb) return;
    try {
      if (Platform.isWindows) {
        await Process.run('explorer.exe', ['/select,$filePath']);
      } else if (Platform.isMacOS) {
        await Process.run('open', ['-R', filePath]);
      } else if (Platform.isLinux) {
        final parent = File(filePath).parent.path;
        await Process.run('xdg-open', [parent]);
      }
    } catch (_) {}
  }

  /// Opens the file with default system application (e.g. MS Word on Windows)
  static Future<void> openDocument(String filePath) async {
    if (kIsWeb) return;
    try {
      if (Platform.isWindows) {
        await Process.run('cmd', ['/c', 'start', '', filePath]);
      } else if (Platform.isMacOS) {
        await Process.run('open', [filePath]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [filePath]);
      }
    } catch (_) {}
  }
}
