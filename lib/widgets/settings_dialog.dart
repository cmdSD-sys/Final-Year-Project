import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/app_snack_bar.dart';
import 'palette_switcher_dialog.dart';

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

      await widget.appState.uploadAvatar(bytes, file.name);

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
    final cardBg = Pal.of(context).surface;
    final textColor = Pal.of(context).ink;
    final borderColor = Pal.of(context).rule;
    final subtextColor = Pal.of(context).inkMuted;
    final isAdmin = widget.appState.currentRole == AppRole.admin;

    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final dark = widget.appState.isDarkMode;
        final pfpBytes = widget.appState.currentUserPfpBytes;

        return AlertDialog(
          backgroundColor: cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: borderColor),
          ),
          title: Row(
            children: [
              Icon(
                  Icons.settings,
                  color: dark ? const Color(0xFF5DB8DB) : const Color(0xFF0B6A90),
                  size: 22,
                ),
              const SizedBox(width: 12),
              Text(
                'Application Settings',
                style: AppType.display(textColor, size: 22, height: 1.2),
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
                      color: dark ? const Color(0xFF0E222A) : const Color(0xFFF3F6F7),
                      borderRadius: BorderRadius.circular(6),
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
                                  color: dark ? const Color(0xFF2E93BD) : const Color(0xFF0B6A90),
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: dark
                                    ? const Color(0xFF14303A)
                                    : const Color(0xFFE3F0F5),
                                backgroundImage:
                                    pfpBytes != null ? MemoryImage(pfpBytes) : null,
                                child: pfpBytes == null
                                    ? Icon(
                                        isAdmin
                                            ? Icons.admin_panel_settings
                                            : Icons.person,
                                        size: 32,
                                        color: isAdmin
                                            ? const Color(0xFF9A5B00)
                                            : const Color(0xFF0B6A90),
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
                                                  ? Color(0xFF5C3300).withValues(alpha: 0.3)
                                                  : Color(0xFFFBF1DF))
                                              : (dark
                                                  ? const Color(0xFF1281B0).withValues(alpha: 0.2)
                                                  : const Color(0xFFE3F0F5)),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: isAdmin
                                                ? (dark
                                                    ? Color(0xFF9A5B00)
                                                    : Color(0xFFC98A1E))
                                                : (dark
                                                    ? const Color(0xFF2E93BD).withValues(alpha: 0.5)
                                                    : const Color(0xFF9BD0E6)),
                                          ),
                                        ),
                                        child: Text(
                                          isAdmin ? 'Authority: Admin' : 'Authority: User',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isAdmin
                                                ? (dark ? Color(0xFFE0A24A) : const Color(0xFF8A4F00))
                                                : (dark ? const Color(0xFF9BD0E6) : const Color(0xFF0B6A90)),
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
                                              color: dark ? Color(0xFFF3A8A2) : Color(0xFFB3261E)),
                                          label: Text(
                                            'Remove',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: dark ? Color(0xFFF3A8A2) : Color(0xFFB3261E),
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
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                onFieldSubmitted: (_) => _saveName(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0B6A90),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
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
                    color: dark ? const Color(0xFF0E222A) : const Color(0xFFF3F6F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(color: borderColor),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      leading: Icon(
                        Icons.palette_outlined,
                        color: dark ? const Color(0xFF5DB8DB) : const Color(0xFF0B6A90),
                      ),
                      title: Text(
                        'Color Palette Scheme',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: textColor,
                        ),
                      ),
                      subtitle: Text(
                        'Current: ${AppTheme.paletteList.firstWhere((p) => p.id == widget.appState.currentPalette).name}',
                        style: TextStyle(fontSize: 12, color: subtextColor),
                      ),
                      trailing: const Icon(Icons.chevron_right, size: 20),
                      onTap: () {
                        Navigator.pop(context);
                        PaletteSwitcherDialog.show(context, widget.appState);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Material(
                    color: dark ? const Color(0xFF0E222A) : const Color(0xFFF3F6F7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(color: borderColor),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SwitchListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      secondary: Icon(
                        dark ? Icons.dark_mode : Icons.light_mode,
                        color: dark ? Color(0xFFC98A1E) : const Color(0xFF0B6A90),
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
                      color: dark ? const Color(0xFF0E222A) : const Color(0xFFF3F6F7),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.school,
                                size: 18,
                                color: dark
                                    ? const Color(0xFF5DB8DB)
                                    : const Color(0xFF0B6A90)),
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
                                    ? const Color(0xFF5DB8DB)
                                    : const Color(0xFF0B6A90)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Internal Institute Monitoring Format (IIM-26-27)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: dark
                                      ? const Color(0xFF8FA6AF)
                                      : Color(0xFF44575F),
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
                backgroundColor: const Color(0xFF0B6A90),
                foregroundColor: Colors.white,
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
