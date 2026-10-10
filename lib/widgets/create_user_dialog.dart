import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/app_snack_bar.dart';

class CreateUserDialog extends StatefulWidget {
  final AppState appState;

  const CreateUserDialog({super.key, required this.appState});

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedAuthority = 'User'; // 'Admin' or 'User'
  String _selectedDepartment = 'CM';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    final dept = widget.appState.currentUserDepartment;
    if (dept != null && dept.isNotEmpty) {
      _selectedDepartment = dept;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleCreateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCreating = true);
    final createdName = _nameController.text.trim();
    final createdEmail = _emailController.text.trim();
    final createdPassword = _passwordController.text;
    final createdAuthority = _selectedAuthority;
    final createdDept = widget.appState.isSuperAdmin
        ? _selectedDepartment
        : (widget.appState.currentUserDepartment ?? _selectedDepartment);

    try {
      if (widget.appState.isAuthenticated) {
        await widget.appState.createUser(
          fullName: createdName,
          email: createdEmail,
          password: createdPassword,
          role: createdAuthority == 'Admin' ? 'ADMIN' : 'USER',
          department: createdDept,
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 400));
      }

      if (!mounted) return;
      Navigator.pop(context);

      AppSnackBar.showSuccess(
        context,
        'User "$createdName" ($createdAuthority, Dept: $createdDept) created successfully!',
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(
        context,
        e.toString().replaceAll('ApiException: ', ''),
      );
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = Pal.of(context).surface;
    final textColor = Pal.of(context).ink;
    final borderColor = Pal.of(context).rule;

    return AlertDialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor),
      ),
      title: Row(
        children: [
          Icon(
              Icons.person_add_alt_1,
              color: isDark ? const Color(0xFF5DB8DB) : const Color(0xFF0B6A90),
              size: 22,
            ),
          const SizedBox(width: 12),
          Text(
            'Create New User',
            style: AppType.display(textColor, size: 22, height: 1.2),
          ),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set up credentials and authority level for a faculty member or administrator.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? const Color(0xFF8FA6AF) : const Color(0xFF5B6E76),
                  ),
                ),
                const SizedBox(height: 18),

                // 1. Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name *',
                    prefixIcon: const Icon(Icons.badge, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter user full name.';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // 2. Email Address
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address *',
                    prefixIcon: const Icon(Icons.email, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter user email.';
                    if (!v.contains('@') || !v.contains('.')) return 'Please enter a valid email.';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // 3. Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password *',
                    prefixIcon: const Icon(Icons.lock, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter a password.';
                    if (v.length < 4) return 'Password must be at least 4 characters.';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // 4. Confirm Password
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password *',
                    prefixIcon: const Icon(Icons.lock_clock, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, size: 18),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please confirm the password.';
                    if (v != _passwordController.text) return 'Passwords do not match.';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // 5. Department Assignment
                Text(
                  'Assigned Department *',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                if (widget.appState.isSuperAdmin) ...[
                  DropdownButtonFormField<String>(
                    initialValue: _selectedDepartment,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.domain, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'CM',
                        child: Text('CM - Computer Technology'),
                      ),
                      DropdownMenuItem(
                        value: 'IT',
                        child: Text('IT - Information Technology'),
                      ),
                      DropdownMenuItem(
                        value: 'ME',
                        child: Text('ME - Mechanical Engineering'),
                      ),
                      DropdownMenuItem(
                        value: 'CE',
                        child: Text('CE - Civil Engineering'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedDepartment = val);
                    },
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0E222A) : const Color(0xFFE9EFF1),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 20,
                          color: isDark ? const Color(0xFF8FA6AF) : const Color(0xFF5B6E76),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.appState.currentUserDepartment ?? 'CM'} Department',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                'Locked to your department for data isolation',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark ? const Color(0xFF8FA6AF) : const Color(0xFF5B6E76),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1281B0).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: const Color(0xFF1281B0).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            widget.appState.currentUserDepartment ?? 'CM',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1281B0),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 14),

                // 6. Authority Selection
                Text(
                  'Authority Level *',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _selectedAuthority = 'User'),
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                          decoration: BoxDecoration(
                            color: _selectedAuthority == 'User'
                                ? (isDark ? const Color(0xFF0B6A90).withValues(alpha: 0.5) : const Color(0xFFE3F0F5))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: _selectedAuthority == 'User'
                                  ? const Color(0xFF1281B0)
                                  : borderColor,
                              width: _selectedAuthority == 'User' ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person,
                                size: 18,
                                color: _selectedAuthority == 'User'
                                    ? const Color(0xFF1281B0)
                                    : (isDark ? Color(0xFF74868D) : Color(0xFF5B6E76)),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'User (Faculty)',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: _selectedAuthority == 'User' ? FontWeight.bold : FontWeight.normal,
                                    color: _selectedAuthority == 'User'
                                        ? (isDark ? Colors.white : const Color(0xFF0B6A90))
                                        : textColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _selectedAuthority = 'Admin'),
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                          decoration: BoxDecoration(
                            color: _selectedAuthority == 'Admin'
                                ? (isDark ? Color(0xFF5C3300).withValues(alpha: 0.3) : const Color(0xFFFBF1DF))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: _selectedAuthority == 'Admin'
                                  ? const Color(0xFF9A5B00)
                                  : borderColor,
                              width: _selectedAuthority == 'Admin' ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.security,
                                size: 18,
                                color: _selectedAuthority == 'Admin'
                                    ? const Color(0xFF9A5B00)
                                    : (isDark ? Color(0xFF74868D) : Color(0xFF5B6E76)),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Administrator',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: _selectedAuthority == 'Admin' ? FontWeight.bold : FontWeight.normal,
                                    color: _selectedAuthority == 'Admin'
                                        ? (isDark ? Color(0xFFC98A1E) : const Color(0xFF8A4F00))
                                        : textColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCreating ? null : () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: isDark ? const Color(0xFF8FA6AF) : Color(0xFF44575F)),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0B6A90),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          onPressed: _isCreating ? null : _handleCreateUser,
          icon: _isCreating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.person_add, size: 18),
          label: Text(_isCreating ? 'Creating...' : 'Create User'),
        ),
      ],
    );
  }
}
