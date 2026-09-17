import 'package:excel/excel.dart';
import '../models/models.dart';

class ExcelParseFacultyResult {
  final List<ProgramInfo> programs;
  final List<FacultyInfo> faculties;
  final String? error;

  ExcelParseFacultyResult({
    required this.programs,
    required this.faculties,
    this.error,
  });
}

class ExcelService {
  /// Parses the uploaded Faculty & Program Excel sheet.
  /// Expects columns:
  /// Program Name | Program Code | Faculty Name | Qualification | Approval
  static ExcelParseFacultyResult parseFacultySheet(List<int> bytes) {
    try {
      final excel = Excel.decodeBytes(bytes);
      final programsMap = <String, ProgramInfo>{};
      final faculties = <FacultyInfo>[];

      if (excel.tables.isEmpty) {
        return ExcelParseFacultyResult(
          programs: [],
          faculties: [],
          error: 'No sheets found in Excel file.',
        );
      }

      final sheet = excel.tables.values.first;
      if (sheet.rows.isEmpty) {
        return ExcelParseFacultyResult(
          programs: [],
          faculties: [],
          error: 'Sheet is empty.',
        );
      }

      // Find header indices
      int colProgName = -1;
      int colProgCode = -1;
      int colFacName = -1;
      int colQual = -1;
      int colApproval = -1;

      // Find header row (support title rows or blank top rows)
      int headerRowIdx = 0;
      for (var r = 0; r < sheet.rows.length && r < 5; r++) {
        final rowStr = sheet.rows[r].map((c) => c?.value?.toString().trim().toLowerCase() ?? '').join(' ');
        if (rowStr.contains('program') || rowStr.contains('faculty') || rowStr.contains('qual')) {
          headerRowIdx = r;
          break;
        }
      }

      final headerRow = sheet.rows[headerRowIdx];
      for (var i = 0; i < headerRow.length; i++) {
        final val = headerRow[i]?.value?.toString().trim().toLowerCase() ?? '';
        if (val.isEmpty) continue;

        if (val.contains('code') && (val.contains('program') || val.contains('prog') || val.contains('branch') || val.contains('dept') || val.contains('short') || val.contains('abbr'))) {
          colProgCode = i;
        } else if (val.contains('approv') || val.contains('status') || val.contains('designation') || val.contains('post')) {
          // "Faculty Approved", "Approval Status", "Approved", etc. (MUST match before faculty name)
          colApproval = i;
        } else if (val.contains('qual') || val.contains('degree') || val.contains('education')) {
          colQual = i;
        } else if (val.contains('faculty') || val.contains('staff') || val.contains('teacher') || val.contains('instructor') || (val.contains('name') && !val.contains('program') && !val.contains('dept') && !val.contains('course'))) {
          // "Faculty Name", "Name of Faculty", etc.
          colFacName = i;
        } else if (val.contains('program') || val.contains('branch') || val.contains('department') || val.contains('dept')) {
          colProgName = i;
        }
      }

      // If any column was not resolved by keywords, use standard defaults
      if (colProgName == -1) colProgName = 0;
      if (colProgCode == -1) colProgCode = 1;
      if (colFacName == -1) colFacName = 2;
      if (colQual == -1) colQual = 3;
      if (colApproval == -1) colApproval = 4;

      // Parse data rows starting after header row
      for (var r = headerRowIdx + 1; r < sheet.rows.length; r++) {
        final row = sheet.rows[r];
        if (row.isEmpty) continue;

        String getCell(int idx) {
          if (idx < 0 || idx >= row.length) return '';
          return row[idx]?.value?.toString().trim() ?? '';
        }

        final pName = getCell(colProgName);
        var pCode = getCell(colProgCode).toUpperCase();
        final fName = getCell(colFacName);
        final qual = getCell(colQual);
        final appr = getCell(colApproval);

        if (fName.isEmpty && pName.isEmpty) continue;

        // Auto-derive code if missing
        if (pCode.isEmpty && pName.isNotEmpty) {
          pCode = _deriveCode(pName);
        }

        if (pName.isNotEmpty && pCode.isNotEmpty) {
          programsMap[pCode] = ProgramInfo(code: pCode, name: pName);
        }

        if (fName.isNotEmpty) {
          faculties.add(FacultyInfo(
            name: fName,
            programCode: pCode.isNotEmpty ? pCode : 'CM',
            qualification: qual.isNotEmpty ? qual : 'B.E.',
            approvalStatus: appr.isNotEmpty ? appr : 'Approved',
          ));
        }
      }

      return ExcelParseFacultyResult(
        programs: programsMap.values.toList(),
        faculties: faculties,
      );
    } catch (e) {
      return ExcelParseFacultyResult(
        programs: [],
        faculties: [],
        error: 'Failed to parse Excel file: $e',
      );
    }
  }

