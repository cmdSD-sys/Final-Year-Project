import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../screens/role_selection_screen.dart';
import 'create_user_dialog.dart';
import 'excel_upload_dialog.dart';
import 'settings_dialog.dart';

class AppNavigationDrawer extends StatelessWidget {
  final AppState appState;
  final VoidCallback? onOpenCatalog;

  const AppNavigationDrawer({
    super.key,
    required this.appState,
    this.onOpenCatalog,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAdmin = appState.currentRole == AppRole.admin;
    final drawerBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Drawer(
      backgroundColor: drawerBg,
      child: Column(
        children: [
          // 1. Profile Sidebar Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFF1E3A8A), const Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture Circle
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFEFF6FF),
                    backgroundImage: appState.currentUserPfpBytes != null
                        ? MemoryImage(appState.currentUserPfpBytes!)
                        : null,
                    child: appState.currentUserPfpBytes == null
                        ? Icon(
                            isAdmin ? Icons.admin_panel_settings : Icons.person,
                            size: 40,
                            color: isAdmin
                                ? const Color(0xFFD97706)
                                : const Color(0xFF1E3A8A),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                // User Name
                Text(
                  appState.currentUserName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 6),
                // Small Authority indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAdmin
                        ? Colors.amber.shade400.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isAdmin
                          ? Colors.amber.shade300.withValues(alpha: 0.6)
                          : Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAdmin ? Icons.verified_user : Icons.school,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isAdmin ? 'Authority: Admin' : 'Authority: User',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              children: [
                if (isAdmin) ...[
                  // Section Title: Admin Management
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 8),
                    child: Text(
                      'ADMINISTRATION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                    ),
                  ),

                  // Upload Excel Sheets (Admin Only)
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    leading: const Icon(Icons.upload_file, color: Color(0xFF2563EB)),
                    title: Text(
                      'Upload Excel Sheets',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      'Faculty & Curriculum master sheets',
                      style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => ExcelUploadDialog(
                          appState: appState,
                          onViewCatalog: onOpenCatalog ?? () {},
                        ),
                      );
                    },
                  ),

                  // Create User (Admin Only)
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    leading: const Icon(Icons.person_add, color: Color(0xFF059669)),
                    title: Text(
                      'Create User',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      'Add new faculty or admin account',
                      style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => const CreateUserDialog(),
                      );
                    },
                  ),

                  const SizedBox(height: 12),
                  Divider(color: borderColor),
                  const SizedBox(height: 8),
                ],

                // General Section
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 8),
                  child: Text(
                    'CURRICULUM & SYSTEM',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                ),

                // Active Catalog Option
                if (onOpenCatalog != null)
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    leading: const Icon(Icons.menu_book, color: Color(0xFF0D9488)),
                    title: Text(
                      'Active Catalog',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    subtitle: Text(
                      'Faculty by dept & subject semesters',
                      style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onOpenCatalog!();
                    },
                  ),

                // Settings
                ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  leading: const Icon(Icons.settings, color: Color(0xFF6366F1)),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                  subtitle: Text(
                    'Theme mode and system preferences',
                    style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (_) => SettingsDialog(appState: appState),
                    );
                  },
                ),
              ],
            ),
          ),

          // 3. Bottom Log Out Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text(
                  'Log Out',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                onPressed: () {
                  appState.setRole(AppRole.none);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => RoleSelectionScreen(appState: appState)),
                    (route) => false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
