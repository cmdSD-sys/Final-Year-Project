import 'package:flutter/material.dart';
import '../../models/cm_sections_model.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_snack_bar.dart';
import '../../widgets/portal_ui.dart';
import 'date_picker_helper.dart';

class CurriculumFormView extends StatefulWidget {
  final AppState appState;
  final VoidCallback onExportPdf;

  const CurriculumFormView({
    super.key,
    required this.appState,
    required this.onExportPdf,
  });

  @override
  State<CurriculumFormView> createState() => _CurriculumFormViewState();
}

class _CurriculumFormViewState extends State<CurriculumFormView> {
  late TextEditingController _totalWeeksCtrl;
  late TextEditingController _weeksAvailableDateCtrl;
  late TextEditingController _weeksAvailableCountCtrl;
  late TextEditingController _pptPctCtrl;
  late TextEditingController _lessonPlanPctCtrl;
  late TextEditingController _labPlanPctCtrl;
  late TextEditingController _lecturesPctCtrl;
  late String _refresherCourses;
  late TextEditingController _feedbackPctCtrl;
  late List<CurriculumSubjectItem> _subjects;
  int? _selectedSemFilter;
  String _searchFilter = '';

  @override
  void initState() {
    super.initState();
    _loadFromState();
  }

  void _loadFromState() {
    final d = widget.appState.cmSections.curriculum;
    _totalWeeksCtrl =
        TextEditingController(text: d.totalWeeksScheme.toString());
    _weeksAvailableDateCtrl =
        TextEditingController(text: d.weeksAvailableUptoDate);
    _weeksAvailableCountCtrl =
        TextEditingController(text: d.weeksAvailableCount.toString());
    _pptPctCtrl = TextEditingController(text: d.facultiesPptPct.toString());
    _lessonPlanPctCtrl =
        TextEditingController(text: d.lessonPlanPreparedPct.toString());
    _labPlanPctCtrl =
        TextEditingController(text: d.labPlanPreparedPct.toString());
    _lecturesPctCtrl =
        TextEditingController(text: d.lecturesCoveredPct.toString());
    _refresherCourses = d.refresherCourses;
    _feedbackPctCtrl =
        TextEditingController(text: d.studentFeedbackPct.toString());
    _subjects = List.from(d.subjects);
  }

  @override
  void dispose() {
    _totalWeeksCtrl.dispose();
    _weeksAvailableDateCtrl.dispose();
    _weeksAvailableCountCtrl.dispose();
    _pptPctCtrl.dispose();
    _lessonPlanPctCtrl.dispose();
    _labPlanPctCtrl.dispose();
    _lecturesPctCtrl.dispose();
    _feedbackPctCtrl.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final sections = widget.appState.cmSections;
    widget.appState.updateCmSections(CmFullReportSections(
      admission: sections.admission,
      facultyStrength: sections.facultyStrength,
      facultyProfile: sections.facultyProfile,
      laboratory: sections.laboratory,
      curriculum: CurriculumSectionData(
        totalWeeksScheme: int.tryParse(_totalWeeksCtrl.text.trim()) ?? 15,
        weeksAvailableUptoDate: _weeksAvailableDateCtrl.text.trim(),
        weeksAvailableCount:
            int.tryParse(_weeksAvailableCountCtrl.text.trim()) ?? 11,
        facultiesPptPct: int.tryParse(_pptPctCtrl.text.trim()) ?? 100,
        lessonPlanPreparedPct:
            int.tryParse(_lessonPlanPctCtrl.text.trim()) ?? 100,
        labPlanPreparedPct: int.tryParse(_labPlanPctCtrl.text.trim()) ?? 100,
        lecturesCoveredPct: int.tryParse(_lecturesPctCtrl.text.trim()) ?? 100,
        refresherCourses: _refresherCourses,
        studentFeedbackPct:
            int.tryParse(_feedbackPctCtrl.text.trim()) ?? 100,
        subjects: _subjects,
      ),
      studentAttendance: sections.studentAttendance,
      resultAnalysis: sections.resultAnalysis,
      resources: sections.resources,
      coCurricular: sections.coCurricular,
      anyOther: sections.anyOther,
    ));
    AppSnackBar.showSuccess(
        context, 'Screen 6: Curriculum Information saved successfully.');
  }

