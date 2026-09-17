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

class AdminDashboardScreen extends StatefulWidget {
  final AppState appState;

  const AdminDashboardScreen({super.key, required this.appState});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isExporting = false;



  /// Prompts user to choose between Custom Location (Save As) and Quick Save
  void _promptExportOptions(MonitoringSubmission sub) {
    if (kIsWeb) {
      // On web, browser automatically handles download location
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
              // Option 1: Custom Location
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
              // Option 2: Default Downloads
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
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
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.redAccent, size: 26),
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
              backgroundColor: Colors.red,
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

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final submissions = widget.appState.submissions;
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
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
                    'K.K. Wagh Polytechnic, Nashik - Admin Dashboard',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                  color: Colors.amber.shade800,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.security, size: 15, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'Role: Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
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
              constraints: const BoxConstraints(maxWidth: 1040),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 28),
                children: [
                  // Admin Overview Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.25)
                              : Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 14,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 260, maxWidth: 500),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Administrator Functions',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Manage institutional curriculum catalogs, review faculty submissions, and export the official Format.docx documents.',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section 1: Fill Institute Monitoring Format (Admin Access)
                  Text(
                    '1. Fill Institute Monitoring Format (Admin Access)',
                    style: TextStyle(
                      fontSize: 17,
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
                          color: isDark ? const Color(0xFF3B82F6).withValues(alpha: 0.5) : const Color(0xFF93C5FD),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.25)
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
                              Icons.post_add,
                              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A),
                              size: 34,
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
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E3A8A),
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Fill monitoring data directly as Admin: select Even/Odd semester, program, faculty credentials, qualification, approvals, and curriculum verification.',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E3A8A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MonitoringFormScreen(
                                      appState: widget.appState),
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

                  const SizedBox(height: 28),

                  // Section 2: Submissions & Document Export
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '2. Submissions & Document Export',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      Text(
                        '${submissions.length} total submissions',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (submissions.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 48,
                              color: isDark ? const Color(0xFF64748B) : Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No submissions found.',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Click "Fill Form" above or switch to User role to submit a monitoring form.',
                              style: TextStyle(
                                color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...submissions.map((sub) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        elevation: 2,
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: isDark
                                    ? const Color(0xFF2563EB).withValues(alpha: 0.2)
                                    : const Color(0xFFEFF6FF),
                                child: Icon(Icons.assignment,
                                    color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A), size: 26),
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: sub.semesterType == 'ODD'
                                                ? (isDark
                                                    ? Colors.indigo.shade900.withValues(alpha: 0.4)
                                                    : Colors.indigo.shade50)
                                                : (isDark
                                                    ? Colors.teal.shade900.withValues(alpha: 0.4)
                                                    : Colors.teal.shade50),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              color: sub.semesterType == 'ODD'
                                                  ? (isDark ? Colors.indigo.shade400 : Colors.indigo.shade200)
                                                  : (isDark ? Colors.teal.shade400 : Colors.teal.shade200),
                                            ),
                                          ),
                                          child: Text(
                                            '${sub.semesterType} SEM',
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.bold,
                                              color: sub.semesterType == 'ODD'
                                                  ? (isDark ? Colors.indigo.shade200 : Colors.indigo.shade800)
                                                  : (isDark ? Colors.teal.shade200 : Colors.teal.shade800),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Submitted: ${DateFormat('dd MMM yyyy, hh:mm a').format(sub.submittedAt)} • ${sub.rows.length} Faculty Rows',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: sub.rows.map((r) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isDark ? const Color(0xFF0F172A) : Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                              color: isDark ? const Color(0xFF334155) : Colors.transparent,
                                            ),
                                          ),
                                          child: Text(
                                            '${r.facultyName} (${r.branchSemScheme}: ${r.courseAbbreviationCode})',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: isDark ? const Color(0xFFCBD5E1) : Colors.grey.shade700,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF1E3A8A),
                                          foregroundColor: Colors.white,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: _isExporting
                                            ? null
                                            : () => _promptExportOptions(sub),
                                        icon: const Icon(Icons.download,
                                            size: 18),
                                        label: const Text('Export docx'),
                                      ),
                                      const SizedBox(width: 4),
                                      IconButton(
                                        icon: Icon(
                                            Icons.delete_outline,
                                            color: isDark ? Colors.redAccent.shade200 : Colors.redAccent,
                                            size: 20),
                                        tooltip: 'Delete Submission',
                                        onPressed: () =>
                                            _confirmDeleteSubmission(sub),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                      foregroundColor: isDark ? const Color(0xFF93C5FD) : null,
                                    ),
                                    onPressed: () =>
                                        _showSubmissionPreview(sub),
                                    icon: const Icon(Icons.visibility,
                                        size: 15),
                                    label: const Text('Preview Details',
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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
