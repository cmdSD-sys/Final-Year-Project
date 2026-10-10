import 'package:flutter/material.dart';
import 'screens/role_selection_screen.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  runApp(MyApp(appState: appState));
}

class MyApp extends StatelessWidget {
  final AppState appState;

  const MyApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'K K Wagh Polytechnic - Internal Monitoring System',
          debugShowCheckedModeBanner: false,
          themeMode: appState.themeMode,
          theme: AppTheme.light(appState.currentPalette),
          darkTheme: AppTheme.dark(appState.currentPalette),
          home: RoleSelectionScreen(appState: appState),
        );
      },
    );
  }
}