  void _resetDefaults() {
    final d = CurriculumSectionData.defaultSample();
    setState(() {
      _totalWeeksCtrl.text = d.totalWeeksScheme.toString();
      _weeksAvailableDateCtrl.text = d.weeksAvailableUptoDate;
      _weeksAvailableCountCtrl.text = d.weeksAvailableCount.toString();
      _pptPctCtrl.text = d.facultiesPptPct.toString();
      _lessonPlanPctCtrl.text = d.lessonPlanPreparedPct.toString();
      _labPlanPctCtrl.text = d.labPlanPreparedPct.toString();
      _lecturesPctCtrl.text = d.lecturesCoveredPct.toString();
      _refresherCourses = d.refresherCourses;
      _feedbackPctCtrl.text = d.studentFeedbackPct.toString();
      _subjects = List.from(d.subjects);
    });
    _saveChanges();
  }

  InputDecoration _inputDeco() {
    final p = Pal.of(context);
    return InputDecoration(
      filled: true,
      fillColor: p.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title Panel
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Dept Curriculum Information',
                    style: AppType.display(p.ink, size: 22, height: 1.2),
                  ),
                  Text(
                    '• Screen 6 / 11 (Computer Technology)',
                    style: TextStyle(fontSize: 12.5, color: p.inkMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Lesson plans, syllabus coverage percentages, and continuous term work/practical assessment.',
                style: TextStyle(fontSize: 13, color: p.inkSoft),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Key Curriculum Metrics Card
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Curriculum Delivery & Teaching Compliance',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: p.brand),
              ),
              const SizedBox(height: 14),
              _buildMetricRow('Number of Weeks as per T-E Schemes *', _totalWeeksCtrl, p),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Number of weeks available up to date of monitoring *',
                        style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: p.ink),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _weeksAvailableCountCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _inputDeco(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _weeksAvailableDateCtrl,
                        readOnly: true,
                        onTap: () => showCmDatePicker(
                          context: context,
                          controller: _weeksAvailableDateCtrl,
                        ),
                        decoration: InputDecoration(
                          hintText: '30/09/2026',
                          filled: true,
                          fillColor: p.surfaceAlt,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6)),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_today,
                                size: 18, color: p.brand),
                            tooltip: 'Select date from calendar',
                            onPressed: () => showCmDatePicker(
                              context: context,
                              controller: _weeksAvailableDateCtrl,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildMetricRow('Faculties using PowerPoint / Flash Presentations (%) *', _pptPctCtrl, p),
              _buildMetricRow('Theory subject lesson plan prepared & followed (%) *', _lessonPlanPctCtrl, p),
              _buildMetricRow('Lab plan prepared & followed till date of monitoring (%) *', _labPlanPctCtrl, p),
              _buildMetricRow('Number of Lecture/Practicals covered as per norms (%) *', _lecturesPctCtrl, p),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Conduct of refresher courses for direct 2nd year students *',
                        style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: p.ink),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _refresherCourses,
                        decoration: _inputDeco(),
                        items: const [
                          DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                          DropdownMenuItem(value: 'No', child: Text('No')),
                        ],
                        onChanged: (v) => setState(() => _refresherCourses = v!),
                      ),
                    ),
                  ],
                ),
              ),
              _buildMetricRow('% Student feedback about satisfactory coverage of curriculum *', _feedbackPctCtrl, p),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Subject Breakdown Table Card
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '2. Subject-wise Curriculum Coverage Breakdown (${_subjects.length} Subjects Total)',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: p.brand),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Search and Semester Filters
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Filter by code or name...',
                        prefixIcon: const Icon(Icons.search, size: 16),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        filled: true,
                        fillColor: p.surfaceAlt,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onChanged: (v) => setState(() => _searchFilter = v.trim().toLowerCase()),
                    ),
                  ),
                  ...[null, 1, 2, 3, 4, 5, 6].map((sem) {
                    final isSel = _selectedSemFilter == sem;
                    return ChoiceChip(
                      label: Text(sem == null ? 'All Sems (132)' : 'Sem $sem'),
                      selected: isSel,
                      onSelected: (_) => setState(() => _selectedSemFilter = sem),
                      selectedColor: p.brand,
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSel ? p.onBrand : p.ink,
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final filtered = _subjects.where((s) {
                    if (_selectedSemFilter != null && s.semester != _selectedSemFilter) return false;
                    if (_searchFilter.isNotEmpty) {
                      final matchCode = s.subjectCode.toLowerCase().contains(_searchFilter);
                      final matchName = s.subjectName.toLowerCase().contains(_searchFilter);
                      if (!matchCode && !matchName) return false;
                    }
                    return true;
                  }).toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(p.surfaceAlt),
                        columns: const [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Sem')),
                          DataColumn(label: Text('Code')),
                          DataColumn(label: Text('Subject Name')),
                          DataColumn(label: Text('Periods Avail')),
                          DataColumn(label: Text('Periods Engaged')),
                          DataColumn(label: Text('% Covered')),
                          DataColumn(label: Text('TW')),
                          DataColumn(label: Text('PR')),
                        ],
                        rows: List.generate(filtered.length, (idx) {
                          final s = filtered[idx];
                          final realIdx = _subjects.indexWhere((item) => item.srNo == s.srNo);

                          return DataRow(
                            cells: [
                              DataCell(Text(s.srNo.toString())),
                              DataCell(Text(s.semester.toString())),
                              DataCell(Text(s.subjectCode, style: const TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(SizedBox(
                                width: 220,
                                child: Text(s.subjectName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
                              )),
                              DataCell(
                                SizedBox(
                                  width: 65,
                                  child: TextFormField(
                                    key: ValueKey('c_avail_${s.srNo}'),
                                    initialValue: s.periodsAvailable.toString(),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                      filled: true,
                                      fillColor: p.surfaceAlt,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                    ),
                                    onChanged: (val) {
                                      final pVal = int.tryParse(val) ?? 0;
                                      if (realIdx != -1) {
                                        _subjects[realIdx] = s.copyWith(periodsAvailable: pVal);
                                        _saveChanges();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 65,
                                  child: TextFormField(
                                    key: ValueKey('c_eng_${s.srNo}'),
                                    initialValue: s.periodsEngaged.toString(),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                      filled: true,
                                      fillColor: p.surfaceAlt,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                    ),
                                    onChanged: (val) {
                                      final pVal = int.tryParse(val) ?? 0;
                                      if (realIdx != -1) {
                                        _subjects[realIdx] = s.copyWith(periodsEngaged: pVal);
                                        _saveChanges();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 65,
                                  child: TextFormField(
                                    key: ValueKey('c_cov_${s.srNo}'),
                                    initialValue: s.percentCovered.toString(),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                      filled: true,
                                      fillColor: p.surfaceAlt,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                    ),
                                    onChanged: (val) {
                                      final pVal = int.tryParse(val) ?? 0;
                                      if (realIdx != -1) {
                                        _subjects[realIdx] = s.copyWith(percentCovered: pVal);
                                        _saveChanges();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width: 65,
                                  height: 36,
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: p.surfaceAlt,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: p.rule),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      key: ValueKey('c_tw_${s.srNo}'),
                                      value: s.continuousAssessmentTw.isEmpty
                                          ? 'N'
                                          : s.continuousAssessmentTw,
                                      isDense: true,
                                      iconSize: 18,
                                      style: TextStyle(
                                          fontSize: 12.5, color: p.ink),
                                      items: const [
                                        DropdownMenuItem(
                                            value: 'Y', child: Text('Y')),
                                        DropdownMenuItem(
                                            value: 'N', child: Text('N')),
                                      ],
                                      onChanged: (v) {
                                        if (v != null && realIdx != -1) {
                                          _subjects[realIdx] = s.copyWith(
                                              continuousAssessmentTw: v);
                                          _saveChanges();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width: 65,
                                  height: 36,
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: p.surfaceAlt,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: p.rule),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      key: ValueKey('c_pr_${s.srNo}'),
                                      value: s.continuousAssessmentPr.isEmpty
                                          ? 'N'
                                          : s.continuousAssessmentPr,
                                      isDense: true,
                                      iconSize: 18,
                                      style: TextStyle(
                                          fontSize: 12.5, color: p.ink),
                                      items: const [
                                        DropdownMenuItem(
                                            value: 'Y', child: Text('Y')),
                                        DropdownMenuItem(
                                            value: 'N', child: Text('N')),
                                      ],
                                      onChanged: (v) {
                                        if (v != null && realIdx != -1) {
                                          _subjects[realIdx] = s.copyWith(
                                              continuousAssessmentPr: v);
                                          _saveChanges();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Action Bar
        Wrap(
          alignment: WrapAlignment.end,
          spacing: 12,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: _resetDefaults,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reset Defaults'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: p.danger,
                foregroundColor: Colors.white,
              ),
              onPressed: widget.onExportPdf,
              icon: const Icon(Icons.picture_as_pdf, size: 18),
              label: const Text('Export CM_Report.pdf'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: p.brand,
                foregroundColor: p.onBrand,
              ),
              onPressed: _saveChanges,
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Save Changes'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, TextEditingController ctrl, Pal p) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 13.5, fontWeight: FontWeight.w600, color: p.ink),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              decoration: _inputDeco(),
            ),
          ),
        ],
      ),
    );
  }
}
