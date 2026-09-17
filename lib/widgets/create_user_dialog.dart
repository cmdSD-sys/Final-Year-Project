import 'package:flutter/material.dart';
import '../utils/app_snack_bar.dart';

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({super.key});

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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isCreating = false;

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
    await Future.delayed(const Duration(milliseconds: 600)); // Simulated processing
    if (!mounted) return;
    setState(() => _isCreating = false);

    final createdName = _nameController.text.trim();
    final createdAuthority = _selectedAuthority;

    Navigator.pop(context);

    AppSnackBar.showSuccess(
      context,
      'User "$createdName" created successfully as $createdAuthority!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);

    return AlertDialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: borderColor),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF3B82F6).withValues(alpha: 0.2)
                  : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.person_add_alt_1,
              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Create New User',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
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
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 18),

                // 1. Full Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name *',
                    prefixIcon: const Icon(Icons.badge, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please confirm the password.';
                    if (v != _passwordController.text) return 'Passwords do not match.';
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // 5. Authority Selection
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
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                          decoration: BoxDecoration(
                            color: _selectedAuthority == 'User'
                                ? (isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.5) : const Color(0xFFEFF6FF))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _selectedAuthority == 'User'
                                  ? const Color(0xFF2563EB)
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
                                    ? const Color(0xFF2563EB)
                                    : (isDark ? Colors.grey : Colors.grey.shade600),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'User (Faculty)',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: _selectedAuthority == 'User' ? FontWeight.bold : FontWeight.normal,
                                    color: _selectedAuthority == 'User'
                                        ? (isDark ? Colors.white : const Color(0xFF1E3A8A))
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
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                          decoration: BoxDecoration(
                            color: _selectedAuthority == 'Admin'
                                ? (isDark ? Colors.amber.shade900.withValues(alpha: 0.3) : const Color(0xFFFEF3C7))
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _selectedAuthority == 'Admin'
                                  ? const Color(0xFFD97706)
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
                                    ? const Color(0xFFD97706)
                                    : (isDark ? Colors.grey : Colors.grey.shade600),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Administrator',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: _selectedAuthority == 'Admin' ? FontWeight.bold : FontWeight.normal,
                                    color: _selectedAuthority == 'Admin'
                                        ? (isDark ? Colors.amber : const Color(0xFFB45309))
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
            style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade700),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
