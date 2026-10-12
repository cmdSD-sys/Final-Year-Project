import 'package:flutter/material.dart';
import '../../models/cm_sections_model.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_snack_bar.dart';
import '../../widgets/portal_ui.dart';

class FacultyProfileFormView extends StatefulWidget {
  final AppState appState;
  final VoidCallback onExportPdf;

  const FacultyProfileFormView({
    super.key,
    required this.appState,
    required this.onExportPdf,
  });

  @override
  State<FacultyProfileFormView> createState() => _FacultyProfileFormViewState();
}

class _FacultyProfileFormViewState extends State<FacultyProfileFormView> {
  late List<FacultyMemberItem> _faculties;
  late List<SupportStaffItem> _supportStaff;

  @override
  void initState() {
    super.initState();
    _loadFromState();
  }

  void _loadFromState() {
    final d = widget.appState.cmSections.facultyProfile;
    _faculties = List.from(d.teachingFaculties);
    _supportStaff = List.from(d.supportStaff);
  }

  void _saveChanges() {
    final sections = widget.appState.cmSections;
    widget.appState.updateCmSections(CmFullReportSections(
      admission: sections.admission,
      facultyStrength: sections.facultyStrength,
      facultyProfile: FacultyProfileSectionData(
        teachingFaculties: _faculties,
        supportStaff: _supportStaff,
      ),
      laboratory: sections.laboratory,
      curriculum: sections.curriculum,
      studentAttendance: sections.studentAttendance,
      resultAnalysis: sections.resultAnalysis,
      resources: sections.resources,
      coCurricular: sections.coCurricular,
      anyOther: sections.anyOther,
    ));
    AppSnackBar.showSuccess(
        context, 'Screen 4: Faculty Profile saved successfully (${_faculties.length} faculties).');
  }

  void _resetDefaults() {
    final d = FacultyProfileSectionData.defaultSample();
    setState(() {
      _faculties = List.from(d.teachingFaculties);
      _supportStaff = List.from(d.supportStaff);
    });
    _saveChanges();
  }

  void _showAddFacultyDialog() {
    final nameCtrl = TextEditingController();
    final desigCtrl = TextEditingController(text: 'Lecturer');
    final qualCtrl = TextEditingController(text: 'BE ME');
    final expTeachCtrl = TextEditingController(text: '5');
    final expIndCtrl = TextEditingController(text: '0');
    final trainCtrl = TextEditingController(text: '2');
    final confCtrl = TextEditingController(text: '1');
    final papersCtrl = TextEditingController(text: '1');
    final resCtrl = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (ctx) {
        final p = Pal.of(context);
        return AlertDialog(
          backgroundColor: p.surface,
          title: Text('Add New Faculty Member',
              style: TextStyle(color: p.ink, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dialogField('Full Name', nameCtrl, p),
                  _dialogField('Designation', desigCtrl, p),
                  _dialogField('Qualification', qualCtrl, p),
                  Row(
                    children: [
                      Expanded(child: _dialogField('Teaching Exp', expTeachCtrl, p, isNum: true)),
                      const SizedBox(width: 10),
                      Expanded(child: _dialogField('Industry Exp', expIndCtrl, p, isNum: true)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _dialogField('Trainings', trainCtrl, p, isNum: true)),
                      const SizedBox(width: 10),
                      Expanded(child: _dialogField('Conf/Seminars', confCtrl, p, isNum: true)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _dialogField('Papers Published', papersCtrl, p, isNum: true)),
                      const SizedBox(width: 10),
                      Expanded(child: _dialogField('Research Proj', resCtrl, p, isNum: true)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: p.brand, foregroundColor: p.onBrand),
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                setState(() {
                  _faculties.add(FacultyMemberItem(
                    srNo: _faculties.length + 1,
                    name: name,
                    designation: desigCtrl.text.trim(),
                    qualification: qualCtrl.text.trim(),
                    expTeaching: int.tryParse(expTeachCtrl.text.trim()) ?? 0,
                    expIndustry: int.tryParse(expIndCtrl.text.trim()) ?? 0,
                    trainingsAttended: int.tryParse(trainCtrl.text.trim()) ?? 0,
                    confAttended: int.tryParse(confCtrl.text.trim()) ?? 0,
                    papersPublished: int.tryParse(papersCtrl.text.trim()) ?? 0,
                    researchProjects: int.tryParse(resCtrl.text.trim()) ?? 0,
                  ));
                });
                Navigator.pop(ctx);
                _saveChanges();
              },
              child: const Text('Add Faculty'),
            ),
          ],
        );
      },
    );
  }

