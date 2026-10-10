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

class UserHomeScreen extends StatefulWidget {
  final AppState appState;

  const UserHomeScreen({super.key, required this.appState});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  bool _isExporting = false;
  bool _isSyncing = false;

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

  void _showCatalogPreview() {
    showDialog(
      context: context,
      builder: (ctx) => CatalogPreviewDialog(appState: widget.appState),
    );
  }

  void _promptExportOptions(MonitoringSubmission sub) {
    if (kIsWeb) {
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
          dialogTitle: 'Save docx Document As',
          allowedExtensions: ['docx'],
        );
      } else {
        savedPath =
            await DocxService.saveDocxToDefaultDisk(docxBytes, filename);
      }

      if (!mounted) return;

      if (savedPath == null) {
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
              Text('docx Exported!'),
            ],
          ),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'All submitted data has been successfully injected into the authentic Format.docx template with 100% original formatting preserved.',
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
            ],
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B6A90),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(
        context,
        'Export failed: $e',
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
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
    final dept = widget.appState.currentUserDepartment;
    return Center(
      child: PortalTag(
        icon: Icons.person,
        color: p.brand,
        fill: p.brandTint,
        fontSize: 12.5,
        label: dept != null ? 'User ($dept)' : 'Role: User',
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
          Expanded(flex: 2, child: _columnLabel('Faculty entries', p)),
          const SizedBox(width: 290),
        ],
      ),
    );
  }

  Widget _buildSubmissionRow(
      BuildContext context, MonitoringSubmission sub, Pal p, bool wide) {
    final submitted = DateFormat('dd MMM yyyy, hh:mm a').format(sub.submittedAt);

    final program = Row(
      children: [
        DeptMonogram(code: sub.programCode),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            '${sub.programName} (${sub.programCode})',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: p.ink,
            ),
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
    final detailsButton = TextButton.icon(
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      ),
      onPressed: () => _showSubmissionPreview(context, sub),
      icon: const Icon(Icons.visibility_outlined, size: 15),
      label: const Text('View Details', style: TextStyle(fontSize: 12.5)),
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
              width: 290,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: detailsButton),
                  const SizedBox(width: 4),
                  exportButton,
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
                'Submitted: $submitted • ${sub.rows.length} Faculty Entries',
                style: TextStyle(fontSize: 12.5, color: p.inkMuted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [exportButton, detailsButton],
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

        final facultyEntries =
            submissions.fold<int>(0, (total, s) => total + s.rows.length);

        return PortalShell(
          appState: widget.appState,
          onOpenCatalog: _showCatalogPreview,
          title: 'User Dashboard',
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
              constraints: const BoxConstraints(maxWidth: 1000),
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
                children: [
                  // Welcome
                  Text(
                    'Welcome, Faculty Member / Staff',
                    style: AppType.display(p.ink, size: 38, height: 1.1),
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: Text(
                      'Fill out monitoring formats accurately for internal institute committee verification.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.55,
                        color: p.inkMuted,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

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

                  Text(
                    'Available Monitoring Formats',
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
                        'Fill monitoring data: select semester type (Even/Odd), choose program, assign faculty credentials, qualifications, approvals, and verify curriculum covered.',
                    onTap: _openMonitoringForm,
                  ),

                  const SizedBox(height: 44),

                  // Recent Submissions Section
                  PortalCard(
                    title: 'Recent Submissions (${submissions.length})',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (submissions.isEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 56),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.inbox_outlined,
                                      size: 40, color: p.ruleStrong),
                                  const SizedBox(height: 14),
                                  Text(
                                    'No monitoring formats submitted yet',
                                    textAlign: TextAlign.center,
                                    style: AppType.display(p.ink, size: 22),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Click "Fill Form" above to begin your first submission.',
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
                              final wide = constraints.maxWidth >= 820;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (wide) _buildTableHeader(p),
                                  ...submissions.map((sub) =>
                                      _buildSubmissionRow(context, sub, p, wide)),
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

  void _showSubmissionPreview(BuildContext context, MonitoringSubmission sub) {
    SubmissionDetailsDialog.show(
      context,
      submission: sub,
      onExport: () => _promptExportOptions(sub),
    );
  }
}
