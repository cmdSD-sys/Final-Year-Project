import 'package:flutter/material.dart';
import '../../models/cm_sections_model.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_snack_bar.dart';
import '../../widgets/portal_ui.dart';
import 'date_picker_helper.dart';

class StudentAttendanceFormView extends StatefulWidget {
  final AppState appState;
  final VoidCallback onExportPdf;

  const StudentAttendanceFormView({
    super.key,
    required this.appState,
    required this.onExportPdf,
  });

  @override
  State<StudentAttendanceFormView> createState() =>
      _StudentAttendanceFormViewState();
}

class _StudentAttendanceFormViewState
    extends State<StudentAttendanceFormView> {
  late TextEditingController _dateCtrl;
  late List<AttendanceSubjectItem> _subjects;
  int? _selectedSemFilter;
  String _searchFilter = '';

  @override
  void initState() {
    super.initState();
    _loadFromState();
  }

  void _loadFromState() {
    final d = widget.appState.cmSections.studentAttendance;
    _dateCtrl = TextEditingController(text: d.monitoringDate);
    _subjects = List.from(d.subjects);
  }

  @override
  void dispose() {
    _dateCtrl.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final sections = widget.appState.cmSections;
    widget.appState.updateCmSections(CmFullReportSections(
      admission: sections.admission,
      facultyStrength: sections.facultyStrength,
      facultyProfile: sections.facultyProfile,
      laboratory: sections.laboratory,
      curriculum: sections.curriculum,
      studentAttendance: StudentAttendanceSectionData(
        monitoringDate: _dateCtrl.text.trim(),
        subjects: _subjects,
      ),
      resultAnalysis: sections.resultAnalysis,
      resources: sections.resources,
      coCurricular: sections.coCurricular,
      anyOther: sections.anyOther,
    ));
    AppSnackBar.showSuccess(
        context, 'Screen 7: Student Attendance saved successfully.');
  }

  void _resetDefaults() {
    final d = StudentAttendanceSectionData.defaultSample();
    setState(() {
      _dateCtrl.text = d.monitoringDate;
      _subjects = List.from(d.subjects);
    });
    _saveChanges();
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
                    'Dept Student Attendance',
                    style: AppType.display(p.ink, size: 22, height: 1.2),
                  ),
                  Text(
                    '• Screen 7 / 11 (Computer Technology)',
                    style: TextStyle(fontSize: 12.5, color: p.inkMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Subject-wise average theory and practical attendance percentages up to date of monitoring.',
                style: TextStyle(fontSize: 13, color: p.inkSoft),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Date Picker Banner
        PortalPanel(
          color: p.brandTint,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.event_note, color: p.brand, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Subject-wise average attendance up to date of monitoring:',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: p.ink,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 180,
                child: TextFormField(
                  controller: _dateCtrl,
                  readOnly: true,
                  onTap: () => showCmDatePicker(
                    context: context,
                    controller: _dateCtrl,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: p.surface,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today,
                          size: 17, color: p.brand),
                      tooltip: 'Choose date from calendar',
                      onPressed: () => showCmDatePicker(
                        context: context,
                        controller: _dateCtrl,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Attendance Table Card
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
                      '1. Subject-wise Average Attendance (%) - ${_subjects.length} Subjects Total',
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
                      constraints:
                          BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(p.surfaceAlt),
                        columns: const [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Sem')),
                          DataColumn(label: Text('Code')),
                          DataColumn(label: Text('Subject Name')),
                          DataColumn(label: Text('Avg Theory Attd % (Editable)')),
                          DataColumn(label: Text('Avg Practical Attd % (Editable)')),
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
                                width: 240,
                                child: Text(s.subjectName,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
                              )),
                              DataCell(
                                SizedBox(
                                  width: 110,
                                  child: TextFormField(
                                    key: ValueKey('att_th_${s.srNo}'),
                                    initialValue: s.avgTheoryAttendance,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'e.g. 86.99 / NA',
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      filled: true,
                                      fillColor: p.surfaceAlt,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                    onChanged: (val) {
                                      if (realIdx != -1) {
                                        _subjects[realIdx] = s.copyWith(avgTheoryAttendance: val.trim());
                                        _saveChanges();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 110,
                                  child: TextFormField(
                                    key: ValueKey('att_pr_${s.srNo}'),
                                    initialValue: s.avgPracticalAttendance,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'e.g. 85.22 / NA',
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      filled: true,
                                      fillColor: p.surfaceAlt,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                    onChanged: (val) {
                                      if (realIdx != -1) {
                                        _subjects[realIdx] = s.copyWith(avgPracticalAttendance: val.trim());
                                        _saveChanges();
                                      }
                                    },
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
}
