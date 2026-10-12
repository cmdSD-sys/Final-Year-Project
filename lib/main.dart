import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'router/app_router.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    usePathUrlStrategy();
  }
  final appState = AppState();
  runApp(MyApp(appState: appState));
}

class MyApp extends StatefulWidget {
  final AppState appState;

  const MyApp({super.key, required this.appState});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(widget.appState);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.appState.themeModeNotifier,
        widget.appState.paletteNotifier,
      ]),
      builder: (context, _) {
        return MaterialApp.router(
          routerConfig: _router,
          title: 'K K Wagh Polytechnic - Internal Monitoring System',
          debugShowCheckedModeBanner: false,
          themeMode: widget.appState.themeModeNotifier.value,
          theme: AppTheme.light(widget.appState.paletteNotifier.value),
          darkTheme: AppTheme.dark(widget.appState.paletteNotifier.value),
        );
      },
    );
  }
}
