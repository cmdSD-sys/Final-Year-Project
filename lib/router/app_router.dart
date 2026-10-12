import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/admin_dashboard_screen.dart';
import '../screens/dept_info_form_screen.dart';
import '../screens/monitoring_form_screen.dart';
import '../screens/role_selection_screen.dart';
import '../screens/user_home_screen.dart';
import '../services/app_state.dart';

/// URL path constants for the web application.
class AppRoutes {
  static const String root = '/';
  static const String login = '/login';
  static const String admin = '/admin';
  static const String user = '/user';
  static const String cmReport = '/cm-report';
  static const String cmReportTab = '/cm-report/:tab';
  static const String monitoringForm = '/monitoring-form';
}

/// Helper for mapping between CM Report 11 tab slugs and indices.
class CmReportTabs {
  static const Map<String, int> slugToIndex = {
    'dept-info': 0,
    'admission': 1,
    'faculty-strength': 2,
    'faculty-profile': 3,
    'laboratory': 4,
    'curriculum': 5,
    'student-attendance': 6,
    'result-analysis': 7,
    'resources': 8,
    'co-curricular': 9,
    'any-other': 10,
  };

  static const List<String> indexToSlug = [
    'dept-info',
    'admission',
    'faculty-strength',
    'faculty-profile',
    'laboratory',
    'curriculum',
    'student-attendance',
    'result-analysis',
    'resources',
    'co-curricular',
    'any-other',
  ];

  static int getIndex(String? slug) {
    if (slug == null) return 0;
    return slugToIndex[slug.toLowerCase()] ?? 0;
  }

  static String getSlug(int index) {
    if (index < 0 || index >= indexToSlug.length) return indexToSlug[0];
    return indexToSlug[index];
  }
}

/// Declarative GoRouter configuration.
class AppRouter {
  static GoRouter createRouter(AppState appState) {
    return GoRouter(
      initialLocation: AppRoutes.login,
      refreshListenable: appState.authStateNotifier,
      redirect: (context, state) {
        final loc = state.matchedLocation;
        final isAuth = appState.isAuthenticated;
        final isLogin = loc == AppRoutes.login;

        if (!isAuth) {
          // Unauthenticated users must land on /login
          return isLogin ? null : AppRoutes.login;
        }

        // Authenticated user landing on / or /login gets redirected to their dashboard
        if (loc == AppRoutes.root || isLogin) {
          return appState.isAdminOrSuper ? AppRoutes.admin : AppRoutes.user;
        }

        // Prevent regular user from accessing admin dashboard
        if (loc == AppRoutes.admin && !appState.isAdminOrSuper) {
          return AppRoutes.user;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.root,
          redirect: (context, state) => AppRoutes.login,
        ),
        GoRoute(
          path: AppRoutes.login,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: const ValueKey('login-page'),
            name: 'login',
            child: RoleSelectionScreen(appState: appState),
          ),
        ),
        GoRoute(
          path: AppRoutes.admin,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: const ValueKey('admin-page'),
            name: 'admin',
            child: AdminDashboardScreen(appState: appState),
          ),
        ),
        GoRoute(
          path: AppRoutes.user,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: const ValueKey('user-page'),
            name: 'user',
            child: UserHomeScreen(appState: appState),
          ),
        ),
        GoRoute(
          path: AppRoutes.cmReport,
          redirect: (context, state) => '${AppRoutes.cmReport}/dept-info',
        ),
        GoRoute(
          path: AppRoutes.cmReportTab,
          pageBuilder: (context, state) {
            final tabSlug = state.pathParameters['tab'] ?? 'dept-info';
            return NoTransitionPage<void>(
              key: const ValueKey('cm-report-page'),
              name: 'cm-report',
              child: DeptInfoFormScreen(
                appState: appState,
                initialTabSlug: tabSlug,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.monitoringForm,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: const ValueKey('monitoring-form-page'),
            name: 'monitoring-form',
            child: MonitoringFormScreen(appState: appState),
          ),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page Not Found: ${state.uri}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.login),
                child: const Text('Return to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
