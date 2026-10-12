import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/dept_info_model.dart';
import '../router/app_router.dart';
import '../services/app_state.dart';
import '../services/cm_report_pdf_service.dart';
import '../theme/app_theme.dart';
import '../utils/app_snack_bar.dart';
import '../widgets/portal_ui.dart';
import 'cm_forms/admission_form_view.dart';
import 'cm_forms/any_other_form_view.dart';
import 'cm_forms/co_curricular_form_view.dart';
import 'cm_forms/curriculum_form_view.dart';
import 'cm_forms/date_picker_helper.dart';
import 'cm_forms/faculty_profile_form_view.dart';
import 'cm_forms/faculty_strength_form_view.dart';
import 'cm_forms/laboratory_form_view.dart';
import 'cm_forms/resources_form_view.dart';
import 'cm_forms/result_analysis_form_view.dart';
import 'cm_forms/student_attendance_form_view.dart';

class DeptInfoFormScreen extends StatefulWidget {
  final AppState appState;
  final String? initialTabSlug;

  const DeptInfoFormScreen({
    super.key,
    required this.appState,
    this.initialTabSlug,
  });

  @override
  State<DeptInfoFormScreen> createState() => _DeptInfoFormScreenState();
}

class _DeptInfoFormScreenState extends State<DeptInfoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _academicYear;
  late String _visionMissionPrepared;
  late TextEditingController _visionApprovalDateCtrl;
  late String _nbaAccreditation;
  late TextEditingController _nbaValidFromCtrl;
  late TextEditingController _nbaValidTillCtrl;
  String? _nbaFileName;

  late String _internalAuditOnce6Months;
  late TextEditingController _internalAuditDateCtrl;
  late TextEditingController _internalSuggestionsCtrl;
  late TextEditingController _internalCorrectiveActionCtrl;

  late String _newFacilityCreated;
  late String _feedbackMechanismAdopted;
  late String _feedbackAnalysisDone;
  late String _feedbackCorrectiveActionDone;
  late String _smartClassroomAvailable;
  late String _biometricAttendanceAvailable;
  late String _refresherCourses;
  late String _professionalActivities;
  late String _centerOfExcellence;
  late String _moocsCoursesFacility;
  late TextEditingController _techJournalsCountCtrl;
  late String _remedialLectures;
  late String _industrialTrainingAssessment;
  late String _incubationWithIndustries;
  late String _parentMeet;

  bool _isExporting = false;
  int _selectedTabIndex = 0;

  final List<String> _options11 = [
    'Dept Information',
    'Admission',
    'Faculty Strength',
    'Faculty Profile',
    'Laboratory',
    'Curriculum',
    'Student Attendance',
    'Result Analysis',
    'Resources',
    'Co-Curricular Activities',
    'Any Other Information',
  ];

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = CmReportTabs.getIndex(widget.initialTabSlug);
    _loadFromState();
  }

  @override
  void didUpdateWidget(covariant DeptInfoFormScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTabSlug != widget.initialTabSlug) {
      final newIndex = CmReportTabs.getIndex(widget.initialTabSlug);
      if (newIndex != _selectedTabIndex) {
        setState(() => _selectedTabIndex = newIndex);
      }
    }
  }

  void _loadFromState() {
    final info = widget.appState.currentDeptInfo;
    _academicYear = info.academicYear;
    _visionMissionPrepared = info.visionMissionPrepared;
    _visionApprovalDateCtrl =
        TextEditingController(text: info.visionMissionApprovalDate);
    _nbaAccreditation = info.nbaAccreditation;
    _nbaValidFromCtrl = TextEditingController(text: info.nbaValidFrom);
    _nbaValidTillCtrl = TextEditingController(text: info.nbaValidTill);
    _nbaFileName = info.nbaCertificateFileName;

    _internalAuditOnce6Months = info.internalAuditOnce6Months;
    _internalAuditDateCtrl =
        TextEditingController(text: info.internalAuditDate);
    _internalSuggestionsCtrl =
        TextEditingController(text: info.internalAuditSuggestions);
    _internalCorrectiveActionCtrl =
        TextEditingController(text: info.internalAuditCorrectiveAction);

    _newFacilityCreated = info.newFacilityCreated;
    _feedbackMechanismAdopted = info.feedbackMechanismAdopted;
    _feedbackAnalysisDone = info.feedbackAnalysisDone;
    _feedbackCorrectiveActionDone = info.feedbackCorrectiveActionDone;
    _smartClassroomAvailable = info.smartClassroomAvailable;
    _biometricAttendanceAvailable = info.biometricAttendanceAvailable;
    _refresherCourses = info.refresherCoursesDirect2ndYear;
    _professionalActivities = info.professionalActivities;
    _centerOfExcellence = info.centerOfExcellence;
    _moocsCoursesFacility = info.moocsCoursesFacility;
    _techJournalsCountCtrl =
        TextEditingController(text: info.techJournalsCount.toString());
    _remedialLectures = info.remedialLectures;
    _industrialTrainingAssessment = info.industrialTrainingAssessment;
    _incubationWithIndustries = info.incubationWithIndustries;
    _parentMeet = info.parentMeet;
  }

  @override
  void dispose() {
    _visionApprovalDateCtrl.dispose();
    _nbaValidFromCtrl.dispose();
    _nbaValidTillCtrl.dispose();
    _internalAuditDateCtrl.dispose();
    _internalSuggestionsCtrl.dispose();
    _internalCorrectiveActionCtrl.dispose();
    _techJournalsCountCtrl.dispose();
    super.dispose();
  }

  DeptInfoModel _buildModel() {
    final count = int.tryParse(_techJournalsCountCtrl.text.trim()) ?? 6;
    return widget.appState.currentDeptInfo.copyWith(
      departmentName: 'Computer Technology',
      academicYear: _academicYear,
      visionMissionPrepared: _visionMissionPrepared,
      visionMissionApprovalDate: _visionApprovalDateCtrl.text.trim(),
      nbaAccreditation: _nbaAccreditation,
      nbaValidFrom: _nbaValidFromCtrl.text.trim(),
      nbaValidTill: _nbaValidTillCtrl.text.trim(),
      nbaCertificateFileName: _nbaFileName,
      internalAuditOnce6Months: _internalAuditOnce6Months,
      internalAuditDate: _internalAuditDateCtrl.text.trim(),
      internalAuditSuggestions: _internalSuggestionsCtrl.text.trim(),
      internalAuditCorrectiveAction: _internalCorrectiveActionCtrl.text.trim(),
      newFacilityCreated: _newFacilityCreated,
      feedbackMechanismAdopted: _feedbackMechanismAdopted,
      feedbackAnalysisDone: _feedbackAnalysisDone,
      feedbackCorrectiveActionDone: _feedbackCorrectiveActionDone,
      smartClassroomAvailable: _smartClassroomAvailable,
      biometricAttendanceAvailable: _biometricAttendanceAvailable,
      refresherCoursesDirect2ndYear: _refresherCourses,
      professionalActivities: _professionalActivities,
      centerOfExcellence: _centerOfExcellence,
      moocsCoursesFacility: _moocsCoursesFacility,
      techJournalsCount: count,
      remedialLectures: _remedialLectures,
      industrialTrainingAssessment: _industrialTrainingAssessment,
      incubationWithIndustries: _incubationWithIndustries,
      parentMeet: _parentMeet,
      lastUpdated: DateTime.now(),
    );
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;
    final updated = _buildModel();
    widget.appState.updateDeptInfo(updated);
    AppSnackBar.showSuccess(
      context,
      'Department Information for Computer Technology (CM) saved successfully!',
    );
  }

  Future<void> _pickNbaCertificate() async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (!mounted) return;
      if (files.isNotEmpty) {
        setState(() {
          _nbaFileName = files.first.name;
        });
        AppSnackBar.showSuccess(
          context,
          'Attached NBA Certificate: $_nbaFileName',
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(context, 'Failed to pick file: $e');
    }
  }

  Future<void> _exportPdfReport() async {
    final updated = _buildModel();
    widget.appState.updateDeptInfo(updated);

    if (kIsWeb) {
      _doExport(updated, customLocation: true);
      return;
    }

    final p = Pal.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: p.surface,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        side: BorderSide(color: p.rule),
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
                      color: p.dangerTint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.picture_as_pdf, color: p.danger),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Export CM_Report.pdf',
                          style: AppType.display(p.ink, size: 20, height: 1.2),
                        ),
                        Text(
                          'Official 20-Page MSBTE Monitoring Report (Computer Technology)',
                          style: TextStyle(
                            fontSize: 13,
                            color: p.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Choose where to save the generated PDF report:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: p.inkSoft),
              ),
              const SizedBox(height: 12),
              Material(
                color: p.brandTint,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: p.brand.withValues(alpha: 0.4)),
                ),
                child: ListTile(
                  leading: Icon(Icons.folder_open, color: p.brand, size: 26),
                  title: Text('Save to Custom Location (Save As...)',
                      style: TextStyle(fontWeight: FontWeight.w600, color: p.ink)),
                  subtitle: Text(
                      'Pick any folder on your computer (e.g. Desktop, Documents, or D: drive).',
                      style: TextStyle(color: p.inkMuted)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 14, color: p.inkSoft),
                  onTap: () {
                    Navigator.pop(ctx);
                    _doExport(updated, customLocation: true);
                  },
                ),
              ),
              const SizedBox(height: 10),
              Material(
                color: p.surfaceAlt,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: p.rule),
                ),
                child: ListTile(
                  leading: Icon(Icons.download_done, color: p.inkSoft, size: 26),
                  title: Text('Quick Save to Downloads Folder',
                      style: TextStyle(fontWeight: FontWeight.w600, color: p.ink)),
                  subtitle: Text(
                      'Instantly save to your standard system Downloads folder.',
                      style: TextStyle(color: p.inkMuted)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 14, color: p.inkSoft),
                  onTap: () {
                    Navigator.pop(ctx);
                    _doExport(updated, customLocation: false);
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _doExport(DeptInfoModel model,
      {required bool customLocation}) async {
    setState(() => _isExporting = true);
    try {
      final pdfBytes =
          await CmReportPdfService.generateCmReportPdf(data: model);
      final filename = CmReportPdfService.generateFilename(model);

      final String? savedPath;
      if (customLocation) {
        savedPath = await CmReportPdfService.savePdfWithPicker(
          bytes: pdfBytes,
          filename: filename,
        );
      } else {
        savedPath =
            await CmReportPdfService.savePdfToDefaultDisk(pdfBytes, filename);
      }

      if (!mounted) return;

      if (savedPath == null) {
        AppSnackBar.showInfo(context, 'Export cancelled.');
        return;
      }

      final resolvedPath = savedPath;
      final isWeb = resolvedPath == CmReportPdfService.webDownloadSentinel;
      final p = Pal.of(context);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: p.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: p.rule)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: p.success, size: 26),
              const SizedBox(width: 10),
              Text(
                'CM_Report.pdf Exported!',
                style: AppType.display(p.ink, size: 20, height: 1.2),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The official 20-page MSBTE Computer Technology Monitoring Report has been exported with 100% pixel-perfect fidelity. All Dept Information fields have been injected into the report.',
                style: TextStyle(fontSize: 13.5, color: p.inkSoft),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: p.surfaceAlt,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: p.rule),
                ),
                child: SelectableText(
                  isWeb
                      ? 'Downloaded to your browser Downloads folder as:\n$filename'
                      : resolvedPath,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                    color: p.brand,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            if (!isWeb) ...[
              OutlinedButton.icon(
                onPressed: () => CmReportPdfService.showInFolder(resolvedPath),
                icon: const Icon(Icons.folder_open, size: 16),
                label: const Text('Show in Folder'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: p.brand,
                  foregroundColor: p.onBrand,
                ),
                onPressed: () {
                  CmReportPdfService.openDocument(resolvedPath);
                  Navigator.pop(ctx);
                },
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Open PDF'),
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
      AppSnackBar.showError(context, 'PDF Export failed: $e');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  void _onTabTapped(int index) {
    if (index == _selectedTabIndex) return;
    setState(() => _selectedTabIndex = index);
    if (GoRouter.maybeOf(context) != null) {
      final slug = CmReportTabs.getSlug(index);
      context.go('${AppRoutes.cmReport}/$slug');
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);

    return Scaffold(
      backgroundColor: p.paper,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Dashboard',
          onPressed: () {
            if (GoRouter.maybeOf(context) != null) {
              final destination = widget.appState.isAdminOrSuper
                  ? AppRoutes.admin
                  : AppRoutes.user;
              context.go(destination);
            } else {
              Navigator.maybePop(context);
            }
          },
        ),
        title: const PortalAppBarTitle(
          subtitle: 'MSBTE Monitoring Report (CM)',
        ),
        actions: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: p.danger,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: _isExporting ? null : _exportPdfReport,
            icon: _isExporting
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.picture_as_pdf, size: 17),
            label: const Text(
              'Export PDF',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: p.brand,
              foregroundColor: p.onBrand,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: _saveChanges,
            icon: const Icon(Icons.save, size: 17),
            label: const Text(
              'Save Changes',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. The 11 Options Navigation Bar (Matching sampleScreen)
                  PortalPanel(
                    color: p.surface,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.tab, size: 18, color: p.brand),
                            const SizedBox(width: 8),
                            Text(
                              'MSBTE Monitoring Sections (11 Screens)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: p.ink,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: p.brandTint,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: p.brand.withValues(alpha: 0.3)),
                              ),
                              child: Text(
                                'Screen ${_selectedTabIndex + 1} Active',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: p.brand,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(_options11.length, (i) {
                            final title = _options11[i];
                            final isActive = i == _selectedTabIndex;
                            return ChoiceChip(
                              label: Text(
                                '${i + 1}. $title',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isActive
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isActive
                                      ? p.onBrand
                                      : p.inkSoft,
                                ),
                              ),
                              selected: isActive,
                              selectedColor: p.brand,
                              backgroundColor: p.surfaceAlt,
                              side: BorderSide(
                                color: isActive ? p.brand : p.rule,
                              ),
                              onSelected: (_) => _onTabTapped(i),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildCurrentTabContent(p),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentTabContent(Pal p) {
    if (_selectedTabIndex == 1) {
      return AdmissionFormView(
        appState: widget.appState,
        onExportPdf: _exportPdfReport,
      );
    } else if (_selectedTabIndex == 2) {
      return FacultyStrengthFormView(
        appState: widget.appState,
        onExportPdf: _exportPdfReport,
      );
    } else if (_selectedTabIndex == 3) {
      return FacultyProfileFormView(
        appState: widget.appState,
        onExportPdf: _exportPdfReport,
      );
    } else if (_selectedTabIndex == 4) {
      return LaboratoryFormView(
        appState: widget.appState,
        onExportPdf: _exportPdfReport,
      );
    } else if (_selectedTabIndex == 5) {
      return CurriculumFormView(
        appState: widget.appState,
        onExportPdf: _exportPdfReport,
      );
    } else if (_selectedTabIndex == 6) {
      return StudentAttendanceFormView(
        appState: widget.appState,
        onExportPdf: _exportPdfReport,
      );
    } else if (_selectedTabIndex == 7) {
      return ResultAnalysisFormView(
        appState: widget.appState,
        onExportPdf: _exportPdfReport,
      );
    } else if (_selectedTabIndex == 8) {
      return ResourcesFormView(
        appState: widget.appState,
        onExportPdf: _exportPdfReport,
      );
    } else if (_selectedTabIndex == 9) {
      return CoCurricularFormView(
        appState: widget.appState,
        onExportPdf: _exportPdfReport,
      );
    } else if (_selectedTabIndex == 10) {
      return AnyOtherFormView(
        appState: widget.appState,
        onExportPdf: _exportPdfReport,
      );
    }
    return _buildDeptInfoTabContent(p);
  }

  Widget _buildDeptInfoTabContent(Pal p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 2. Department Selection & Instruction Banner
        PortalPanel(
          color: p.brandTint,
          padding: const EdgeInsets.all(16),
          child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: p.brand,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(Icons.computer, color: p.onBrand, size: 16),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Department Selected : Computer Technology (CM)',
                                style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                  color: p.ink,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: p.success,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'CM Exclusive',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Important Instructions:\n'
                          '• The fields marked with (*) are mandatory.\n'
                          '• Fill all the details and click on "Save Changes" or "Export PDF" button to generate the authentic 20-page MSBTE CM_Report.pdf.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: p.inkSoft,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 3. Dept Details Form Card
                  PortalPanel(
                    color: p.surface,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 10,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Dept Details',
                              style: AppType.display(p.ink, size: 22, height: 1.2),
                            ),
                            Text(
                              '• Last Updated: ${DateFormat('dd/MM/yyyy hh:mm:ss a').format(widget.appState.currentDeptInfo.lastUpdated)}',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: p.inkMuted,
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 24, color: p.rule),

                          // Row 1: Name of Department & Academic Year
                          _buildSectionHeader('1. General Department Identification'),
                          _buildFormRow(
                            label: 'Name of Department',
                            isMandatory: true,
                            child: TextFormField(
                              initialValue: 'Computer Technology',
                              readOnly: true,
                              decoration: _inputDecoration(isReadOnly: true),
                            ),
                          ),
                          _buildFormRow(
                            label: 'Academic Year',
                            isMandatory: true,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _academicYear,
                              decoration: _inputDecoration(),
                              items: const [
                                DropdownMenuItem(
                                    value: '2024-25', child: Text('2024-25')),
                                DropdownMenuItem(
                                    value: '2025-26', child: Text('2025-26')),
                                DropdownMenuItem(
                                    value: '2026-27', child: Text('2026-27')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _academicYear = val);
                              },
                            ),
                          ),

                          const SizedBox(height: 16),
                          _buildSectionHeader('2. Vision & Mission'),

                          _buildFormRow(
                            label:
                                'Whether Vision and Mission statements for department is prepared?',
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _visionMissionPrepared,
                              decoration: _inputDecoration(),
                              items: _yesNoItems(),
                              onChanged: (v) =>
                                  setState(() => _visionMissionPrepared = v!),
                            ),
                          ),

                          if (_visionMissionPrepared == 'Yes')
                            _buildFormRow(
                              label:
                                  'If yes, date of approval in Governing Board meeting/ Stake holders -',
                              child: TextFormField(
                                controller: _visionApprovalDateCtrl,
                                readOnly: true,
                                onTap: () => showCmDatePicker(
                                  context: context,
                                  controller: _visionApprovalDateCtrl,
                                ),
                                decoration: _inputDecoration(
                                  hintText: 'e.g. 20/06/2017 or 20/02/2025',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today,
                                        size: 18),
                                    tooltip: 'Choose date from calendar',
                                    onPressed: () => showCmDatePicker(
                                      context: context,
                                      controller: _visionApprovalDateCtrl,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          const SizedBox(height: 16),
                          _buildSectionHeader('3. NBA Accreditation'),

                          _buildFormRow(
                            label: 'Accreditation By NBA *',
                            isMandatory: true,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _nbaAccreditation,
                              decoration: _inputDecoration(),
                              items: const [
                                DropdownMenuItem(
                                    value: 'Accreditated',
                                    child: Text('Accreditated')),
                                DropdownMenuItem(
                                    value: 'Applied for Accreditation',
                                    child: Text('Applied for Accreditation')),
                                DropdownMenuItem(
                                    value: 'Eligible but not applied',
                                    child: Text('Eligible but not applied')),
                                DropdownMenuItem(
                                    value: 'Not Accreditated',
                                    child: Text('Not Accreditated')),
                              ],
                              onChanged: (v) =>
                                  setState(() => _nbaAccreditation = v!),
                            ),
                          ),

                          _buildFormRow(
                            label: 'Valid from -',
                            child: TextFormField(
                              controller: _nbaValidFromCtrl,
                              readOnly: true,
                              onTap: () => showCmDatePicker(
                                context: context,
                                controller: _nbaValidFromCtrl,
                                format: 'd-M-yyyy',
                              ),
                              decoration: _inputDecoration(
                                hintText: '1-7-2023',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today,
                                      size: 18),
                                  tooltip: 'Choose date from calendar',
                                  onPressed: () => showCmDatePicker(
                                    context: context,
                                    controller: _nbaValidFromCtrl,
                                    format: 'd-M-yyyy',
                                  ),
                                ),
                              ),
                            ),
                          ),

                          _buildFormRow(
                            label: 'Valid Till -',
                            child: TextFormField(
                              controller: _nbaValidTillCtrl,
                              readOnly: true,
                              onTap: () => showCmDatePicker(
                                context: context,
                                controller: _nbaValidTillCtrl,
                                format: 'd-M-yyyy',
                              ),
                              decoration: _inputDecoration(
                                hintText: '30-6-2026',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today,
                                      size: 18),
                                  tooltip: 'Choose date from calendar',
                                  onPressed: () => showCmDatePicker(
                                    context: context,
                                    controller: _nbaValidTillCtrl,
                                    format: 'd-M-yyyy',
                                  ),
                                ),
                              ),
                            ),
                          ),

                          _buildFormRow(
                            label:
                                'Upload Scanned pdf of NBA Certificate (Max 2MB)',
                            child: Row(
                              children: [
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: _pickNbaCertificate,
                                  icon: const Icon(Icons.upload_file, size: 18),
                                  label: const Text('Choose File'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _nbaFileName ?? 'No file chosen',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _nbaFileName != null
                                          ? p.success
                                          : p.inkMuted,
                                      fontStyle: _nbaFileName != null
                                          ? FontStyle.normal
                                          : FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          _buildSectionHeader('4. Internal Academic Audit'),

                          _buildFormRow(
                            label:
                                'Internal Academic Audit (Once in 6 Months) *',
                            isMandatory: true,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _internalAuditOnce6Months,
                              decoration: _inputDecoration(),
                              items: _yesNoItems(),
                              onChanged: (v) =>
                                  setState(() => _internalAuditOnce6Months = v!),
                            ),
                          ),

                          _buildFormRow(
                            label: 'Date of Internal academic monitoring',
                            child: TextFormField(
                              controller: _internalAuditDateCtrl,
                              readOnly: true,
                              onTap: () => showCmDatePicker(
                                context: context,
                                controller: _internalAuditDateCtrl,
                                format: 'dd-MM-yyyy',
                              ),
                              decoration: _inputDecoration(
                                hintText: '11-09-2026',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today,
                                      size: 18),
                                  tooltip: 'Choose date from calendar',
                                  onPressed: () => showCmDatePicker(
                                    context: context,
                                    controller: _internalAuditDateCtrl,
                                    format: 'dd-MM-yyyy',
                                  ),
                                ),
                              ),
                            ),
                          ),

                          _buildFormRow(
                            label:
                                'Suggestions given by Internal academic monitoring committee',
                            child: TextFormField(
                              controller: _internalSuggestionsCtrl,
                              maxLines: 2,
                              decoration: _inputDecoration(
                                hintText:
                                    'Improve Faculty participation in FDP/Trainings.',
                              ),
                            ),
                          ),

                          _buildFormRow(
                            label: 'Corrective action taken by the department',
                            child: TextFormField(
                              controller: _internalCorrectiveActionCtrl,
                              maxLines: 2,
                              decoration: _inputDecoration(
                                hintText:
                                    'Guided faculty members to register for MSBTE and other FDP Programs',
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          _buildSectionHeader('5. Facilities & Student Feedback'),

                          _buildFormRow(
                            label:
                                'New Facility created (Additional new laboratory, Modernization of Laboratory, Development of learning resources developed etc.) *',
                            isMandatory: true,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _newFacilityCreated,
                              decoration: _inputDecoration(),
                              items: _yesNoItems(),
                              onChanged: (v) =>
                                  setState(() => _newFacilityCreated = v!),
                            ),
                          ),

                          _buildFormRow(
                            label:
                                'Mechanism of student feedback, analysis and corrective action is adopted ( As per MSBTE format) *',
                            isMandatory: true,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _feedbackMechanismAdopted,
                              decoration: _inputDecoration(),
                              items: _yesNoItems(),
                              onChanged: (v) => setState(
                                  () => _feedbackMechanismAdopted = v!),
                            ),
                          ),

                          _buildFormRow(
                            label: 'Whether Analysis of Feedback done?',
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _feedbackAnalysisDone,
                              decoration: _inputDecoration(),
                              items: _yesNoItems(),
                              onChanged: (v) =>
                                  setState(() => _feedbackAnalysisDone = v!),
                            ),
                          ),

                          _buildFormRow(
                            label: 'Whether Corrective Action done?',
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _feedbackCorrectiveActionDone,
                              decoration: _inputDecoration(),
                              items: _yesNoItems(),
                              onChanged: (v) => setState(
                                  () => _feedbackCorrectiveActionDone = v!),
                            ),
                          ),

                          const SizedBox(height: 16),
                          _buildSectionHeader(
                              '6. Academic Infrastructure & Support'),

                          _buildFormRow(
                            label:
                                'Availability of Smart Classroom (at least one) *',
                            isMandatory: true,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _smartClassroomAvailable,
                              decoration: _inputDecoration(),
                              items: _yesNoItems(),
                              onChanged: (v) =>
                                  setState(() => _smartClassroomAvailable = v!),
                            ),
                          ),

                          _buildFormRow(
                            label:
                                'Whether Biometric Attendance is Available? *',
                            isMandatory: true,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _biometricAttendanceAvailable,
                              decoration: _inputDecoration(),
                              items: _yesNoItems(),
                              onChanged: (v) => setState(
                                  () => _biometricAttendanceAvailable = v!),
                            ),
                          ),

                          _buildFormRow(
                            label:
                                'Conduct of refresher courses for direct 2nd year admitted students for acquring pre-requisite technical knowledge to cater requirement of direct 2nd year subjects/(NA for Pharmacy) *',
                            isMandatory: true,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _refresherCourses,
                              decoration: _inputDecoration(),
                              items: const [
                                DropdownMenuItem(
                                    value: 'Yes', child: Text('Yes')),
                                DropdownMenuItem(value: 'No', child: Text('No')),
                                DropdownMenuItem(value: 'NA', child: Text('NA')),
                              ],
                              onChanged: (v) =>
                                  setState(() => _refresherCourses = v!),
                            ),
                          ),

                          _buildFormRow(
                            label:
                                'Professional activities ( Institutional magazine/ Technical magazine/ Newsletter)',
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _professionalActivities,
                              decoration: _inputDecoration(),
                              items: _yesNoItems(),
                              onChanged: (v) =>
                                  setState(() => _professionalActivities = v!),
                            ),
                          ),

                          _buildFormRow(
                            label:
                                'Eshtablishment of Center of excellence/Startup/Incubation Center in collaboration with industries',
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _centerOfExcellence,
                              decoration: _inputDecoration(),
                              items: _yesNoItems(),
                              onChanged: (v) =>
                                  setState(() => _centerOfExcellence = v!),
                            ),
                          ),

                          _buildFormRow(
                            label:
                                'Facility to watch MOOCS Courses through SWAYAM/Spoken Tutorials or Any Other Platform',
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _moocsCoursesFacility,
                              decoration: _inputDecoration(),
                              items: _yesNoItems(),
                              onChanged: (v) =>
                                  setState(() => _moocsCoursesFacility = v!),
                            ),
                          ),

                          _buildFormRow(
                            label:
                                'No. of technical journals subscribed [hard copies] per branch',
                            child: TextFormField(
                              controller: _techJournalsCountCtrl,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration(hintText: '6'),
                            ),
                          ),

                          _buildFormRow(
                            label:
                                'Remedial lectures conducted for weaker students.',
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _remedialLectures,
                              decoration: _inputDecoration(),
                              items: const [
                                DropdownMenuItem(
                                    value: 'Implemented',
                                    child: Text('Implemented')),
                                DropdownMenuItem(
                                    value: 'Not Implemented',
                                    child: Text('Not Implemented')),
                              ],
                              onChanged: (v) =>
                                  setState(() => _remedialLectures = v!),
                            ),
                          ),

                          _buildFormRow(
                            label:
                                'Assessment of Students eligible for Industrial Training(As per MSBTE norms)',
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _industrialTrainingAssessment,
                              decoration: _inputDecoration(),
                              items: const [
                                DropdownMenuItem(
                                    value: '100% Eligible Students',
                                    child: Text('100% Eligible Students')),
                                DropdownMenuItem(
                                    value: 'Less than 100% Eligible Students',
                                    child: Text(
                                        'Less than 100% Eligible Students')),
                              ],
                              onChanged: (v) => setState(
                                  () => _industrialTrainingAssessment = v!),
                            ),
                          ),

                          _buildFormRow(
                            label:
                                'Establishment of Center of Excellence/Start up/Incubation with industries',
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _incubationWithIndustries,
                              decoration: _inputDecoration(),
                              items: _yesNoItems(),
                              onChanged: (v) => setState(
                                  () => _incubationWithIndustries = v!),
                            ),
                          ),

                          _buildFormRow(
                            label: 'Parent Meet',
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _parentMeet,
                              decoration: _inputDecoration(),
                              items: const [
                                DropdownMenuItem(
                                    value:
                                        'Conducted and Documents well maintained',
                                    child: Text(
                                        'Conducted and Documents well maintained')),
                                DropdownMenuItem(
                                    value: 'Not Conducted',
                                    child: Text('Not Conducted')),
                              ],
                              onChanged: (v) =>
                                  setState(() => _parentMeet = v!),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Bottom Action Bar
                          Wrap(
                            alignment: WrapAlignment.end,
                            spacing: 12,
                            runSpacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                onPressed: () {
                                  widget.appState.updateDeptInfo(
                                      DeptInfoModel.defaultSample());
                                  setState(_loadFromState);
                                  AppSnackBar.showInfo(
                                      context, 'Reset to MSBTE reference sample data.');
                                },
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text('Reset Defaults'),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: p.danger,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                onPressed: _isExporting ? null : _exportPdfReport,
                                icon: const Icon(Icons.picture_as_pdf, size: 18),
                                label: const Text(
                                  'Export CM_Report.pdf',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: p.brand,
                                  foregroundColor: p.onBrand,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                onPressed: _saveChanges,
                                icon: const Icon(Icons.save, size: 18),
                                label: const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    final p = Pal.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10, bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: p.surfaceAlt,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: p.rule),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.bold,
          color: p.brand,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildFormRow({
    required String label,
    required Widget child,
    bool isMandatory = false,
  }) {
    final p = Pal.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 650;
          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: p.ink,
                    ),
                    children: [
                      if (isMandatory)
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: p.danger,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                child,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: RichText(
                  text: TextSpan(
                    text: label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: p.ink,
                    ),
                    children: [
                      if (isMandatory)
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: p.danger,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 5,
                child: child,
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
    Widget? suffixIcon,
    bool isReadOnly = false,
  }) {
    final p = Pal.of(context);
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontSize: 13, color: p.inkMuted),
      suffixIcon: suffixIcon,
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      filled: isReadOnly,
      fillColor: isReadOnly ? p.surfaceAlt : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: p.ruleStrong),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: isReadOnly ? p.rule : p.ruleStrong),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: p.brand, width: 1.5),
      ),
    );
  }

  List<DropdownMenuItem<String>> _yesNoItems() {
    return const [
      DropdownMenuItem(value: 'Yes', child: Text('Yes')),
      DropdownMenuItem(value: 'No', child: Text('No')),
    ];
  }
}
