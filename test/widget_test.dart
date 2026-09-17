import 'package:flutter_test/flutter_test.dart';
import 'package:final_project/main.dart';
import 'package:final_project/services/app_state.dart';

void main() {
  testWidgets('App renders RoleSelectionScreen with Admin and User options',
      (WidgetTester tester) async {
    final appState = AppState();
    await tester.pumpWidget(MyApp(appState: appState));

    // Verify title and role selector
    expect(find.text('K K Wagh Polytechnic, Nashik'), findsOneWidget);
    expect(find.text('Select Entry Role'), findsOneWidget);
    expect(find.text('Enter Portal'), findsOneWidget);
  });
}
