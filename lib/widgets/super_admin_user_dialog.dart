import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'portal_ui.dart';
import '../utils/app_snack_bar.dart';

class SuperAdminUserDialog extends StatefulWidget {
  final AppState appState;

  const SuperAdminUserDialog({super.key, required this.appState});

  @override
  State<SuperAdminUserDialog> createState() => _SuperAdminUserDialogState();
}

class _SuperAdminUserDialogState extends State<SuperAdminUserDialog> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  bool _isLoading = true;
  String? _errorMessage;
  List<AuthUser> _users = [];
  String _selectedDepartmentFilter = 'ALL'; // 'ALL', 'CM', 'IT', 'ME', 'CE'
  final List<String> _departments = ['ALL', 'CM', 'IT', 'ME', 'CE'];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _loadUsers();
    });
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dept = _selectedDepartmentFilter == 'ALL' ? null : _selectedDepartmentFilter;
      final query = _searchController.text.trim().isEmpty ? null : _searchController.text.trim();
      final users = await widget.appState.fetchUsers(
        search: query,
        department: dept,
      );
      if (mounted) {
        setState(() {
          _users = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('ApiException: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _changeRole(AuthUser user, String newRole) async {
    final isPromoting = newRole == 'ADMIN';
    final actionName = isPromoting ? 'Promote to Admin' : 'Demote to User';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                isPromoting ? Icons.shield_outlined : Icons.person_outline,
                color: isPromoting ? Color(0xFF9A5B00) : const Color(0xFF1281B0),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '$actionName?',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to change authority for ${user.fullName} (${user.email}) to $newRole?\n\n'
            'Department: ${user.department ?? 'None'}\n'
            '${isPromoting ? 'They will be able to manage this department\'s roster, curriculum, and submissions.' : 'Their administrative permissions will be revoked.'}',
            style: TextStyle(
              fontSize: 13.5,
              color: isDark ? const Color(0xFFC0CDD3) : const Color(0xFF2B4650),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isPromoting ? const Color(0xFF9A5B00) : const Color(0xFF1281B0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(isPromoting ? 'Promote' : 'Demote'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await widget.appState.changeUserRole(user.id, newRole);
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        'Successfully updated ${user.fullName} to $newRole!',
      );
      _loadUsers();
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(
        context,
        e.toString().replaceAll('ApiException: ', ''),
      );
    }
  }

  Future<void> _deleteUser(AuthUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.delete_forever, color: Color(0xFFB3261E), size: 24),
              SizedBox(width: 8),
              Text(
                'Delete User Permanently?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to permanently delete ${user.fullName} (${user.email})?\n\n'
            'Department: ${user.department ?? 'All'}\n'
            'Role: ${user.role}\n\n'
            'This action cannot be undone and will permanently remove their profile and all associated data from the system.',
            style: TextStyle(
              fontSize: 13.5,
              color: isDark ? const Color(0xFFC0CDD3) : const Color(0xFF2B4650),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB3261E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete Permanently'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await widget.appState.deleteUser(user.id);
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        'Successfully deleted ${user.fullName}!',
      );
      _loadUsers();
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(
        context,
        e.toString().replaceAll('ApiException: ', ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = Pal.of(context).surface;
    final textColor = Pal.of(context).ink;
    final borderColor = Pal.of(context).rule;

    return Dialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 720),
        child: Column(
          children: [
            // 1. Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 20, 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor)),
                color: Pal.of(context).paper,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Icon(Icons.manage_accounts, color: Pal.of(context).plum, size: 26),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'User Authority & Roles',
                              style: AppType.display(textColor, size: 22, height: 1.2),
                            ),
                            const SizedBox(width: 10),
                            PortalTag(
                              label: 'Super Admin View',
                              color: Pal.of(context).plum,
                              fill: Pal.of(context).plumTint,
                              fontSize: 11,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Search users across departments, view permissions, and promote or demote roles.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? const Color(0xFF8FA6AF) : const Color(0xFF5B6E76),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // 2. Search & Department Filters
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search box
                  TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search by full name or email address...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                _loadUsers();
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Department Filter Chips
                  Row(
                    children: [
                      Text(
                        'Department:',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? const Color(0xFFC0CDD3) : const Color(0xFF44575F),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _departments.map((dept) {
                              final isSelected = _selectedDepartmentFilter == dept;
                              return Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: ChoiceChip(
                                  label: Text(dept == 'ALL' ? 'All Depts' : dept),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() => _selectedDepartmentFilter = dept);
                                      _loadUsers();
                                    }
                                  },
                                  selectedColor: const Color(0xFF7A3568).withValues(alpha: 0.2),
                                  side: BorderSide(
                                    color: isSelected
                                        ? const Color(0xFF7A3568)
                                        : (isDark ? const Color(0xFF2B4650) : const Color(0xFFC0CDD3)),
                                  ),
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: isSelected
                                        ? const Color(0xFF8E4A7D)
                                        : (isDark ? Colors.white70 : const Color(0xFF2B4650)),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: borderColor),

            // 3. User List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.error_outline, size: 40, color: Color(0xFFB3261E)),
                                const SizedBox(height: 10),
                                Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Color(0xFFB3261E)),
                                ),
                                const SizedBox(height: 12),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.refresh, size: 16),
                                  label: const Text('Try Again'),
                                  onPressed: _loadUsers,
                                ),
                              ],
                            ),
                          ),
                        )
                      : _users.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.group_off_outlined,
                                    size: 48,
                                    color: isDark ? const Color(0xFF5B6E76) : Color(0xFF8FA6AF),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No users found matching your criteria.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white70 : const Color(0xFF2B4650),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              itemCount: _users.length,
                              separatorBuilder: (_, index) => const SizedBox(height: 8),
                              itemBuilder: (ctx, index) {
                                final u = _users[index];
                                final isSuper = u.isSuperAdmin;
                                final isAdmin = u.isAdmin;
                                final isSelf = u.id == widget.appState.currentUser?.id;

                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF0E222A)
                                        : const Color(0xFFF3F6F7),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Row(
                                    children: [
                                      // Avatar
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: isSuper
                                            ? const Color(0xFF7A3568).withValues(alpha: 0.2)
                                            : (isAdmin
                                                ? Color(0xFF9A5B00).withValues(alpha: 0.2)
                                                : const Color(0xFF1281B0).withValues(alpha: 0.2)),
                                        child: Text(
                                          u.fullName.isNotEmpty
                                              ? u.fullName[0].toUpperCase()
                                              : 'U',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isSuper
                                                ? const Color(0xFF8E4A7D)
                                                : (isAdmin
                                                    ? Color(0xFF8A4F00)
                                                    : const Color(0xFF1281B0)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // User Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    u.fullName,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: textColor,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                if (isSelf) ...[
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFF74868D).withValues(alpha: 0.2),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: const Text(
                                                      'You',
                                                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              u.email,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isDark ? const Color(0xFF8FA6AF) : const Color(0xFF5B6E76),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      // Department Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: isDark ? const Color(0xFF14303A) : Color(0xFFD5DEE2),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: isDark ? const Color(0xFF2B4650) : Color(0xFFC0CDD3),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.domain,
                                              size: 12,
                                              color: isDark ? const Color(0xFF8FA6AF) : Color(0xFF44575F),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              u.department != null && u.department!.isNotEmpty
                                                  ? u.department!
                                                  : 'All Depts',
                                              style: TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.bold,
                                                color: isDark ? const Color(0xFFC0CDD3) : const Color(0xFF2B4650),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      // Role Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: isSuper
                                              ? const Color(0xFF7A3568).withValues(alpha: 0.15)
                                              : (isAdmin
                                                  ? Color(0xFFB57A14).withValues(alpha: 0.15)
                                                  : const Color(0xFF1281B0).withValues(alpha: 0.12)),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: isSuper
                                                ? const Color(0xFF8E4A7D)
                                                : (isAdmin
                                                    ? Color(0xFFA86D0A)
                                                    : const Color(0xFF2E93BD)),
                                          ),
                                        ),
                                        child: Text(
                                          isSuper ? 'SUPER ADMIN' : (isAdmin ? 'ADMIN' : 'USER'),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isSuper
                                                ? const Color(0xFF8E4A7D)
                                                : (isAdmin
                                                    ? Color(0xFF8A4F00)
                                                    : const Color(0xFF1281B0)),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 12),

                                      // Authority Action Button
                                      if (isSuper)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          child: Text(
                                            'Protected',
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: isDark ? Colors.white38 : Color(0xFF74868D),
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        )
                                      else if (isAdmin)
                                        OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: const Color(0xFF1281B0),
                                            side: const BorderSide(color: Color(0xFF2E93BD)),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          ),
                                          icon: const Icon(Icons.arrow_downward, size: 14),
                                          label: const Text('Demote to User', style: TextStyle(fontSize: 12)),
                                          onPressed: () => _changeRole(u, 'USER'),
                                        )
                                      else
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF9A5B00),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          ),
                                          icon: const Icon(Icons.shield, size: 14),
                                          label: const Text('Promote to Admin', style: TextStyle(fontSize: 12)),
                                          onPressed: () => _changeRole(u, 'ADMIN'),
                                        ),
                                      if (!isSuper && !isSelf) ...[
                                        const SizedBox(width: 8),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFB3261E)),
                                          tooltip: 'Delete User Permanently',
                                          splashRadius: 20,
                                          onPressed: () => _deleteUser(u),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
            ),

            // 4. Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total matching users: ${_users.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? const Color(0xFF8FA6AF) : const Color(0xFF5B6E76),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
