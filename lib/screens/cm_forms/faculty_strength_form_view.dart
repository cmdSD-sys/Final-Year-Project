import 'package:flutter/material.dart';
import '../../models/cm_sections_model.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_snack_bar.dart';
import '../../widgets/portal_ui.dart';

class FacultyStrengthFormView extends StatefulWidget {
  final AppState appState;
  final VoidCallback onExportPdf;

  const FacultyStrengthFormView({
    super.key,
    required this.appState,
    required this.onExportPdf,
  });

  @override
  State<FacultyStrengthFormView> createState() =>
      _FacultyStrengthFormViewState();
}

class _FacultyStrengthFormViewState extends State<FacultyStrengthFormView> {
  late TextEditingController _hodReqCtrl;
  late TextEditingController _lecDesCtrl;
  late TextEditingController _lecEssCtrl;
  late String _hodAvailability;
  late TextEditingController _regCtrl;
  late TextEditingController _adhocCtrl;
  late TextEditingController _contractCtrl;
  late TextEditingController _visitingCtrl;
  late TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    _loadFromState();
  }

  void _loadFromState() {
    final d = widget.appState.cmSections.facultyStrength;
    _hodReqCtrl = TextEditingController(text: d.hodRequired.toString());
    _lecDesCtrl = TextEditingController(text: d.lecturerDesirable.toString());
    _lecEssCtrl = TextEditingController(text: d.lecturerEssential.toString());
    _hodAvailability = d.hodAvailability;
    _regCtrl = TextEditingController(text: d.lecturerRegular.toString());
    _adhocCtrl = TextEditingController(text: d.lecturerAdhoc.toString());
    _contractCtrl = TextEditingController(text: d.lecturerContract.toString());
    _visitingCtrl = TextEditingController(text: d.lecturerVisiting.toString());
    _notesCtrl = TextEditingController(text: d.notes);
  }

  @override
  void dispose() {
    _hodReqCtrl.dispose();
    _lecDesCtrl.dispose();
    _lecEssCtrl.dispose();
    _regCtrl.dispose();
    _adhocCtrl.dispose();
    _contractCtrl.dispose();
    _visitingCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  FacultyStrengthSectionData _buildModel() {
    return FacultyStrengthSectionData(
      hodRequired: int.tryParse(_hodReqCtrl.text.trim()) ?? 1,
      lecturerDesirable: int.tryParse(_lecDesCtrl.text.trim()) ?? 16,
      lecturerEssential: int.tryParse(_lecEssCtrl.text.trim()) ?? 14,
      hodAvailability: _hodAvailability,
      lecturerRegular: int.tryParse(_regCtrl.text.trim()) ?? 8,
      lecturerAdhoc: int.tryParse(_adhocCtrl.text.trim()) ?? 13,
      lecturerContract: int.tryParse(_contractCtrl.text.trim()) ?? 0,
      lecturerVisiting: int.tryParse(_visitingCtrl.text.trim()) ?? 0,
      notes: _notesCtrl.text.trim(),
    );
  }

  void _saveChanges() {
    final updated = _buildModel();
    final sections = widget.appState.cmSections;
    widget.appState.updateCmSections(CmFullReportSections(
      admission: sections.admission,
      facultyStrength: updated,
      facultyProfile: sections.facultyProfile,
      laboratory: sections.laboratory,
      curriculum: sections.curriculum,
      studentAttendance: sections.studentAttendance,
      resultAnalysis: sections.resultAnalysis,
      resources: sections.resources,
      coCurricular: sections.coCurricular,
      anyOther: sections.anyOther,
    ));
    AppSnackBar.showSuccess(
        context, 'Screen 3: Faculty Strength saved successfully.');
  }

  void _resetDefaults() {
    final d = FacultyStrengthSectionData.defaultSample();
    setState(() {
      _hodReqCtrl.text = d.hodRequired.toString();
      _lecDesCtrl.text = d.lecturerDesirable.toString();
      _lecEssCtrl.text = d.lecturerEssential.toString();
      _hodAvailability = d.hodAvailability;
      _regCtrl.text = d.lecturerRegular.toString();
      _adhocCtrl.text = d.lecturerAdhoc.toString();
      _contractCtrl.text = d.lecturerContract.toString();
      _visitingCtrl.text = d.lecturerVisiting.toString();
      _notesCtrl.text = d.notes;
    });
    _saveChanges();
  }

  InputDecoration _inputDeco() {
    final p = Pal.of(context);
    return InputDecoration(
      filled: true,
      fillColor: p.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: p.rule),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: p.rule),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: p.brand, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);

    final totalFilled = (int.tryParse(_regCtrl.text) ?? 0) +
        (int.tryParse(_adhocCtrl.text) ?? 0) +
        (int.tryParse(_contractCtrl.text) ?? 0) +
        (int.tryParse(_visitingCtrl.text) ?? 0);

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
                    'Dept Faculty Strength',
                    style: AppType.display(p.ink, size: 22, height: 1.2),
                  ),
                  Text(
                    '• Screen 3 / 11 (Computer Technology)',
                    style: TextStyle(fontSize: 12.5, color: p.inkMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'AICTE/PCI and MSBTE Norms requirements and actual filled posts.',
                style: TextStyle(fontSize: 13, color: p.inkSoft),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Norms & Filled Posts Form Card
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Required as per Norms vs Filled Posts',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: p.brand),
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: Table(
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        border: TableBorder.all(color: p.rule, width: 1),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: p.surfaceAlt),
                            children: [
                              _headerCell('HOD Required', p),
                              _headerCell('Lecturer\n(Desirable)', p),
                              _headerCell('Lecturer\n(Essential)', p),
                              _headerCell('HOD\nAvailability', p),
                              _headerCell('Regular *', p),
                              _headerCell('Adhoc', p),
                              _headerCell('Contract', p),
                              _headerCell('Visiting', p),
                              _headerCell('Total Filled', p),
                            ],
                          ),
                          TableRow(
                            children: [
                              _cellField(_hodReqCtrl),
                              _cellField(_lecDesCtrl),
                              _cellField(_lecEssCtrl),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  initialValue: _hodAvailability,
                                  decoration: _inputDeco(),
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'Incharge',
                                        child: Text('Incharge')),
                                    DropdownMenuItem(
                                        value: 'Regular',
                                        child: Text('Regular')),
                                    DropdownMenuItem(
                                        value: 'Vacant',
                                        child: Text('Vacant')),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _hodAvailability = v!),
                                ),
                              ),
                              _cellField(_regCtrl),
                              _cellField(_adhocCtrl),
                              _cellField(_contractCtrl),
                              _cellField(_visitingCtrl),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  totalFilled.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: p.brand,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Notes / Observations:',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: p.ink),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesCtrl,
                maxLines: 2,
                decoration: _inputDeco(),
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

  Widget _headerCell(String label, Pal p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: p.ink,
        ),
      ),
    );
  }

  Widget _cellField(TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: SizedBox(
        width: 80,
        child: TextFormField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          decoration: _inputDeco(),
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }
}
