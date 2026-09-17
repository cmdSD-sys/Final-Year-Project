import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../services/docx_service.dart';
import '../services/excel_service.dart';
import '../utils/app_snack_bar.dart';

class ExcelUploadDialog extends StatefulWidget {
  final AppState appState;
  final VoidCallback? onViewCatalog;

  const ExcelUploadDialog({
    super.key,
    required this.appState,
    this.onViewCatalog,
  });

  @override
  State<ExcelUploadDialog> createState() => _ExcelUploadDialogState();
}

class _ExcelUploadDialogState extends State<ExcelUploadDialog> {
  bool _isUploadingFaculty = false;
  bool _isUploadingSubject = false;

  Future<void> _uploadFacultyExcel() async {
    setState(() => _isUploadingFaculty = true);
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (files.isEmpty) return;

      final file = files.first;
      final bytes = await file.readAsBytes();

      final parseResult = ExcelService.parseFacultySheet(bytes);
      if (parseResult.error != null) {
        if (!mounted) return;
        AppSnackBar.showError(context, parseResult.error!);
        return;
      }

      widget.appState.updateFacultyAndPrograms(
        newPrograms: parseResult.programs,
        newFaculties: parseResult.faculties,
      );

      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        'Successfully loaded ${parseResult.faculties.length} faculties across ${parseResult.programs.length} programs!',
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Upload failed: $e');
    } finally {
      if (mounted) setState(() => _isUploadingFaculty = false);
    }
  }

  Future<void> _uploadSubjectExcel() async {
    setState(() => _isUploadingSubject = true);
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (files.isEmpty) return;

      final file = files.first;
      final bytes = await file.readAsBytes();

      final courses = ExcelService.parseSubjectSheet(bytes);
      if (courses.isEmpty) {
        if (!mounted) return;
        AppSnackBar.showError(
          context,
          'No courses found in the uploaded sheet.',
        );
        return;
      }

      widget.appState.updateCourses(courses);

      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        'Successfully loaded ${courses.length} courses / subjects into curriculum catalog!',
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(
        context,
        'Upload failed: $e',
      );
    } finally {
      if (mounted) setState(() => _isUploadingSubject = false);
    }
  }

  Future<void> _downloadSampleFacultyTemplate() async {
    final bytes = ExcelService.createSampleFacultyExcel();
    final filename = 'Sample_Faculty_Program_Sheet.xlsx';
    final savedPath = await DocxService.saveDocxWithPicker(
      bytes: Uint8List.fromList(bytes),
      filename: filename,
      dialogTitle: 'Save Sample Faculty Excel Template',
      allowedExtensions: ['xlsx'],
    );

    if (savedPath == null) return;
    if (!mounted) return;

    final isWeb = savedPath == DocxService.webDownloadSentinel;
    AppSnackBar.showSuccess(
      context,
      isWeb
          ? 'Downloaded $filename to browser downloads.'
          : 'Saved template to: $savedPath',
      actionLabel: !isWeb ? 'Show Folder' : null,
      onAction: !isWeb ? () => DocxService.showInFolder(savedPath) : null,
    );
  }

  Future<void> _downloadSampleSubjectTemplate() async {
    final bytes = ExcelService.createSampleSubjectExcel();
    final filename = 'Sample_Subject_Curriculum_Sheet.xlsx';
    final savedPath = await DocxService.saveDocxWithPicker(
      bytes: Uint8List.fromList(bytes),
      filename: filename,
      dialogTitle: 'Save Sample Subject Excel Template',
      allowedExtensions: ['xlsx'],
    );

    if (savedPath == null) return;
    if (!mounted) return;

    final isWeb = savedPath == DocxService.webDownloadSentinel;
    AppSnackBar.showSuccess(
      context,
      isWeb
          ? 'Downloaded $filename to browser downloads.'
          : 'Saved template to: $savedPath',
      actionLabel: !isWeb ? 'Show Folder' : null,
      onAction: !isWeb ? () => DocxService.showInFolder(savedPath) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);

    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final facultiesCount = widget.appState.faculties.length;
        final programsCount = widget.appState.programs.length;
        final coursesCount = widget.appState.courses.length;

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
                  Icons.upload_file,
                  color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Excel Uploads & Catalog',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 580,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload institutional master Excel data sheets for faculty, department programs, and course curriculum contact hours.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 1. Faculty & Program Excel Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.people_alt, color: Color(0xFF2563EB), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Faculty & Program Master Sheet',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: facultiesCount > 0 ? Colors.green.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '$facultiesCount Faculties • $programsCount Depts',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: facultiesCount > 0 ? Colors.green : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Columns: Program Name, Program Code, Faculty Name, Qualification, Approval Status.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: _isUploadingFaculty ? null : _uploadFacultyExcel,
                              icon: _isUploadingFaculty
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Icon(Icons.upload, size: 16),
                              label: const Text('Upload Faculty Excel', style: TextStyle(fontSize: 12.5)),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: _downloadSampleFacultyTemplate,
                              icon: const Icon(Icons.download, size: 16),
                              label: const Text('Sample Template', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 2. Subject & Curriculum Sheet Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.library_books, color: Color(0xFF0D9488), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Subject & Curriculum Master Sheet',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: textColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: coursesCount > 0 ? Colors.teal.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '$coursesCount Subjects Loaded',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: coursesCount > 0 ? const Color(0xFF0D9488) : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Columns: Program Code, Semester (1-6), Course Code & Abbreviation, Prescribed Hrs (TH, PR, TU).',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0F766E),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: _isUploadingSubject ? null : _uploadSubjectExcel,
                              icon: _isUploadingSubject
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Icon(Icons.upload, size: 16),
                              label: const Text('Upload Subject Excel', style: TextStyle(fontSize: 12.5)),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: _downloadSampleSubjectTemplate,
                              icon: const Icon(Icons.download, size: 16),
                              label: const Text('Sample Template', style: TextStyle(fontSize: 12)),
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
