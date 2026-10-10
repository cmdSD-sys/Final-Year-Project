import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/main.dart';
import 'package:final_project/services/app_state.dart';

void main() {
  testWidgets('App renders RoleSelectionScreen with Admin and User options',
      (WidgetTester tester) async {
    final appState = AppState();
    await tester.pumpWidget(MyApp(appState: appState));

    // Verify title and institutional login options
    expect(find.text('K K Wagh Polytechnic, Nashik'), findsOneWidget);
    expect(find.text('Super Admin (All Departments)'), findsOneWidget);
    expect(find.text('CM Admin (Comp)'), findsOneWidget);
  });
}
