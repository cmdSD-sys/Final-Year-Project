import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../utils/app_snack_bar.dart';

class SettingsDialog extends StatefulWidget {
  final AppState appState;

  const SettingsDialog({super.key, required this.appState});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late TextEditingController _nameController;
  bool _isSavingName = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.appState.currentUserName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickProfilePhoto() async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      );

      if (files.isEmpty) return;

      final file = files.first;
      final bytes = await file.readAsBytes();

      widget.appState.updateCurrentUserPfp(bytes);

      if (!mounted) return;
      AppSnackBar.showSuccess(context, 'Profile picture updated successfully!');
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Failed to update profile picture: $e');
    }
  }

  void _removeProfilePhoto() {
    widget.appState.updateCurrentUserPfp(null);
    AppSnackBar.showInfo(context, 'Profile picture removed.');
  }

  void _saveName() {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      AppSnackBar.showError(context, 'Name cannot be empty.');
      return;
    }

    setState(() => _isSavingName = true);
    widget.appState.updateCurrentUserName(newName);
    setState(() => _isSavingName = false);

    AppSnackBar.showSuccess(context, 'Display name updated to "$newName"');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
    final subtextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final isAdmin = widget.appState.currentRole == AppRole.admin;

    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final dark = widget.appState.isDarkMode;
        final pfpBytes = widget.appState.currentUserPfpBytes;

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
                  color: dark
                      ? const Color(0xFF3B82F6).withValues(alpha: 0.2)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.settings,
                  color: dark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Application Settings',
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Profile & Account Section
                  Text(
                    'Profile & Identity',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: subtextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: dark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Profile Avatar
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: dark ? const Color(0xFF3B82F6) : const Color(0xFF1E3A8A),
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: dark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFEFF6FF),
                                backgroundImage:
                                    pfpBytes != null ? MemoryImage(pfpBytes) : null,
                                child: pfpBytes == null
                                    ? Icon(
                                        isAdmin
                                            ? Icons.admin_panel_settings
                                            : Icons.person,
                                        size: 32,
                                        color: isAdmin
                                            ? const Color(0xFFD97706)
                                            : const Color(0xFF1E3A8A),
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // PFP actions
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: isAdmin
                                              ? (dark
                                                  ? Colors.amber.shade900.withValues(alpha: 0.3)
                                                  : Colors.amber.shade100)
                                              : (dark
                                                  ? const Color(0xFF2563EB).withValues(alpha: 0.2)
                                                  : const Color(0xFFEFF6FF)),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: isAdmin
                                                ? (dark
                                                    ? Colors.amber.shade700
                                                    : Colors.amber.shade400)
                                                : (dark
                                                    ? const Color(0xFF3B82F6).withValues(alpha: 0.5)
                                                    : const Color(0xFF93C5FD)),
                                          ),
                                        ),
                                        child: Text(
                                          isAdmin ? 'Authority: Admin' : 'Authority: User',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isAdmin
                                                ? (dark ? Colors.amber.shade300 : const Color(0xFFB45309))
                                                : (dark ? const Color(0xFF93C5FD) : const Color(0xFF1E3A8A)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 6,
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: _pickProfilePhoto,
                                        icon: const Icon(Icons.photo_camera, size: 15),
                                        label: Text(
                                          pfpBytes != null ? 'Change Photo' : 'Upload Photo',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                        ),
                                      ),
                                      if (pfpBytes != null)
                                        TextButton.icon(
                                          onPressed: _removeProfilePhoto,
                                          icon: Icon(Icons.delete_outline,
                                              size: 15,
                                              color: dark ? Colors.redAccent.shade100 : Colors.redAccent),
                                          label: Text(
                                            'Remove',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: dark ? Colors.redAccent.shade100 : Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Edit Name Field
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: 'Display Name',
                                  labelStyle: TextStyle(fontSize: 13, color: subtextColor),
                                  prefixIcon: const Icon(Icons.badge_outlined, size: 18),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                onFieldSubmitted: (_) => _saveName(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _isSavingName ? null : _saveName,
                              child: const Text('Save Name'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Appearance & Theme Section (With Material wrapper to fix ListTile assertion)
                  Text(
                    'Appearance & Theme Preferences',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: subtextColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    color: dark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: borderColor),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SwitchListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      secondary: Icon(
                        dark ? Icons.dark_mode : Icons.light_mode,
                        color: dark ? Colors.amber : const Color(0xFF1E3A8A),
                      ),
                      title: Text(
                        'Dark Mode Theme',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      subtitle: Text(
                        dark
                            ? 'Deep dark mode enabled for low-light environments'
                            : 'Standard institutional clean light mode',
                        style: TextStyle(
                          fontSize: 12,
                          color: subtextColor,
                        ),
                      ),
                      value: dark,
                      onChanged: (_) => widget.appState.toggleTheme(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. About System
                  Text(
                    'About System',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: subtextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: dark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.school,
                                size: 18,
                                color: dark
                                    ? const Color(0xFF60A5FA)
                                    : const Color(0xFF1E3A8A)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'K.K. Wagh Polytechnic, Nashik',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.description,
                                size: 18,
                                color: dark
                                    ? const Color(0xFF60A5FA)
                                    : const Color(0xFF1E3A8A)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Internal Institute Monitoring Format (IIM-26-27)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: dark
                                      ? const Color(0xFF94A3B8)
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