  void _showAddSupportStaffDialog() {
    final nameCtrl = TextEditingController();
    final desigCtrl = TextEditingController(text: 'Technical Assistant');
    final qualCtrl = TextEditingController(text: 'DIPLOMA');

    showDialog(
      context: context,
      builder: (ctx) {
        final p = Pal.of(context);
        return AlertDialog(
          backgroundColor: p.surface,
          title: Text('Add Support Staff',
              style: TextStyle(color: p.ink, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogField('Staff Name', nameCtrl, p),
                _dialogField('Designation', desigCtrl, p),
                _dialogField('Qualification', qualCtrl, p),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: p.brand, foregroundColor: p.onBrand),
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                setState(() {
                  _supportStaff.add(SupportStaffItem(
                    srNo: _supportStaff.length + 1,
                    name: name,
                    designation: desigCtrl.text.trim(),
                    qualification: qualCtrl.text.trim(),
                  ));
                });
                Navigator.pop(ctx);
                _saveChanges();
              },
              child: const Text('Add Staff'),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogField(String label, TextEditingController ctrl, Pal p, {bool isNum = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: p.surfaceAlt,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
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
                    'Dept Faculty Profile',
                    style: AppType.display(p.ink, size: 22, height: 1.2),
                  ),
                  Text(
                    '• Screen 4 / 11 (Computer Technology)',
                    style: TextStyle(fontSize: 12.5, color: p.inkMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Complete listing of teaching faculties, qualifications, industrial/teaching experience, research, and technical support staff.',
                style: TextStyle(fontSize: 13, color: p.inkSoft),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 1. Teaching Faculty Table Card
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '1. Teaching Faculty (${_faculties.length} Members)',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: p.brand),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: p.brand,
                      foregroundColor: p.onBrand,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: _showAddFacultyDialog,
                    icon: const Icon(Icons.person_add, size: 16),
                    label: const Text('Add Faculty', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(p.surfaceAlt),
                        columns: const [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Faculty Name')),
                          DataColumn(label: Text('Desig')),
                          DataColumn(label: Text('Qual')),
                          DataColumn(label: Text('Teach Exp')),
                          DataColumn(label: Text('Ind Exp')),
                          DataColumn(label: Text('Trainings')),
                          DataColumn(label: Text('Conf/Sem')),
                          DataColumn(label: Text('Papers')),
                          DataColumn(label: Text('Res Proj')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: List.generate(_faculties.length, (idx) {
                          final f = _faculties[idx];
                          return DataRow(
                            cells: [
                              DataCell(Text(f.srNo.toString())),
                              DataCell(Text(f.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                              DataCell(Text(f.designation)),
                              DataCell(Text(f.qualification)),
                              DataCell(Text('${f.expTeaching} yr')),
                              DataCell(Text('${f.expIndustry} yr')),
                              DataCell(Text(f.trainingsAttended.toString())),
                              DataCell(Text(f.confAttended.toString())),
                              DataCell(Text(f.papersPublished.toString())),
                              DataCell(Text(f.researchProjects.toString())),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete_outline, size: 18, color: p.danger),
                                  tooltip: 'Remove',
                                  onPressed: () {
                                    setState(() => _faculties.removeAt(idx));
                                    _saveChanges();
                                  },
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

        const SizedBox(height: 16),

        // 2. Technical Support Staff Table Card
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '2. Support Staff Profile (${_supportStaff.length} Members)',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: p.brand),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: _showAddSupportStaffDialog,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Support Staff', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(p.surfaceAlt),
                        columns: const [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Staff Name')),
                          DataColumn(label: Text('Designation')),
                          DataColumn(label: Text('Qualification')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: List.generate(_supportStaff.length, (idx) {
                          final s = _supportStaff[idx];
                          return DataRow(
                            cells: [
                              DataCell(Text(s.srNo.toString())),
                              DataCell(Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                              DataCell(Text(s.designation)),
                              DataCell(Text(s.qualification)),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete_outline, size: 18, color: p.danger),
                                  tooltip: 'Remove',
                                  onPressed: () {
                                    setState(() => _supportStaff.removeAt(idx));
                                    _saveChanges();
                                  },
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
