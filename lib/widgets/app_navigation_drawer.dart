import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';
import '../services/app_state.dart';
import '../screens/role_selection_screen.dart';
import '../theme/app_theme.dart';
import 'create_user_dialog.dart';
import 'excel_upload_dialog.dart';
import 'portal_ui.dart';
import 'settings_dialog.dart';
import 'super_admin_user_dialog.dart';

class AppNavigationDrawer extends StatelessWidget {
  final AppState appState;
  final VoidCallback? onOpenCatalog;

  /// When true the navigation is rendered as a permanent sidebar (wide
  /// screens) instead of a slide-over drawer, so items must not pop the route.
  final bool persistent;

  const AppNavigationDrawer({
    super.key,
    required this.appState,
    this.onOpenCatalog,
    this.persistent = false,
  });

  void _dismiss(BuildContext context) {
    if (!persistent && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final isSuperAdmin = appState.isSuperAdmin;
    final isAdmin = appState.isAdminOrSuper;
    final userDept = appState.currentUserDepartment;

    String authorityLabel;
    if (isSuperAdmin) {
      authorityLabel = 'Authority: Super Admin';
    } else if (isAdmin) {
      authorityLabel = userDept != null ? 'Authority: Admin ($userDept)' : 'Authority: Admin';
    } else {
      authorityLabel = userDept != null ? 'Authority: User ($userDept)' : 'Authority: User';
    }

    final onGround = Colors.white;
    final onGroundSoft = Colors.white.withValues(alpha: 0.62);
    final hairline = Colors.white.withValues(alpha: 0.14);

    Widget navTile({
      required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
    }) {
      return ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        hoverColor: Colors.white.withValues(alpha: 0.08),
        splashColor: Colors.white.withValues(alpha: 0.10),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        horizontalTitleGap: 12,
        minLeadingWidth: 24,
        leading: Icon(icon, color: onGround.withValues(alpha: 0.85), size: 22),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: onGround,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: onGroundSoft),
        ),
        onTap: onTap,
      );
    }

    Widget sectionLabel(String text) {
      return Padding(
        padding: const EdgeInsets.only(left: 12, bottom: 6),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: onGroundSoft,
          ),
        ),
      );
    }

    return Drawer(
      backgroundColor: p.brandDeep,
      surfaceTintColor: Colors.transparent,
      elevation: persistent ? 0 : 16,
      width: persistent ? 288 : null,
      child: SafeArea(
        child: Column(
          children: [
            // 1. Brand
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Row(
                children: [
                  const PortalLogo(
                    height: 44,
                    tint: Colors.white,
                    asset: 'assets/images/nobgkkwpblack.png',
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'K.K. Wagh Polytechnic, Nashik',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.display(onGround, size: 18, height: 1.2),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: hairline),

            // 2. Profile
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white.withValues(alpha: 0.14),
                          backgroundImage: appState.currentUserPfpBytes != null
                              ? MemoryImage(appState.currentUserPfpBytes!)
                              : null,
                          child: appState.currentUserPfpBytes == null
                              ? Icon(
                                  isSuperAdmin
                                      ? Icons.verified_user
                                      : (isAdmin ? Icons.admin_panel_settings : Icons.person),
                                  size: 24,
                                  color: onGround,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appState.currentUserName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: onGround,
                              ),
                            ),
                            if (appState.currentUser != null)
                              Text(
                                appState.currentUser!.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12, color: onGroundSoft),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  PortalTag(
                    icon: isSuperAdmin
                        ? Icons.stars
                        : (isAdmin ? Icons.verified_user : Icons.school),
                    color: Colors.white,
                    fill: Colors.white.withValues(alpha: 0.12),
                    border: Colors.white.withValues(alpha: 0.28),
                    label: authorityLabel,
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: hairline),

            // 3. Navigation items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                children: [
                  if (isSuperAdmin) ...[
                    sectionLabel('Super admin options'),
                    navTile(
                      icon: Icons.manage_accounts,
                      title: 'User Authority & Roles',
                      subtitle: 'View all users, search & promote/demote',
                      onTap: () {
                        _dismiss(context);
                        showDialog(
                          context: context,
                          builder: (_) => SuperAdminUserDialog(appState: appState),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Divider(height: 1, color: hairline),
                    const SizedBox(height: 16),
                  ],

                  if (isAdmin) ...[
                    sectionLabel('Administration'),
                    navTile(
                      icon: Icons.upload_file,
                      title: 'Upload Excel Sheets',
                      subtitle: 'Faculty & Curriculum master sheets',
                      onTap: () {
                        _dismiss(context);
                        showDialog(
                          context: context,
                          builder: (_) => ExcelUploadDialog(
                            appState: appState,
                            onViewCatalog: onOpenCatalog ?? () {},
                          ),
                        );
                      },
                    ),
                    navTile(
                      icon: Icons.person_add,
                      title: 'Create User',
                      subtitle: 'Add new faculty or admin account',
                      onTap: () {
                        _dismiss(context);
                        showDialog(
                          context: context,
                          builder: (_) => CreateUserDialog(appState: appState),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Divider(height: 1, color: hairline),
                    const SizedBox(height: 16),
                  ],

                  sectionLabel('Curriculum & system'),
                  if (onOpenCatalog != null)
                    navTile(
                      icon: Icons.menu_book,
                      title: 'Active Catalog',
                      subtitle: 'Faculty by dept & subject semesters',
                      onTap: () {
                        _dismiss(context);
                        onOpenCatalog!();
                      },
                    ),
                  navTile(
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'Theme mode and system preferences',
                    onTap: () {
                      _dismiss(context);
                      showDialog(
                        context: context,
                        builder: (_) => SettingsDialog(appState: appState),
                      );
                    },
                  ),
                ],
              ),
            ),

            // 4. Log out
            Divider(height: 1, color: hairline),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  onPressed: () async {
                    final router = GoRouter.maybeOf(context);
                    _dismiss(context);
                    await appState.logout();
                    if (router != null) {
                      router.go(AppRoutes.login);
                    } else if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RoleSelectionScreen(appState: appState),
                        ),
                        (route) => false,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
