import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/models/models.dart';
import 'package:final_project/services/app_state.dart';
import 'package:final_project/utils/app_snack_bar.dart';
import 'package:final_project/widgets/app_navigation_drawer.dart';
import 'package:final_project/widgets/catalog_preview_dialog.dart';
import 'package:final_project/widgets/settings_dialog.dart';
import 'package:final_project/widgets/submission_details_dialog.dart';

void main() {
  testWidgets('SettingsDialog renders without ListTile assertion and updates name',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();
    appState.setRole(AppRole.admin);
    expect(appState.currentUserName, 'Administrator');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => SettingsDialog(appState: appState),
              ),
              child: const Text('Open Settings'),
            ),
          ),
        ),
      ),
    );

    // Open settings dialog
    await tester.tap(find.text('Open Settings'));
    await tester.pumpAndSettle();

    // Verify dialog header and sections exist
    expect(find.text('Application Settings'), findsOneWidget);
    expect(find.text('Profile & Identity'), findsOneWidget);
    expect(find.text('Appearance & Theme Preferences'), findsOneWidget);
    expect(find.text('Dark Mode Theme'), findsOneWidget);

    // Verify name field has current name
    expect(find.widgetWithText(TextFormField, 'Administrator'), findsOneWidget);

    // Enter a new name
    final nameField = find.byType(TextFormField);
    await tester.enterText(nameField, 'Prof. Alex Mercer');
    await tester.tap(find.text('Save Name'));
    await tester.pumpAndSettle();

    expect(appState.currentUserName, 'Prof. Alex Mercer');
  });

  testWidgets('SubmissionDetailsDialog renders metadata chips and rows in dark mode',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final submission = MonitoringSubmission(
      id: 'TEST-001',
      submittedAt: DateTime.now(),
      semesterType: 'Odd',
      programCode: 'CM',
      programName: 'Computer Technology',
      nbaStatus: 'Accredited',
      weeksDoneYear1: 14,
      weeksDoneYear2: 12,
      weeksDoneYear3: 10,
      rows: [
        MonitoringRowEntry(
          srNo: 1,
          facultyName: 'Dr. Jane Smith',
          qualification: 'Ph.D, M.E.',
          facultyApproved: 'Yes',
          branchSemScheme: 'CM5K',
          courseAbbreviationCode: 'DCN (22515)',
          k1: 'Yes',
          k2: 'Yes',
          k3: 'Yes',
          k6: 'Records Checked',
          k7: 'Yes',
          thPrescribed: '40',
          prPrescribed: '20',
          tuPrescribed: 'NA',
          thActual: '38',
          prActual: '20',
          tuActual: 'NA',
        ),
      ],
    );

    bool exportCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => SubmissionDetailsDialog.show(
                context,
                submission: submission,
                onExport: () => exportCalled = true,
              ),
              child: const Text('Open Preview'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Preview'));
    await tester.pumpAndSettle();

    expect(find.text('Submission Details'), findsOneWidget);
    expect(find.text('ID: TEST-001'), findsOneWidget);
    expect(find.text('Computer Technology (CM)'), findsOneWidget);
    expect(find.text('Dr. Jane Smith'), findsOneWidget);
    expect(find.text('Course: DCN (22515)'), findsOneWidget);
    expect(find.text('Export docx'), findsOneWidget);

    await tester.tap(find.text('Export docx'));
    await tester.pumpAndSettle();
    expect(exportCalled, isTrue);
  });

  testWidgets('AppSnackBar renders modern styled floating snackbar',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => AppSnackBar.showSuccess(
                context,
                'Operation succeeded smoothly!',
              ),
              child: const Text('Show Snack'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Snack'));
    await tester.pump(); // Start animation
    await tester.pump(const Duration(milliseconds: 300)); // Finish entrance

    expect(find.text('Operation succeeded smoothly!'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('AppNavigationDrawer displays SUPER ADMIN OPTIONS and opens SuperAdminUserDialog',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();
    appState.setRole(AppRole.superAdmin);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              child: const Text('Open Drawer'),
            ),
          ),
          drawer: AppNavigationDrawer(appState: appState),
        ),
      ),
    );

    // Open drawer
    await tester.tap(find.text('Open Drawer'));
    await tester.pumpAndSettle();

    // Verify Super Admin section
    expect(find.text('Super admin options'), findsOneWidget);
    expect(find.text('User Authority & Roles'), findsOneWidget);
    expect(find.text('Authority: Super Admin'), findsOneWidget);

    // Open Super Admin User Dialog
    await tester.tap(find.text('User Authority & Roles'));
    await tester.pumpAndSettle();

    // Verify Super Admin Dialog elements
    expect(find.text('Super Admin View'), findsOneWidget);
    expect(find.text('All Depts'), findsOneWidget);
    expect(find.text('CM'), findsOneWidget);
    expect(find.text('IT'), findsOneWidget);
    expect(find.text('ME'), findsOneWidget);
    expect(find.text('CE'), findsOneWidget);
  });

  testWidgets('CatalogPreviewDialog renders Clear Faculties and Clear Courses buttons for Admin',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();
    appState.setRole(AppRole.superAdmin);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => CatalogPreviewDialog(appState: appState),
              ),
              child: const Text('Open Catalog'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Catalog'));
    await tester.pumpAndSettle();

    // Verify Tab 1 (Faculties) shows Clear All
    expect(find.text('Clear All'), findsOneWidget);
    expect(find.byIcon(Icons.delete_sweep), findsOneWidget);

    // Switch to Tab 2 (Subjects & Semesters)
    await tester.tap(find.text('Subjects & Semesters'));
    await tester.pumpAndSettle();

    // Verify Tab 2 (Courses) shows Clear All
    expect(find.text('Clear All'), findsOneWidget);
    expect(find.byIcon(Icons.delete_sweep), findsOneWidget);
  });
}
