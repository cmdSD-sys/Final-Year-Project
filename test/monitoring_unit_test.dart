import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/models/models.dart';
import 'package:final_project/services/app_state.dart';
import 'package:final_project/services/docx_service.dart';
import 'package:final_project/services/excel_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppState & Data Lookups', () {
    test('Sample demo data can be loaded and queried', () {
      final state = AppState();
      // App starts empty by design (data is upload-driven)
      expect(state.programs.isEmpty, isTrue);
      expect(state.faculties.isEmpty, isTrue);
      expect(state.courses.isEmpty, isTrue);

      // After loading sample data, lookups should work
      state.loadSampleDemoData();
      expect(state.programs.isNotEmpty, isTrue);
      expect(state.faculties.isNotEmpty, isTrue);
      expect(state.courses.isNotEmpty, isTrue);

      final cmFaculties = state.getFacultiesForProgram('CM');
      expect(cmFaculties.isNotEmpty, isTrue);
      expect(cmFaculties.any((f) => f.name.contains('Chaudhari')), isTrue);

      final cmSem1Courses = state.getCourses('CM', 1);
      expect(cmSem1Courses.isNotEmpty, isTrue);
      expect(cmSem1Courses.any((c) => c.courseCodeAndAbbr.contains('DCN-3111')), isTrue);
    });

    test('Saving a submission adds it to submissions list', () {
      final state = AppState();
      final initialCount = state.submissions.length;

      final newSub = MonitoringSubmission(
        id: 'TEST-1',
        programName: 'Mechanical Engineering',
        programCode: 'ME',
        semesterType: 'ODD',
        submittedAt: DateTime.now(),
        rows: [
          MonitoringRowEntry(
            srNo: 1,
            facultyName: 'Prof. R. T. Shinde',
            branchSemScheme: 'ME3K',
            qualification: 'M.E. Mechanical',
            facultyApproved: 'Regular + Approved',
            courseAbbreviationCode: 'PDR-313311',
          ),
        ],
      );

      state.saveSubmission(newSub);
      expect(state.submissions.length, equals(initialCount + 1));
      expect(state.submissions.first.id, equals('TEST-1'));

      state.deleteSubmission('TEST-1');
      expect(state.submissions.length, equals(initialCount));
      expect(state.submissions.any((s) => s.id == 'TEST-1'), isFalse);
    });
  });

  group('ExcelService Tests', () {
    test('Can generate and parse sample Faculty Excel with correct columns', () {
      final excelBytes = ExcelService.createSampleFacultyExcel();
      expect(excelBytes.isNotEmpty, isTrue);

      final parseResult = ExcelService.parseFacultySheet(excelBytes);
      expect(parseResult.error, isNull);
      expect(parseResult.programs.isNotEmpty, isTrue);
      expect(parseResult.faculties.isNotEmpty, isTrue);

      // Verify that Faculty Name was NOT parsed as Approval Status
      for (final f in parseResult.faculties) {
        expect(f.name.contains('Approved'), isFalse,
            reason: 'Faculty name should not contain "Approved": ${f.name}');
        expect(f.name.startsWith('Prof.'), isTrue,
            reason: 'Faculty name should start with "Prof.": ${f.name}');
      }

      final firstFaculty = parseResult.faculties.first;
      expect(firstFaculty.name, equals('Prof. A. B. Chaudhari'));
      expect(firstFaculty.qualification, equals('M.E. Computer'));
      expect(firstFaculty.approvalStatus, equals('Regular + Approved'));
      expect(firstFaculty.programCode, equals('CM'));
    });

    test('Can parse root Sample_Faculty_Program_Sheet.xlsx without column confusion', () {
      final file = File('Sample_Faculty_Program_Sheet.xlsx');
      if (file.existsSync()) {
        final parseResult = ExcelService.parseFacultySheet(file.readAsBytesSync());
        expect(parseResult.error, isNull);
        expect(parseResult.faculties.isNotEmpty, isTrue);

        for (final f in parseResult.faculties) {
          expect(f.name.contains('Approved'), isFalse);
          expect(f.name.startsWith('Prof.'), isTrue);
        }
      }
    });

    test('Can generate and parse sample Subject Excel with TH, PR, TU hours', () {
      final excelBytes = ExcelService.createSampleSubjectExcel();
      expect(excelBytes.isNotEmpty, isTrue);

      final courses = ExcelService.parseSubjectSheet(excelBytes);
      expect(courses.isNotEmpty, isTrue);

      final dcn = courses.firstWhere((c) => c.courseCodeAndAbbr == 'DCN-3111');
      expect(dcn.thPrescribed, equals('4'));
      expect(dcn.prPrescribed, equals('2'));
      expect(dcn.tuPrescribed, equals('NA'));

      final bms = courses.firstWhere((c) => c.courseCodeAndAbbr == 'BMS-3112');
      expect(bms.thPrescribed, equals('4'));
      expect(bms.prPrescribed, equals('NA'));
      expect(bms.tuPrescribed, equals('2'));
    });

    test('Can parse root Sample_Subject_Curriculum_Sheet.xlsx with TH, PR, TU columns', () {
      final file = File('Sample_Subject_Curriculum_Sheet.xlsx');
      if (file.existsSync()) {
        final courses = ExcelService.parseSubjectSheet(file.readAsBytesSync());
        expect(courses.isNotEmpty, isTrue);
        expect(courses.any((c) => c.courseCodeAndAbbr.contains('DCN-3111')), isTrue);
      }
    });
  });

  group('DocxService Tests', () {
    test('Generates valid docx with contact hours multiplication on row 4 and prescribed hours on row 5', () async {
      final templateFile = File('format/Format.docx');
      expect(templateFile.existsSync(), isTrue);
      final templateBytes = await templateFile.readAsBytes();

      final submission = MonitoringSubmission(
        id: 'TEST-DOCX-1',
        programName: 'Computer Technology',
        programCode: 'CM',
        semesterType: 'ODD',
        nbaStatus: 'Accredited',
        weeksDone: 5,
        submittedAt: DateTime.now(),
        rows: [
          MonitoringRowEntry(
            srNo: 1,
            facultyName: 'Prof. A. B. Chaudhari',
            branchSemScheme: 'CM1K',
            qualification: 'M.E. Computer',
            facultyApproved: 'Regular + Approved',
            courseAbbreviationCode: 'DCN-3111',
            thPrescribed: '4',
            prPrescribed: '2',
            tuPrescribed: 'NA',
          ),
          MonitoringRowEntry(
            srNo: 2,
            facultyName: 'Prof. S. R. Patil',
            branchSemScheme: 'CM1K',
            qualification: 'M.Tech CSE',
            facultyApproved: 'Regular + Approved',
            courseAbbreviationCode: 'BMS-3112',
            thPrescribed: '4',
            prPrescribed: 'NA',
            tuPrescribed: '2',
          ),
        ],
      );

      final docxBytes = await DocxService.generateDocx(
        submission: submission,
        templateBytes: templateBytes,
      );

      expect(docxBytes.isNotEmpty, isTrue);
      expect(docxBytes.length, greaterThan(50000));

      // Unpack docx archive and check generated document.xml content
      final archive = ZipDecoder().decodeBytes(docxBytes);
      final docXml = archive.firstWhere((f) => f.name == 'word/document.xml');
      final xml = utf8.decode(docXml.content as List<int>);

      final tblMatch = RegExp(r'<w:tbl[\s>].*?<\/w:tbl>', dotAll: true).firstMatch(xml);
      expect(tblMatch, isNotNull);

      final rowMatches = RegExp(r'<w:tr[\s>].*?<\/w:tr>', dotAll: true).allMatches(tblMatch!.group(0)!).toList();
      // Row 4: Multiplied with weeksDone=5 (4*5 = 20, 2*5 = 10, NA)
      final r4 = rowMatches[4].group(0)!;
      expect(r4.contains('<w:t>20</w:t>'), isTrue);
      expect(r4.contains('<w:t>10</w:t>'), isTrue);

      // Row 5: Prescribed Contact Hrs default 10 weeks (4*10 = 40, 2*10 = 20, NA)
      final r5 = rowMatches[5].group(0)!;
      expect(r5.contains('<w:t>40</w:t>'), isTrue);
      expect(r5.contains('<w:t>20</w:t>'), isTrue);

      // Row 6: Multiplied for Entry 2 with weeksDone=5 (4*5 = 20, NA, 2*5 = 10)
      final r6 = rowMatches[6].group(0)!;
      expect(r6.contains('<w:t>20</w:t>'), isTrue);
      expect(r6.contains('<w:t>10</w:t>'), isTrue);
    });

    test('Generates docx with 3 distinct academic year weeks done applied correctly to corresponding subjects', () async {
      final templateBytes = await File('format/Format.docx').readAsBytes();

      final submission = MonitoringSubmission(
        id: 'TEST-3YEAR-1',
        programName: 'Computer Technology',
        programCode: 'CM',
        semesterType: 'ODD',
        nbaStatus: 'Accredited',
        weeksDoneYear1: 4, // 1st Year (CM1K): 4 wks
        weeksDoneYear2: 6, // 2nd Year (CM3K): 6 wks
        weeksDoneYear3: 8, // 3rd Year (CM5K): 8 wks
        submittedAt: DateTime.now(),
        rows: [
          MonitoringRowEntry(
            srNo: 1,
            facultyName: 'Prof. Year One',
            branchSemScheme: 'CM1K',
            qualification: 'M.E.',
            facultyApproved: 'Regular + Approved',
            courseAbbreviationCode: 'DCN-3111',
            thPrescribed: '4',
            prPrescribed: '2',
            tuPrescribed: 'NA',
          ),
          MonitoringRowEntry(
            srNo: 2,
            facultyName: 'Prof. Year Two',
            branchSemScheme: 'CM3K',
            qualification: 'M.E.',
            facultyApproved: 'Regular + Approved',
            courseAbbreviationCode: 'OOP-3311',
            thPrescribed: '4',
            prPrescribed: 'NA',
            tuPrescribed: '2',
          ),
          MonitoringRowEntry(
            srNo: 3,
            facultyName: 'Prof. Year Three',
            branchSemScheme: 'CM5K',
            qualification: 'Ph.D',
            facultyApproved: 'Regular + Approved',
            courseAbbreviationCode: 'MAD-3511',
            thPrescribed: '4',
            prPrescribed: '2',
            tuPrescribed: 'NA',
          ),
        ],
      );

      final docxBytes = await DocxService.generateDocx(
        submission: submission,
        templateBytes: templateBytes,
      );

      final archive = ZipDecoder().decodeBytes(docxBytes);
      final docXml = archive.firstWhere((f) => f.name == 'word/document.xml');
      final xml = utf8.decode(docXml.content as List<int>);

      final tblMatch = RegExp(r'<w:tbl[\s>].*?<\/w:tbl>', dotAll: true).firstMatch(xml);
      expect(tblMatch, isNotNull);

      final rowMatches = RegExp(r'<w:tr[\s>].*?<\/w:tr>', dotAll: true).allMatches(tblMatch!.group(0)!).toList();

      // Row 4 (Entry 1, CM1K, Year 1, 4 wks): 4*4 = 16 TH, 2*4 = 8 PR
      final r4 = rowMatches[4].group(0)!;
      expect(r4.contains('<w:t>16</w:t>'), isTrue);
      expect(r4.contains('<w:t>8</w:t>'), isTrue);

      // Row 6 (Entry 2, CM3K, Year 2, 6 wks): 4*6 = 24 TH, 2*6 = 12 TU
      final r6 = rowMatches[6].group(0)!;
      expect(r6.contains('<w:t>24</w:t>'), isTrue);
      expect(r6.contains('<w:t>12</w:t>'), isTrue);

      // Row 8 (Entry 3, CM5K, Year 3, 8 wks): 4*8 = 32 TH, 2*8 = 16 PR
      final r8 = rowMatches[8].group(0)!;
      expect(r8.contains('<w:t>32</w:t>'), isTrue);
      expect(r8.contains('<w:t>16</w:t>'), isTrue);

      // Verify placeholder 'FY 5 Weeks, SY 10 Weeks, TY 3 Weeks' was replaced with real data
      expect(xml.contains('FY 5 Weeks, SY 10 Weeks, TY 3 Weeks'), isFalse);
      expect(xml.contains('FY 4 Weeks, SY 6 Weeks, TY 8 Weeks'), isTrue);
    });
  });
}
