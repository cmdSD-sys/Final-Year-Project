import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/models/dept_info_model.dart';
import 'package:final_project/screens/dept_info_form_screen.dart';
import 'package:final_project/services/app_state.dart';
import 'package:final_project/services/cm_report_pdf_service.dart';
import 'package:final_project/theme/app_theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeptInfoModel Unit Tests', () {
    test('defaultSample initializes with correct CM department defaults', () {
      final sample = DeptInfoModel.defaultSample();
      expect(sample.departmentName, equals('Computer Technology'));
      expect(sample.academicYear, equals('2024-25'));
      expect(sample.visionMissionPrepared, equals('Yes'));
      expect(sample.visionMissionApprovalDate, equals('20/06/2017'));
      expect(sample.nbaAccreditation, equals('Accreditated'));
      expect(sample.nbaValidFrom, equals('1-7-2023'));
      expect(sample.nbaValidTill, equals('30-6-2026'));
      expect(sample.internalAuditOnce6Months, equals('Yes'));
      expect(sample.internalAuditDate, equals('11-09-2026'));
      expect(sample.smartClassroomAvailable, equals('Yes'));
      expect(sample.biometricAttendanceAvailable, equals('Yes'));
      expect(sample.techJournalsCount, equals(6));
      expect(sample.remedialLectures, equals('Implemented'));
      expect(sample.industrialTrainingAssessment, equals('100% Eligible Students'));
      expect(sample.parentMeet, equals('Conducted and Documents well maintained'));
    });

    test('toJson and fromJson preserves all fields accurately', () {
      final original = DeptInfoModel.defaultSample().copyWith(
        academicYear: '2025-26',
        techJournalsCount: 12,
        internalAuditSuggestions: 'Increase hands-on lab sessions',
        internalAuditCorrectiveAction: 'Added 4 extra lab batches',
      );

      final jsonMap = original.toJson();
      final reconstructed = DeptInfoModel.fromJson(jsonMap);

      expect(reconstructed.academicYear, equals('2025-26'));
      expect(reconstructed.techJournalsCount, equals(12));
      expect(reconstructed.internalAuditSuggestions, equals('Increase hands-on lab sessions'));
      expect(reconstructed.internalAuditCorrectiveAction, equals('Added 4 extra lab batches'));
      expect(reconstructed.departmentName, equals(original.departmentName));
      expect(reconstructed.nbaAccreditation, equals(original.nbaAccreditation));
    });

    test('AppState properly holds and updates DeptInfoModel', () {
      final appState = AppState();
      expect(appState.currentDeptInfo.departmentName, equals('Computer Technology'));

      final modified = appState.currentDeptInfo.copyWith(academicYear: '2026-27');
      var notified = false;
      appState.addListener(() => notified = true);

      appState.updateDeptInfo(modified);
      expect(appState.currentDeptInfo.academicYear, equals('2026-27'));
      expect(notified, isTrue);
    });

    test('CmReportPdfService produces authentic 20-page PDF with injected values', () async {
      final model = DeptInfoModel.defaultSample().copyWith(
        academicYear: '2024-25',
        visionMissionApprovalDate: '20/06/2017',
      );

      final Uint8List pdfBytes = await CmReportPdfService.generateCmReportPdf(data: model);
      expect(pdfBytes, isNotNull);
      expect(pdfBytes.length, greaterThan(10000));

      // Check PDF header signature: %PDF-
      final header = String.fromCharCodes(pdfBytes.sublist(0, 5));
      expect(header, equals('%PDF-'));

      // Verify that all 20 pages are present
      final doc = PdfDocument(inputBytes: pdfBytes);
      expect(doc.pages.count, equals(20));
      doc.dispose();
    });

    testWidgets('DeptInfoFormScreen renders Back button, 11 tabs, and matching theme',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final appState = AppState();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: DeptInfoFormScreen(appState: appState),
        ),
      );

      // Verify Back button tooltip / icon
      expect(find.byTooltip('Back to Dashboard'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);

      // Verify App Bar title and action buttons
      expect(find.text('MSBTE Monitoring Report (CM)'), findsOneWidget);
      expect(find.text('Export PDF'), findsOneWidget);
      expect(find.text('Save Changes'), findsNWidgets(2)); // AppBar and bottom bar

      // Verify the 11 section chips
      expect(find.text('1. Dept Information'), findsOneWidget);
      expect(find.text('2. Admission'), findsOneWidget);
      expect(find.text('11. Any Other Information'), findsOneWidget);

      // Verify Department Selected banner
      expect(find.text('Department Selected : Computer Technology (CM)'), findsOneWidget);
      expect(find.text('CM Exclusive'), findsOneWidget);

      // Verify Form fields
      expect(find.text('Computer Technology'), findsOneWidget);
      expect(find.text('2024-25'), findsOneWidget);

      Future<void> tapVisible(Finder finder) async {
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }

      // Verify date picker opens on calendar button tap
      final calFinder = find.byTooltip('Choose date from calendar');
      expect(calFinder, findsWidgets);
      await tapVisible(calFinder.first);
      // Date picker dialog is displayed
      expect(find.byType(DatePickerDialog), findsOneWidget);
      // Cancel date picker dialog
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Test Tab 2: Admission
      await tapVisible(find.text('2. Admission'));
      expect(find.text('Dept Admission Status'), findsOneWidget);
      expect(find.textContaining('Analysis of 1st Year Admission'), findsOneWidget);

      // Test Tab 3: Faculty Strength
      await tapVisible(find.text('3. Faculty Strength'));
      expect(find.text('Dept Faculty Strength'), findsOneWidget);
      expect(find.text('1. Required as per Norms vs Filled Posts'), findsOneWidget);

      // Test Tab 4: Faculty Profile
      await tapVisible(find.text('4. Faculty Profile'));
      expect(find.text('Dept Faculty Profile'), findsOneWidget);
      expect(find.text('BHOSALE MANJUSHA PANKAJ'), findsOneWidget);

      // Test Tab 5: Laboratory
      await tapVisible(find.text('5. Laboratory'));
      expect(find.text('Laboratory Information'), findsOneWidget);
      expect(find.text('WEB APPLICATION LABORATORY'), findsOneWidget);

      // Test Tab 6: Curriculum
      await tapVisible(find.text('6. Curriculum'));
      expect(find.text('Dept Curriculum Information'), findsOneWidget);

      // Test Tab 7: Student Attendance
      await tapVisible(find.text('7. Student Attendance'));
      expect(find.text('Dept Student Attendance'), findsOneWidget);

      // Test Tab 8: Result Analysis
      await tapVisible(find.text('8. Result Analysis'));
      expect(find.text('Result Analysis'), findsOneWidget);

      // Test Tab 9: Resources
      await tapVisible(find.text('9. Resources'));
      expect(find.text('Dept Learning Resources'), findsOneWidget);

      // Test Tab 10: Co-Curricular Activities
      await tapVisible(find.text('10. Co-Curricular Activities'));
      expect(find.text('Co-Curricular Activities'), findsOneWidget);

      // Test Tab 11: Any Other Information
      await tapVisible(find.text('11. Any Other Information'));
      expect(find.text('Any Other Information'), findsOneWidget);
      expect(find.text('Quality of Test Papers *'), findsOneWidget);
    });
  });
}
