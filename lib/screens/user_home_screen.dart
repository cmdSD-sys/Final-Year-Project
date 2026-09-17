import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/docx_service.dart';
import '../utils/app_snack_bar.dart';
import '../widgets/app_navigation_drawer.dart';
import '../widgets/catalog_preview_dialog.dart';
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

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.download, color: Color(0xFF1E3A8A)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Export docx Document',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${sub.programName} (${sub.programCode}) • ${sub.semesterType} Sem',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose where to save the generated document:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.blue.shade200),
                ),
                tileColor: Colors.blue.shade50.withValues(alpha: 0.4),
                leading: const Icon(Icons.folder_open,
                    color: Color(0xFF1E3A8A), size: 28),
                title: const Text('Save to Custom Location (Save As...)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text(
                    'Pick any folder on your computer (e.g. Desktop, Documents, or D: drive).'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(ctx);
                  _doExportSubmissionDocx(sub, customLocation: true);
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                tileColor: Colors.grey.shade50,
                leading: const Icon(Icons.download_done,
                    color: Color(0xFF0F766E), size: 28),
                title: const Text('Quick Save to Downloads Folder',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text(
                    'Instantly save to your standard system Downloads folder.'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
      final docxBytes = await DocxService.generateDocx(submission: sub);
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
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
                  style: TextStyle(fontSize: 13.5, color: Color(0xFF475569)),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isWebDownload
                        ? Colors.blue.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isWebDownload
                            ? Colors.blue.shade200
                            : Colors.grey.shade300),
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
                            color: const Color(0xFF1E3A8A),
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
                            color: Color(0xFF1E3A8A)),
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
                backgroundColor: const Color(0xFF1E3A8A),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final submissions = widget.appState.submissions;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          drawer: AppNavigationDrawer(
            appState: widget.appState,
            onOpenCatalog: _showCatalogPreview,
          ),
          appBar: AppBar(
            elevation: 2,
            leading: Builder(
              builder: (ctx) => InkWell(
                onTap: () => Scaffold.of(ctx).openDrawer(),
                borderRadius: BorderRadius.circular(20),
                child: Center(
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white24,
                    backgroundImage: widget.appState.currentUserPfpBytes != null
                        ? MemoryImage(widget.appState.currentUserPfpBytes!)
                        : null,
                    child: widget.appState.currentUserPfpBytes == null
                        ? const Icon(Icons.person, color: Colors.white, size: 20)
                        : null,
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/nobgkkwp.png',
                    height: 40,
                    cacheHeight: 120,
                    filterQuality: FilterQuality.high,
                    isAntiAlias: true,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(Icons.school, size: 24, color: Color(0xFF1E3A8A)),
                  ),
                ),
                const SizedBox(width: 12),
                const Flexible(
                  child: Text(
                    'K.K. Wagh Polytechnic, Nashik - User Dashboard',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2563EB).withValues(alpha: 0.3)
                      : Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF60A5FA)
                        : Colors.blue.shade300,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.person, size: 15, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'Role: User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                children: [
                  // Welcome Banner
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF1E3A8A), const Color(0xFF1E293B)]
                            : [const Color(0xFF1E3A8A), const Color(0xFF2563EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.3)
                              : Colors.blue.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.assignment_turned_in,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome, Faculty Member / Staff',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Fill out monitoring formats accurately for internal institute committee verification.',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // The primary requested option
                  Text(
                    'Available Monitoring Formats',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MonitoringFormScreen(appState: widget.appState),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF3B82F6).withValues(alpha: 0.5)
                              : const Color(0xFF93C5FD),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.2)
                                : Colors.blue.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2563EB).withValues(alpha: 0.2)
                                  : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.description,
                              color: isDark
                                  ? const Color(0xFF60A5FA)
                                  : const Color(0xFF1E3A8A),
                              size: 36,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Internal Institute Monitoring Format Internal Institute Monitoring Format',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? const Color(0xFF93C5FD)
                                        : const Color(0xFF1E3A8A),
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Fill monitoring data: select semester type (Even/Odd), choose program, assign faculty credentials, qualifications, approvals, and verify curriculum covered.',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: isDark
                                        ? const Color(0xFF94A3B8)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3A8A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      MonitoringFormScreen(appState: widget.appState),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_note, size: 20),
                            label: const Text('Fill Form'),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Recent Submissions Section
                  Text(
                    'Recent Submissions (${submissions.length})',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (submissions.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 48,
                            color: isDark
                                ? const Color(0xFF64748B)
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No monitoring formats submitted yet',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFFCBD5E1)
                                  : Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Click "Fill Form" above to begin your first submission.',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark
                                  ? const Color(0xFF94A3B8)
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...submissions.map((sub) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: isDark
                                    ? const Color(0xFF2563EB).withValues(alpha: 0.2)
                                    : const Color(0xFFEFF6FF),
                                child: Icon(Icons.check,
                                    color: isDark
                                        ? const Color(0xFF60A5FA)
                                        : const Color(0xFF1E3A8A)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 8,
                                      runSpacing: 4,
                                      children: [
                                        Text(
                                          '${sub.programName} (${sub.programCode})',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: isDark
                                                ? Colors.white
                                                : const Color(0xFF0F172A),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: sub.semesterType == 'ODD'
                                                ? Colors.indigo.shade50
                                                : Colors.teal.shade50,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              color: sub.semesterType == 'ODD'
                                                  ? Colors.indigo.shade200
                                                  : Colors.teal.shade200,
                                            ),
                                          ),
                                          child: Text(
                                            '${sub.semesterType} SEM',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: sub.semesterType == 'ODD'
                                                  ? Colors.indigo.shade800
                                                  : Colors.teal.shade800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Submitted: ${DateFormat('dd MMM yyyy, hh:mm a').format(sub.submittedAt)} • ${sub.rows.length} Faculty Entries',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: isDark
                                            ? const Color(0xFF94A3B8)
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1E3A8A),
                                      foregroundColor: Colors.white,
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: _isExporting
                                        ? null
                                        : () => _promptExportOptions(sub),
                                    icon: const Icon(Icons.download, size: 16),
                                    label: const Text('Export docx'),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton.icon(
                                    onPressed: () =>
                                        _showSubmissionPreview(context, sub),
                                    icon: const Icon(Icons.visibility, size: 16),
                                    label: const Text('View Details'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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