  /// Parses the uploaded Subjects / Curriculum Excel sheet.
  /// Expects columns:
  /// Program Code | Semester | Course Abbreviation and Code
  static List<CourseInfo> parseSubjectSheet(List<int> bytes) {
    try {
      final excel = Excel.decodeBytes(bytes);
      final courses = <CourseInfo>[];

      if (excel.tables.isEmpty) return [];

      final sheet = excel.tables.values.first;
      if (sheet.rows.isEmpty) return [];

      int colProgCode = -1;
      int colSem = -1;
      int colCourse = -1;
      int colTh = -1;
      int colPr = -1;
      int colTu = -1;

      // Find header row
      int headerRowIdx = 0;
      for (var r = 0; r < sheet.rows.length && r < 5; r++) {
        final rowStr = sheet.rows[r].map((c) => c?.value?.toString().trim().toLowerCase() ?? '').join(' ');
        if (rowStr.contains('sem') || rowStr.contains('course') || rowStr.contains('prog')) {
          headerRowIdx = r;
          break;
        }
      }

      final headerRow = sheet.rows[headerRowIdx];
      for (var i = 0; i < headerRow.length; i++) {
        final val = headerRow[i]?.value?.toString().trim().toLowerCase() ?? '';
        if (val.isEmpty) continue;

        final tokens = val.split(RegExp(r'[\s/._\-\(\)]+'));

        if (tokens.contains('sem') || tokens.contains('semester') || val.contains('term')) {
          colSem = i;
        } else if (tokens.contains('th') || val.contains('theory')) {
          colTh = i;
        } else if (tokens.contains('pr') || val.contains('practical') || val.contains('pract')) {
          colPr = i;
        } else if (tokens.contains('tu') || tokens.contains('tut') || val.contains('tutorial')) {
          colTu = i;
        } else if (val.contains('prog') || val.contains('branch') || val.contains('dept')) {
          colProgCode = i;
        } else if (val.contains('course') || val.contains('subject') || (val.contains('code') && !val.contains('prog')) || val.contains('title')) {
          colCourse = i;
        }
      }

      if (colProgCode == -1) colProgCode = 0;
      if (colSem == -1) colSem = 1;
      if (colCourse == -1) colCourse = 2;
      if (colTh == -1 && headerRow.length > 3) colTh = 3;
      if (colPr == -1 && headerRow.length > 4) colPr = 4;
      if (colTu == -1 && headerRow.length > 5) colTu = 5;

      for (var r = headerRowIdx + 1; r < sheet.rows.length; r++) {
        final row = sheet.rows[r];
        if (row.isEmpty) continue;

        String getCell(int idx) {
          if (idx < 0 || idx >= row.length) return '';
          return row[idx]?.value?.toString().trim() ?? '';
        }

        var progCode = getCell(colProgCode).toUpperCase();
        final semRaw = getCell(colSem);
        final courseCode = getCell(colCourse);

        if (courseCode.isEmpty) continue;

        // Parse semester number (e.g. "1", "CM1", "Sem 3", "3K" -> 1, 3)
        final semMatch = RegExp(r'\d+').firstMatch(semRaw);
        final sem = semMatch != null ? int.tryParse(semMatch.group(0)!) ?? 1 : 1;

        // If progCode was in sem (e.g. "CM1" and progCode empty)
        if (progCode.isEmpty && semRaw.length >= 2) {
          final letters = RegExp(r'[A-Za-z]+').firstMatch(semRaw)?.group(0);
          if (letters != null) progCode = letters.toUpperCase();
        }

        if (progCode.isEmpty) progCode = 'CM';

        String normalizeHrs(String raw, {String fallback = 'NA'}) {
          final t = raw.trim();
          if (t.isEmpty) return fallback;
          if (t == '0' || t == '-' || t.toUpperCase() == 'NA') return 'NA';
          return t;
        }

        final thPres = normalizeHrs(colTh != -1 ? getCell(colTh) : '', fallback: '4');
        final prPres = normalizeHrs(colPr != -1 ? getCell(colPr) : '', fallback: 'NA');
        final tuPres = normalizeHrs(colTu != -1 ? getCell(colTu) : '', fallback: 'NA');

        courses.add(CourseInfo(
          programCode: progCode,
          semester: sem,
          courseCodeAndAbbr: courseCode,
          thPrescribed: thPres,
          prPrescribed: prPres,
          tuPrescribed: tuPres,
        ));
      }

      return courses;
    } catch (e) {
      return [];
    }
  }

