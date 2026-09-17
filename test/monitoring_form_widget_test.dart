import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/models/models.dart';
import 'package:final_project/screens/admin_dashboard_screen.dart';
import 'package:final_project/screens/monitoring_form_screen.dart';
import 'package:final_project/screens/user_home_screen.dart';
import 'package:final_project/services/app_state.dart';

void main() {
  testWidgets('UserHomeScreen displays the exact requested format title',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();
    await tester.pumpWidget(
      MaterialApp(
        home: UserHomeScreen(appState: appState),
      ),
    );

    // Verify exact option name requested by user
    expect(
      find.text(
          'Internal Institute Monitoring Format Internal Institute Monitoring Format'),
      findsOneWidget,
    );
  });

  testWidgets(
      'MonitoringFormScreen renders Odd/Even dropdown, Program dropdown, and row cards',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();
    appState.loadSampleDemoData();

    await tester.pumpWidget(
      MaterialApp(
        home: MonitoringFormScreen(appState: appState),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Semester Type'), findsOneWidget);
    expect(find.text('Program / Branch'), findsOneWidget);
    expect(find.text('NBA Status'), findsOneWidget);
    expect(find.text('1st Year (1st & 2nd Sem) Weeks'), findsOneWidget);
    expect(find.text('2nd Year (3rd & 4th Sem) Weeks'), findsOneWidget);
    expect(find.text('3rd Year (5th & 6th Sem) Weeks'), findsOneWidget);
    expect(find.text('No. of Data to Fill Out'), findsOneWidget);

    // Initial rows should be Row #1 and Row #2
    expect(find.text('Row #1 - Faculty Entry'), findsOneWidget);
    expect(find.text('Row #2 - Faculty Entry'), findsOneWidget);

    // Scroll ListView to reveal the save button
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    final saveBtn = find.text('Save Monitoring Form (2 Entries)');
    expect(saveBtn, findsOneWidget);
  });

  testWidgets(
      'MonitoringFormScreen renders 3-year weeks done dropdowns and updates individual years correctly',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();
    appState.loadSampleDemoData();

    await tester.pumpWidget(
      MaterialApp(
        home: MonitoringFormScreen(appState: appState),
      ),
    );
    await tester.pumpAndSettle();

    // Verify all 3 dropdowns display '10 Weeks Done' by default
    expect(find.text('10 Weeks Done'), findsNWidgets(3));

    // Change 2nd Year weeks done to 12 Weeks Done
    await tester.tap(find.text('10 Weeks Done').at(1));
    await tester.pumpAndSettle();

    await tester.tap(find.text('12 Weeks Done').last);
    await tester.pumpAndSettle();

    expect(find.text('12 Weeks Done'), findsOneWidget);
    // The other two years should still show 10 Weeks Done
    expect(find.text('10 Weeks Done'), findsNWidgets(2));
  });

  testWidgets(
      'AdminDashboardScreen displays the exact format title and Fill Form button',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();
    appState.loadSampleDemoData();
    appState.saveSubmission(
      MonitoringSubmission(
        id: 'TEST-ADMIN-1',
        programName: 'Computer Technology',
        programCode: 'CM',
        semesterType: 'ODD',
        submittedAt: DateTime.now(),
        rows: [
          MonitoringRowEntry(
            srNo: 1,
            facultyName: 'Prof. A. B. Chaudhari',
            branchSemScheme: 'CM1K',
            qualification: 'M.E. Computer',
            facultyApproved: 'Regular + Approved',
            courseAbbreviationCode: 'DCN-3111',
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdminDashboardScreen(appState: appState),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Admin can also see the exact requested format title
    expect(
      find.text(
          'Internal Institute Monitoring Format Internal Institute Monitoring Format'),
      findsOneWidget,
    );
    expect(find.text('Fill Form'), findsOneWidget);
    expect(find.text('Export docx'), findsWidgets);
  });

  testWidgets(
      'AdminDashboardScreen clicking Export docx opens custom location options sheet',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();
    appState.loadSampleDemoData();
    appState.saveSubmission(
      MonitoringSubmission(
        id: 'TEST-ADMIN-1',
        programName: 'Computer Technology',
        programCode: 'CM',
        semesterType: 'ODD',
        submittedAt: DateTime.now(),
        rows: [
          MonitoringRowEntry(
            srNo: 1,
            facultyName: 'Prof. A. B. Chaudhari',
            branchSemScheme: 'CM1K',
            qualification: 'M.E. Computer',
            facultyApproved: 'Regular + Approved',
            courseAbbreviationCode: 'DCN-3111',
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdminDashboardScreen(appState: appState),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final exportBtn = find.text('Export docx').first;
    await tester.ensureVisible(exportBtn);
    await tester.tap(exportBtn);
    await tester.pumpAndSettle();

    // Verify the Export Options sheet is shown with Custom Location and Quick Save
    expect(find.text('Export docx Document'), findsOneWidget);
    expect(find.text('Save to Custom Location (Save As...)'), findsOneWidget);
    expect(find.text('Quick Save to Downloads Folder'), findsOneWidget);
  });

  testWidgets(
      'MonitoringFormScreen displays duplicate warning badge and tooltip when faculty is reused across rows',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();
    appState.loadSampleDemoData();

    await tester.pumpWidget(
      MaterialApp(
        home: MonitoringFormScreen(appState: appState),
      ),
    );
    await tester.pumpAndSettle();

    // Select 'Prof. A. B. Chaudhari' in Row #1
    final facultyDropdownRow1 = find.text('Select Faculty').first;
    await tester.ensureVisible(facultyDropdownRow1);
    await tester.tap(facultyDropdownRow1, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Pick Prof. A. B. Chaudhari in Row 1
    await tester.tap(find.text('Prof. A. B. Chaudhari').last);
    await tester.pumpAndSettle();

    // In Row #1, the selected faculty is now Prof. A. B. Chaudhari
    expect(find.text('Prof. A. B. Chaudhari'), findsOneWidget);

    // Now open Row #2's faculty dropdown
    final facultyDropdownRow2 = find.text('Select Faculty').first;
    await tester.ensureVisible(facultyDropdownRow2);
    await tester.tap(facultyDropdownRow2, warnIfMissed: false);
    await tester.pumpAndSettle();

    // In Row #2 dropdown items, Prof. A. B. Chaudhari should display a warning badge 'Row 1'
    expect(find.text('Row 1'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    expect(find.byTooltip('Used in Row 1'), findsOneWidget);
  });

  testWidgets(
      'AdminDashboardScreen catalog preview dialog filters faculties and dynamic semester subjects',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();
    appState.loadSampleDemoData();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdminDashboardScreen(appState: appState),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Open catalog dialog via Navigation Drawer
    final profileLeading = find.byIcon(Icons.person).first;
    await tester.tap(profileLeading);
    await tester.pumpAndSettle();

    final viewCatalogTile = find.text('Active Catalog');
    await tester.tap(viewCatalogTile);
    await tester.pumpAndSettle();

    // Verify dialog opened
    expect(find.text('Active Curriculum & Faculty Catalog'), findsOneWidget);
    expect(find.text('Filter Department'), findsOneWidget);

    // Switch to Tab 2: Subjects & Semesters
    await tester.tap(find.text('Subjects & Semesters'));
    await tester.pumpAndSettle();

    // Department filter is present
    expect(find.text('1. Select Department'), findsOneWidget);
    // Semester filter is NOT present when 'All Departments' is selected
    expect(find.text('2. Select Semester'), findsNothing);

    // Select 'Computer Technology (CM)' in department filter
    await tester.tap(find.text('All Departments (All Subjects)'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Computer Technology (CM)').last);
    await tester.pumpAndSettle();

    // Now '2. Select Semester' dynamically appears!
    expect(find.text('2. Select Semester'), findsOneWidget);
  });

  testWidgets(
      'UserHomeScreen renders new dashboard title and opens Navigation Drawer with User profile & Logout',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();
    appState.setRole(AppRole.user);

    await tester.pumpWidget(
      MaterialApp(
        home: UserHomeScreen(appState: appState),
      ),
    );
    await tester.pumpAndSettle();

    // Verify AppBar title
    expect(
      find.text('K.K. Wagh Polytechnic, Nashik - User Dashboard'),
      findsOneWidget,
    );

    // Profile picture circle on AppBar
    final profileLeading = find.byIcon(Icons.person).first;
    expect(profileLeading, findsOneWidget);

    // Tap profile picture to open drawer
    await tester.tap(profileLeading);
    await tester.pumpAndSettle();

    // Verify drawer contents for User
    expect(find.text('Faculty Member'), findsOneWidget);
    expect(find.text('Authority: User'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
    // User drawer should NOT show Admin-only options
    expect(find.text('Create User'), findsNothing);
    expect(find.text('Upload Excel Sheets'), findsNothing);
  });

  testWidgets(
      'AdminDashboardScreen opens Navigation Drawer with Admin profile, Create User, and Excel Upload Dialog',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();
    appState.setRole(AppRole.admin);

    await tester.pumpWidget(
      MaterialApp(
        home: AdminDashboardScreen(appState: appState),
      ),
    );
    await tester.pumpAndSettle();

    // Verify AppBar title
    expect(
      find.text('K.K. Wagh Polytechnic, Nashik - Admin Dashboard'),
      findsOneWidget,
    );

    // Tap profile picture to open drawer
    final profileLeading = find.byIcon(Icons.person).first;
    await tester.tap(profileLeading);
    await tester.pumpAndSettle();

    // Verify drawer contents for Admin
    expect(find.text('Administrator'), findsOneWidget);
    expect(find.text('Authority: Admin'), findsOneWidget);
    expect(find.text('Upload Excel Sheets'), findsOneWidget);
    expect(find.text('Create User'), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);

    // Tap 'Create User' to open Create User Dialog
    await tester.tap(find.text('Create User'));
    await tester.pumpAndSettle();

    // Verify Create User Dialog fields
    expect(find.text('Create New User'), findsOneWidget);
    expect(find.text('Full Name *'), findsOneWidget);
    expect(find.text('Email Address *'), findsOneWidget);
    expect(find.text('Password *'), findsOneWidget);
    expect(find.text('Confirm Password *'), findsOneWidget);
    expect(find.text('Authority Level *'), findsOneWidget);

    // Close Create User dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // Reopen drawer
    await tester.tap(profileLeading);
    await tester.pumpAndSettle();

    // Tap 'Upload Excel Sheets' to open Excel Upload Dialog
    await tester.tap(find.text('Upload Excel Sheets'));
    await tester.pumpAndSettle();

    // Verify Excel Upload Dialog
    expect(find.text('Excel Uploads & Catalog'), findsOneWidget);
    expect(find.text('Faculty & Program Master Sheet'), findsOneWidget);
    expect(find.text('Subject & Curriculum Master Sheet'), findsOneWidget);
    expect(find.text('View Active Catalog & Filters'), findsNothing);

    // Close Excel dialog
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
  });

  testWidgets(
      'UserHomeScreen displays Export docx button and clicking it opens export options sheet',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final appState = AppState();
    appState.loadSampleDemoData();
    appState.setRole(AppRole.user);
    appState.saveSubmission(
      MonitoringSubmission(
        id: 'TEST-USER-1',
        programName: 'Computer Technology',
        programCode: 'CM',
        semesterType: 'ODD',
        submittedAt: DateTime.now(),
        rows: [
          MonitoringRowEntry(
            srNo: 1,
            facultyName: 'Prof. A. B. Chaudhari',
            branchSemScheme: 'CM1K',
            qualification: 'M.E. Computer',
            facultyApproved: 'Regular + Approved',
            courseAbbreviationCode: 'DCN-3111',
          ),
        ],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserHomeScreen(appState: appState),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final exportBtn = find.text('Export docx').first;
    expect(exportBtn, findsOneWidget);
    await tester.ensureVisible(exportBtn);
    await tester.tap(exportBtn);
    await tester.pumpAndSettle();

    // Verify Export Options sheet is shown with Custom Location and Quick Save
    expect(find.text('Export docx Document'), findsOneWidget);
    expect(find.text('Save to Custom Location (Save As...)'), findsOneWidget);
    expect(find.text('Quick Save to Downloads Folder'), findsOneWidget);
  });
}

