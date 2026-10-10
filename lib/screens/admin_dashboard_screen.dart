import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/docx_service.dart';
import '../utils/app_snack_bar.dart';
import '../theme/app_theme.dart';
import '../widgets/catalog_preview_dialog.dart';
import '../widgets/portal_shell.dart';
import '../widgets/portal_ui.dart';
import '../widgets/submission_details_dialog.dart';
import 'monitoring_form_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final AppState appState;

  const AdminDashboardScreen({super.key, required this.appState});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isExporting = false;
  bool _isSyncing = false;
  String _selectedDepartmentFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    _syncWithBackend();
  }

  Future<void> _syncWithBackend() async {
    if (!widget.appState.isAuthenticated) return;
    setState(() => _isSyncing = true);
    try {
      await widget.appState.refreshCatalogFromBackend();
      await widget.appState.refreshSubmissionsFromBackend();
    } catch (_) {}
    if (mounted) setState(() => _isSyncing = false);
  }

  /// Prompts user to choose between Custom Location (Save As) and Quick Save
  void _promptExportOptions(MonitoringSubmission sub) {
    if (kIsWeb) {
      // On web, browser automatically handles download location
      _doExportSubmissionDocx(sub, customLocation: true);
      return;
    }

    final p = Pal.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Export docx Document',
                style: AppType.display(p.ink, size: 24, height: 1.2),
              ),
              const SizedBox(height: 4),
              Text(
                '${sub.programName} (${sub.programCode}) • ${sub.semesterType} Sem',
                style: TextStyle(fontSize: 13, color: p.inkMuted),
              ),
              const SizedBox(height: 20),
              Text(
                'Choose where to save the generated document:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: p.inkSoft,
                ),
              ),
              const SizedBox(height: 12),
              // Option 1: Custom Location
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(color: p.brand.withValues(alpha: 0.4)),
                ),
                tileColor: p.brandTint,
                leading: Icon(Icons.folder_open, color: p.brand, size: 26),
                title: const Text('Save to Custom Location (Save As...)',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text(
                    'Pick any folder on your computer (e.g. Desktop, Documents, or D: drive).'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  _doExportSubmissionDocx(sub, customLocation: true);
                },
              ),
              const SizedBox(height: 10),
              // Option 2: Default Downloads
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(color: p.rule),
                ),
                tileColor: p.surface,
                leading: Icon(Icons.download_done, color: p.inkSoft, size: 26),
                title: const Text('Quick Save to Downloads Folder',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text(
                    'Instantly save to your standard system Downloads folder.'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.pop(ctx);
                  _doExportSubmissionDocx(sub, customLocation: false);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _doExportSubmissionDocx(MonitoringSubmission sub,
      {required bool customLocation}) async {
    setState(() => _isExporting = true);
    try {
      Uint8List docxBytes;
      if (widget.appState.isAuthenticated) {
        try {
          docxBytes = await widget.appState.apiService.exportSubmissionDocx(sub.id);
        } catch (_) {
          docxBytes = await DocxService.generateDocx(submission: sub);
        }
      } else {
        docxBytes = await DocxService.generateDocx(submission: sub);
      }
      final filename =
          'IIM_Monitoring_${sub.programCode}_${sub.semesterType}_${DateFormat('yyyyMMdd_HHmm').format(sub.submittedAt)}.docx';

      final String? savedPath;
      if (customLocation) {
        savedPath = await DocxService.saveDocxWithPicker(
          bytes: docxBytes,
          filename: filename,
          dialogTitle: 'Save Format.docx Document As',
          allowedExtensions: ['docx'],
        );
      } else {
        savedPath =
            await DocxService.saveDocxToDefaultDisk(docxBytes, filename);
      }

      if (!mounted) return;

      if (savedPath == null) {
        // User cancelled picker dialog
        AppSnackBar.showInfo(context, 'Export cancelled.');
        return;
      }

      final resolvedPath = savedPath;
      final isWebDownload = resolvedPath == DocxService.webDownloadSentinel;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF1F7A4D), size: 28),
              SizedBox(width: 10),
              Text('Format.docx Exported!'),
            ],
          ),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'All user submitted data has been successfully injected into the authentic Format.docx template with 100% original formatting preserved.',
                  style: TextStyle(fontSize: 13.5, color: Color(0xFF44575F)),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isWebDownload
                        ? Color(0xFFE3F0F5)
                        : Color(0xFFE9EFF1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isWebDownload
                            ? Color(0xFFB5D9E8)
                            : Color(0xFFC0CDD3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isWebDownload
                                ? Icons.cloud_download
                                : Icons.folder_open,
                            size: 18,
                            color: const Color(0xFF0B6A90),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isWebDownload
                                ? 'Downloaded via Browser:'
                                : 'Saved File Location:',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        isWebDownload
                            ? 'Saved to your browser\'s default Downloads folder as:\n$filename'
                            : resolvedPath,
                        style: const TextStyle(
                            fontSize: 12.5,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0B6A90)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (!isWebDownload) ...[
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: resolvedPath));
                  AppSnackBar.showSuccess(
                    context,
                    'File path copied to clipboard!',
                  );
                },
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Copy Path'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  DocxService.showInFolder(resolvedPath);
                },
                icon: const Icon(Icons.folder_open, size: 16),
                label: const Text('Show in Folder'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0B6A90),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  DocxService.openDocument(resolvedPath);
                  Navigator.pop(ctx);
                },
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Open in Word'),
              ),
            ],
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(
        context,
        'Failed to export docx: $e',
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  void _confirmDeleteSubmission(MonitoringSubmission sub) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Color(0xFFB3261E), size: 26),
            SizedBox(width: 8),
            Text('Delete Submission?'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete the submission for ${sub.programName} (${sub.semesterType} Sem)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFB3261E),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              widget.appState.deleteSubmission(sub.id);
              Navigator.pop(ctx);
              AppSnackBar.showSuccess(
                context,
                'Submission deleted successfully.',
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showSubmissionPreview(MonitoringSubmission sub) {
    SubmissionDetailsDialog.show(
      context,
      submission: sub,
      onExport: () => _promptExportOptions(sub),
    );
  }

  void _showCatalogPreview() {
    showDialog(
      context: context,
      builder: (ctx) => CatalogPreviewDialog(appState: widget.appState),
    );
  }

  void _openMonitoringForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MonitoringFormScreen(appState: widget.appState),
      ),
    );
  }

  Widget _buildRoleTag(Pal p) {
    final isSuper = widget.appState.isSuperAdmin;
    final dept = widget.appState.currentUserDepartment;
    return Center(
      child: PortalTag(
        icon: isSuper ? Icons.stars : Icons.security,
        color: isSuper ? p.plum : p.ochre,
        fill: isSuper ? p.plumTint : p.ochreTint,
        fontSize: 12.5,
        label: isSuper
            ? 'Super Admin (Global)'
            : (dept != null ? 'Admin ($dept)' : 'Role: Admin'),
      ),
    );
  }

  Widget _columnLabel(String text, Pal p) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: p.inkMuted,
      ),
    );
  }

  Widget _buildTableHeader(Pal p) {
    return Container(
      color: p.paper,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 5, child: _columnLabel('Program', p)),
          Expanded(flex: 2, child: _columnLabel('Semester', p)),
          Expanded(flex: 3, child: _columnLabel('Submitted', p)),
          Expanded(flex: 2, child: _columnLabel('Faculty rows', p)),
          const SizedBox(width: 300),
        ],
      ),
    );
  }

  Widget _buildSubmissionRow(MonitoringSubmission sub, Pal p, bool wide) {
    final names = sub.rows.map((r) => r.facultyName).join(' · ');
    final submitted = DateFormat('dd MMM yyyy, hh:mm a').format(sub.submittedAt);

    final program = Row(
      children: [
        DeptMonogram(code: sub.programCode),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${sub.programName} (${sub.programCode})',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: p.ink,
                ),
              ),
              if (names.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  names,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.5, color: p.inkMuted),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    final exportButton = ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
      ),
      onPressed: _isExporting ? null : () => _promptExportOptions(sub),
      icon: const Icon(Icons.download, size: 15),
      label: const Text('Export docx'),
    );
    final deleteButton = IconButton(
      icon: Icon(Icons.delete_outline, color: p.danger, size: 19),
      tooltip: 'Delete Submission',
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(6),
      constraints: const BoxConstraints(),
      onPressed: () => _confirmDeleteSubmission(sub),
    );
    final previewButton = TextButton.icon(
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      ),
      onPressed: () => _showSubmissionPreview(sub),
      icon: const Icon(Icons.visibility_outlined, size: 15),
      label: const Text('Preview', style: TextStyle(fontSize: 12.5)),
    );

    if (wide) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: p.rule)),
        ),
        child: Row(
          children: [
            Expanded(flex: 5, child: program),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: SemesterTag(semesterType: sub.semesterType),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                submitted,
                style: TextStyle(fontSize: 13.5, color: p.inkSoft),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '${sub.rows.length}',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: p.inkSoft,
                ),
              ),
            ),
            SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: previewButton),
                  const SizedBox(width: 4),
                  exportButton,
                  const SizedBox(width: 2),
                  deleteButton,
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: p.rule)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          program,
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SemesterTag(semesterType: sub.semesterType),
              Text(
                'Submitted: $submitted • ${sub.rows.length} Faculty Rows',
                style: TextStyle(fontSize: 12.5, color: p.inkMuted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [exportButton, previewButton, deleteButton],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final submissions = widget.appState.submissions;
        final p = Pal.of(context);

        final displayedSubmissions = widget.appState.isSuperAdmin &&
                _selectedDepartmentFilter != 'ALL'
            ? submissions
                .where((s) =>
                    s.programCode.toUpperCase() == _selectedDepartmentFilter)
                .toList()
            : submissions;

        final facultyEntries =
            submissions.fold<int>(0, (total, s) => total + s.rows.length);

        return PortalShell(
          appState: widget.appState,
          onOpenCatalog: _showCatalogPreview,
          title: 'Admin Dashboard',
          actions: [
            if (widget.appState.isAuthenticated)
              IconButton(
                tooltip: 'Sync with Backend',
                icon: _isSyncing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync, size: 20),
                onPressed: _isSyncing ? null : _syncWithBackend,
              ),
            _buildRoleTag(p),
            const SizedBox(width: 16),
          ],
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                children: [
                  // Page head
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Administrator Functions',
                              style: AppType.display(p.ink, size: 38, height: 1.1),
                            ),
                            const SizedBox(height: 10),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 620),
                              child: Text(
                                'Manage institutional curriculum catalogs, review faculty submissions, and export the official Format.docx documents.',
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.55,
                                  color: p.inkMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        tooltip: 'Reset to default demo data',
                        onPressed: () {
                          widget.appState.resetToDefaultData();
                          AppSnackBar.showInfo(
                            context,
                            'Reset to default demo data.',
                          );
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // At a glance
                  PortalStatRow(
                    stats: [
                      PortalStatData(
                        label: 'Total submissions',
                        value: '${submissions.length}',
                        icon: Icons.assignment_outlined,
                      ),
                      PortalStatData(
                        label: 'Faculty entries',
                        value: '$facultyEntries',
                        icon: Icons.groups_outlined,
                      ),
                      PortalStatData(
                        label: 'Programs in catalog',
                        value: '${widget.appState.programs.length}',
                        icon: Icons.school_outlined,
                      ),
                      PortalStatData(
                        label: 'Faculty in catalog',
                        value: '${widget.appState.faculties.length}',
                        icon: Icons.badge_outlined,
                      ),
                    ],
                  ),

                  const SizedBox(height: 44),

                  // Section 1: Fill Institute Monitoring Format (Admin Access)
                  Text(
                    '1. Fill Institute Monitoring Format (Admin Access)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: p.brand,
                    ),
                  ),
                  const SizedBox(height: 14),
                  PortalActionPanel(
                    title:
                        'Internal Institute Monitoring Format Internal Institute Monitoring Format',
                    description:
                        'Fill monitoring data directly as Admin: select Even/Odd semester, program, faculty credentials, qualification, approvals, and curriculum verification.',
                    onTap: _openMonitoringForm,
                  ),

                  const SizedBox(height: 44),

                  // Section 2: Submissions & Document Export
                  PortalCard(
                    title: '2. Submissions & Document Export',
                    caption: '${submissions.length} total submissions',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Department filter chips for Super Admin
                        if (widget.appState.isSuperAdmin)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: ['ALL', 'CM', 'IT', 'ME', 'CE'].map((dept) {
                                  final isSelected = _selectedDepartmentFilter == dept;
                                  final count = dept == 'ALL'
                                      ? submissions.length
                                      : submissions
                                          .where((s) => s.programCode.toUpperCase() == dept)
                                          .length;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ChoiceChip(
                                      label: Text('$dept ($count)'),
                                      selected: isSelected,
                                      showCheckmark: false,
                                      onSelected: (sel) {
                                        if (sel) {
                                          setState(() => _selectedDepartmentFilter = dept);
                                        }
                                      },
                                      backgroundColor: p.surface,
                                      selectedColor: p.brandDeep,
                                      side: BorderSide(
                                        color: isSelected ? p.brandDeep : p.ruleStrong,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      labelStyle: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? Colors.white : p.inkSoft,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),

                        if (displayedSubmissions.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 56),
                            decoration: BoxDecoration(
                              border: Border(top: BorderSide(color: p.rule)),
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.inbox_outlined,
                                      size: 40, color: p.ruleStrong),
                                  const SizedBox(height: 14),
                                  Text(
                                    _selectedDepartmentFilter != 'ALL'
                                        ? 'No submissions found for $_selectedDepartmentFilter department.'
                                        : 'No submissions found.',
                                    textAlign: TextAlign.center,
                                    style: AppType.display(p.ink, size: 22),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Click "Fill Form" above or switch to User role to submit a monitoring form.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      color: p.inkMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final wide = constraints.maxWidth >= 860;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (wide) _buildTableHeader(p),
                                  ...displayedSubmissions
                                      .map((sub) => _buildSubmissionRow(sub, p, wide)),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