  static String _deriveCode(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('computer')) return 'CM';
    if (lower.contains('info') || lower.contains('it')) return 'IT';
    if (lower.contains('mech')) return 'ME';
    if (lower.contains('civil')) return 'CE';
    if (lower.contains('electr')) return 'EE';
    return name.substring(0, 2).toUpperCase();
  }

  /// Creates a downloadable sample Excel sheet for Faculty & Programs
  static List<int> createSampleFacultyExcel() {
    final excel = Excel.createExcel();
    final defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
    final sheet = excel[defaultSheet];

    // Header row
    sheet.appendRow([
      TextCellValue('Program Name'),
      TextCellValue('Program Code'),
      TextCellValue('Faculty Name'),
      TextCellValue('Qualification'),
      TextCellValue('Faculty Approved'),
    ]);

    // Sample data
    final sampleRows = [
      ['Computer Technology', 'CM', 'Prof. A. B. Chaudhari', 'M.E. Computer', 'Regular + Approved'],
      ['Computer Technology', 'CM', 'Prof. S. R. Patil', 'M.Tech CSE', 'Regular + Approved'],
      ['Computer Technology', 'CM', 'Prof. M. N. Deshmukh', 'B.E. Computer', 'Approved'],
      ['Information Technology', 'IT', 'Prof. V. K. Sharma', 'M.E. IT', 'Regular + Approved'],
      ['Information Technology', 'IT', 'Prof. P. D. Joshi', 'B.E. IT', 'Approved'],
      ['Mechanical Engineering', 'ME', 'Prof. R. T. Shinde', 'M.E. Mechanical', 'Regular + Approved'],
      ['Mechanical Engineering', 'ME', 'Prof. K. S. Wagh', 'PhD Mechanical', 'Regular + Approved'],
      ['Civil Engineering', 'CE', 'Prof. N. G. Kulkarni', 'M.Tech Civil', 'Regular + Approved'],
      ['Electrical Engineering', 'EE', 'Prof. H. J. More', 'M.E. Electrical', 'Approved'],
    ];

    for (final row in sampleRows) {
      sheet.appendRow(row.map((e) => TextCellValue(e)).toList());
    }

    return excel.encode() ?? [];
  }

  /// Creates a downloadable sample Excel sheet for Subjects / Courses
  static List<int> createSampleSubjectExcel() {
    final excel = Excel.createExcel();
    final defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
    final sheet = excel[defaultSheet];

    sheet.appendRow([
      TextCellValue('Program Code'),
      TextCellValue('Semester'),
      TextCellValue('Course Abbreviation and Code'),
      TextCellValue('TH Prescribe Contact Hrs.'),
      TextCellValue('PR Prescribe Contact Hrs.'),
      TextCellValue('TU Prescribe Contact Hrs.'),
    ]);

    final sampleRows = [
      // CM Odd
      ['CM', '1', 'DCN-3111', '4', '2', 'NA'],
      ['CM', '1', 'BMS-3112', '4', 'NA', '2'],
      ['CM', '1', 'ENG-311001', '3', '2', 'NA'],
      ['CM', '3', 'OOP-313301', '4', '4', 'NA'],
      ['CM', '3', 'DSU-313302', '4', '4', 'NA'],
      ['CM', '3', 'DTE-313303', '4', '2', 'NA'],
      ['CM', '5', 'OSY-315301', '4', '2', 'NA'],
      ['CM', '5', 'AJP-315302', '4', '4', 'NA'],
      ['CM', '5', 'CSS-315303', '3', '2', 'NA'],
      // CM Even
      ['CM', '2', 'PIC-312301', '4', '4', 'NA'],
      ['CM', '2', 'WPD-312302', '3', '4', 'NA'],
      ['CM', '2', 'EEC-312303', '3', '2', 'NA'],
      ['CM', '4', 'JPR-314301', '4', '4', 'NA'],
      ['CM', '4', 'STE-314302', '3', '2', 'NA'],
      ['CM', '4', 'SEN-314303', '4', 'NA', 'NA'],
      ['CM', '6', 'MAD-316301', '4', '4', 'NA'],
      ['CM', '6', 'WBP-316302', '3', '4', 'NA'],
      ['CM', '6', 'MGT-316303', '3', 'NA', 'NA'],

      // IT Odd & Even
      ['IT', '1', 'ENG-311001', '3', '2', 'NA'],
      ['IT', '1', 'FOC-311401', '3', '2', 'NA'],
      ['IT', '2', 'PIC-312301', '4', '4', 'NA'],
      ['IT', '3', 'DBMS-313401', '4', '4', 'NA'],
      ['IT', '3', 'DSU-313302', '4', '4', 'NA'],
      ['IT', '4', 'JPR-314301', '4', '4', 'NA'],
      ['IT', '5', 'CNS-315402', '4', '2', 'NA'],
      ['IT', '6', 'CLD-316401', '4', '2', 'NA'],

      // ME Odd & Even
      ['ME', '1', 'EGM-311501', '3', '2', 'NA'],
      ['ME', '2', 'AMP-312501', '3', '4', 'NA'],
      ['ME', '3', 'PDR-313311', '4', '4', 'NA'],
      ['ME', '3', 'TEN-313312', '4', '2', 'NA'],
      ['ME', '3', 'SOM-313313', '4', '2', 'NA'],
      ['ME', '4', 'TOM-314501', '4', '2', 'NA'],
      ['ME', '5', 'DME-315501', '4', 'NA', 'NA'],
      ['ME', '6', 'CAD-316502', '2', '4', 'NA'],
    ];

    for (final row in sampleRows) {
      sheet.appendRow(row.map((e) => TextCellValue(e)).toList());
    }

    return excel.encode() ?? [];
  }

  /// Default programs seeded in the app
  static List<ProgramInfo> getDefaultPrograms() {
    return const [
      ProgramInfo(code: 'CM', name: 'Computer Technology'),
      ProgramInfo(code: 'IT', name: 'Information Technology'),
      ProgramInfo(code: 'ME', name: 'Mechanical Engineering'),
      ProgramInfo(code: 'CE', name: 'Civil Engineering'),
      ProgramInfo(code: 'EE', name: 'Electrical Engineering'),
    ];
  }

  /// Default faculties seeded in the app
  static List<FacultyInfo> getDefaultFaculties() {
    return const [
      // Computer Technology
      FacultyInfo(
        name: 'Prof. A. B. Chaudhari',
        programCode: 'CM',
        qualification: 'M.E. Computer',
        approvalStatus: 'Regular + Approved',
      ),
      FacultyInfo(
        name: 'Prof. S. R. Patil',
        programCode: 'CM',
        qualification: 'M.Tech CSE',
        approvalStatus: 'Regular + Approved',
      ),
      FacultyInfo(
        name: 'Prof. M. N. Deshmukh',
        programCode: 'CM',
        qualification: 'B.E. Computer',
        approvalStatus: 'Approved',
      ),
      FacultyInfo(
        name: 'Prof. P. V. Joshi',
        programCode: 'CM',
        qualification: 'PhD Computer',
        approvalStatus: 'Regular + Approved',
      ),

      // Information Technology
      FacultyInfo(
        name: 'Prof. V. K. Sharma',
        programCode: 'IT',
        qualification: 'M.E. IT',
        approvalStatus: 'Regular + Approved',
      ),
      FacultyInfo(
        name: 'Prof. P. D. Joshi',
        programCode: 'IT',
        qualification: 'B.E. IT',
        approvalStatus: 'Approved',
      ),
      FacultyInfo(
        name: 'Prof. S. S. More',
        programCode: 'IT',
        qualification: 'M.Tech IT',
        approvalStatus: 'Regular + Approved',
      ),

      // Mechanical Engineering
      FacultyInfo(
        name: 'Prof. R. T. Shinde',
        programCode: 'ME',
        qualification: 'M.E. Mechanical',
        approvalStatus: 'Regular + Approved',
      ),
      FacultyInfo(
        name: 'Prof. K. S. Wagh',
        programCode: 'ME',
        qualification: 'PhD Mechanical',
        approvalStatus: 'Regular + Approved',
      ),
      FacultyInfo(
        name: 'Prof. A. J. Jadhav',
        programCode: 'ME',
        qualification: 'M.Tech Production',
        approvalStatus: 'Approved',
      ),

      // Civil Engineering
      FacultyInfo(
        name: 'Prof. N. G. Kulkarni',
        programCode: 'CE',
        qualification: 'M.Tech Civil',
        approvalStatus: 'Regular + Approved',
      ),
      FacultyInfo(
        name: 'Prof. T. M. Sonawane',
        programCode: 'CE',
        qualification: 'B.E. Civil',
        approvalStatus: 'Approved',
      ),

      // Electrical Engineering
      FacultyInfo(
        name: 'Prof. H. J. More',
        programCode: 'EE',
        qualification: 'M.E. Electrical',
        approvalStatus: 'Regular + Approved',
      ),
      FacultyInfo(
        name: 'Prof. B. R. Pawar',
        programCode: 'EE',
        qualification: 'B.E. Electrical',
        approvalStatus: 'Approved',
      ),
    ];
  }

  /// Default courses seeded in the app
  static List<CourseInfo> getDefaultCourses() {
    return const [
      // CM Odd
      CourseInfo(programCode: 'CM', semester: 1, courseCodeAndAbbr: 'DCN-3111', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 1, courseCodeAndAbbr: 'BMS-3112', thPrescribed: '4', prPrescribed: 'NA', tuPrescribed: '2'),
      CourseInfo(programCode: 'CM', semester: 1, courseCodeAndAbbr: 'ENG-311001', thPrescribed: '3', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 1, courseCodeAndAbbr: 'BSC-311002', thPrescribed: '3', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 3, courseCodeAndAbbr: 'OOP-313301', thPrescribed: '4', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 3, courseCodeAndAbbr: 'DSU-313302', thPrescribed: '4', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 3, courseCodeAndAbbr: 'DTE-313303', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 3, courseCodeAndAbbr: 'DMS-313304', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 5, courseCodeAndAbbr: 'OSY-315301', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 5, courseCodeAndAbbr: 'AJP-315302', thPrescribed: '4', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 5, courseCodeAndAbbr: 'CSS-315303', thPrescribed: '3', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 5, courseCodeAndAbbr: 'EST-315304', thPrescribed: '3', prPrescribed: 'NA', tuPrescribed: 'NA'),

      // CM Even
      CourseInfo(programCode: 'CM', semester: 2, courseCodeAndAbbr: 'PIC-312301', thPrescribed: '4', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 2, courseCodeAndAbbr: 'WPD-312302', thPrescribed: '3', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 2, courseCodeAndAbbr: 'EEC-312303', thPrescribed: '3', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 2, courseCodeAndAbbr: 'AMI-312001', thPrescribed: '4', prPrescribed: 'NA', tuPrescribed: '2'),
      CourseInfo(programCode: 'CM', semester: 4, courseCodeAndAbbr: 'JPR-314301', thPrescribed: '4', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 4, courseCodeAndAbbr: 'STE-314302', thPrescribed: '3', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 4, courseCodeAndAbbr: 'SEN-314303', thPrescribed: '4', prPrescribed: 'NA', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 4, courseCodeAndAbbr: 'GAD-314304', thPrescribed: '2', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 6, courseCodeAndAbbr: 'MAD-316301', thPrescribed: '4', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 6, courseCodeAndAbbr: 'WBP-316302', thPrescribed: '3', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 6, courseCodeAndAbbr: 'MGT-316303', thPrescribed: '3', prPrescribed: 'NA', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CM', semester: 6, courseCodeAndAbbr: 'EDE-316304', thPrescribed: '2', prPrescribed: '2', tuPrescribed: 'NA'),

      // IT
      CourseInfo(programCode: 'IT', semester: 1, courseCodeAndAbbr: 'ENG-311001', thPrescribed: '3', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'IT', semester: 1, courseCodeAndAbbr: 'FOC-311401', thPrescribed: '3', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'IT', semester: 2, courseCodeAndAbbr: 'PIC-312301', thPrescribed: '4', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'IT', semester: 2, courseCodeAndAbbr: 'WPD-312302', thPrescribed: '3', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'IT', semester: 3, courseCodeAndAbbr: 'DBMS-313401', thPrescribed: '4', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'IT', semester: 3, courseCodeAndAbbr: 'DSU-313302', thPrescribed: '4', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'IT', semester: 4, courseCodeAndAbbr: 'JPR-314301', thPrescribed: '4', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'IT', semester: 4, courseCodeAndAbbr: 'SE-314402', thPrescribed: '4', prPrescribed: 'NA', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'IT', semester: 5, courseCodeAndAbbr: 'CNS-315402', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'IT', semester: 5, courseCodeAndAbbr: 'OS-315401', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'IT', semester: 6, courseCodeAndAbbr: 'CLD-316401', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'IT', semester: 6, courseCodeAndAbbr: 'AI-316402', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),

      // ME
      CourseInfo(programCode: 'ME', semester: 1, courseCodeAndAbbr: 'EGM-311501', thPrescribed: '3', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'ME', semester: 2, courseCodeAndAbbr: 'AMP-312501', thPrescribed: '3', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'ME', semester: 3, courseCodeAndAbbr: 'PDR-313311', thPrescribed: '4', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'ME', semester: 3, courseCodeAndAbbr: 'TEN-313312', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'ME', semester: 3, courseCodeAndAbbr: 'SOM-313313', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'ME', semester: 4, courseCodeAndAbbr: 'TOM-314501', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'ME', semester: 5, courseCodeAndAbbr: 'DME-315501', thPrescribed: '4', prPrescribed: 'NA', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'ME', semester: 6, courseCodeAndAbbr: 'CAD-316502', thPrescribed: '2', prPrescribed: '4', tuPrescribed: 'NA'),

      // CE
      CourseInfo(programCode: 'CE', semester: 1, courseCodeAndAbbr: 'ENG-311001', thPrescribed: '3', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CE', semester: 2, courseCodeAndAbbr: 'APM-312601', thPrescribed: '4', prPrescribed: 'NA', tuPrescribed: '2'),
      CourseInfo(programCode: 'CE', semester: 3, courseCodeAndAbbr: 'SUR-313601', thPrescribed: '4', prPrescribed: '4', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CE', semester: 4, courseCodeAndAbbr: 'GEO-314601', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CE', semester: 5, courseCodeAndAbbr: 'WRE-315601', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'CE', semester: 6, courseCodeAndAbbr: 'DRS-316601', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),

      // EE
      CourseInfo(programCode: 'EE', semester: 1, courseCodeAndAbbr: 'ENG-311001', thPrescribed: '3', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'EE', semester: 2, courseCodeAndAbbr: 'BEE-312701', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'EE', semester: 3, courseCodeAndAbbr: 'ECN-313701', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'EE', semester: 4, courseCodeAndAbbr: 'EEM-314701', thPrescribed: '3', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'EE', semester: 5, courseCodeAndAbbr: 'SAP-315701', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
      CourseInfo(programCode: 'EE', semester: 6, courseCodeAndAbbr: 'UEE-316701', thPrescribed: '4', prPrescribed: '2', tuPrescribed: 'NA'),
    ];
  }
}
