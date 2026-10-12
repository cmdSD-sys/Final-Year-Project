import 'package:flutter/material.dart';
import '../../models/cm_sections_model.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_snack_bar.dart';
import '../../widgets/portal_ui.dart';

class AdmissionFormView extends StatefulWidget {
  final AppState appState;
  final VoidCallback onExportPdf;

  const AdmissionFormView({
    super.key,
    required this.appState,
    required this.onExportPdf,
  });

  @override
  State<AdmissionFormView> createState() => _AdmissionFormViewState();
}

class _AdmissionFormViewState extends State<AdmissionFormView> {
  late TextEditingController _iEnrolledCtrl;
  late TextEditingController _iReAdmittedCtrl;
  late TextEditingController _iiPassOutCtrl;
  late TextEditingController _iiDirectCtrl;
  late TextEditingController _iiChangeBranchCtrl;
  late TextEditingController _iiLastDcCtrl;
  late TextEditingController _iiiPassOutCtrl;
  late TextEditingController _iiiLastDcCtrl;
  late TextEditingController _pct35Ctrl;
  late TextEditingController _pct60Ctrl;
  late TextEditingController _pct80Ctrl;
  late TextEditingController _remarkCtrl;

  @override
  void initState() {
    super.initState();
    _loadFromState();
  }

  void _loadFromState() {
    final d = widget.appState.cmSections.admission;
    _iEnrolledCtrl = TextEditingController(text: d.iYearEnrolled.toString());
    _iReAdmittedCtrl = TextEditingController(text: d.iYearReAdmitted.toString());
    _iiPassOutCtrl = TextEditingController(text: d.iiYearPassOut.toString());
    _iiDirectCtrl = TextEditingController(text: d.iiYearDirect.toString());
    _iiChangeBranchCtrl =
        TextEditingController(text: d.iiYearChangeBranch.toString());
    _iiLastDcCtrl = TextEditingController(text: d.iiYearLastYearDc.toString());
    _iiiPassOutCtrl = TextEditingController(text: d.iiiYearPassOut.toString());
    _iiiLastDcCtrl =
        TextEditingController(text: d.iiiYearLastYearDc.toString());
    _pct35Ctrl = TextEditingController(text: d.pct35to59.toString());
    _pct60Ctrl = TextEditingController(text: d.pct60to79.toString());
    _pct80Ctrl = TextEditingController(text: d.pct80plus.toString());
    _remarkCtrl = TextEditingController(text: d.remark);
  }

  @override
  void dispose() {
    _iEnrolledCtrl.dispose();
    _iReAdmittedCtrl.dispose();
    _iiPassOutCtrl.dispose();
    _iiDirectCtrl.dispose();
    _iiChangeBranchCtrl.dispose();
    _iiLastDcCtrl.dispose();
    _iiiPassOutCtrl.dispose();
    _iiiLastDcCtrl.dispose();
    _pct35Ctrl.dispose();
    _pct60Ctrl.dispose();
    _pct80Ctrl.dispose();
    _remarkCtrl.dispose();
    super.dispose();
  }

  AdmissionSectionData _buildModel() {
    return AdmissionSectionData(
      iYearEnrolled: int.tryParse(_iEnrolledCtrl.text.trim()) ?? 0,
      iYearReAdmitted: int.tryParse(_iReAdmittedCtrl.text.trim()) ?? 0,
      iiYearPassOut: int.tryParse(_iiPassOutCtrl.text.trim()) ?? 0,
      iiYearDirect: int.tryParse(_iiDirectCtrl.text.trim()) ?? 0,
      iiYearChangeBranch: int.tryParse(_iiChangeBranchCtrl.text.trim()) ?? 0,
      iiYearLastYearDc: int.tryParse(_iiLastDcCtrl.text.trim()) ?? 0,
      iiiYearPassOut: int.tryParse(_iiiPassOutCtrl.text.trim()) ?? 0,
      iiiYearLastYearDc: int.tryParse(_iiiLastDcCtrl.text.trim()) ?? 0,
      pct35to59: int.tryParse(_pct35Ctrl.text.trim()) ?? 0,
      pct60to79: int.tryParse(_pct60Ctrl.text.trim()) ?? 0,
      pct80plus: int.tryParse(_pct80Ctrl.text.trim()) ?? 0,
      remark: _remarkCtrl.text.trim(),
    );
  }

  void _saveChanges() {
    final updated = _buildModel();
    final sections = widget.appState.cmSections;
    widget.appState.updateCmSections(CmFullReportSections(
      admission: updated,
      facultyStrength: sections.facultyStrength,
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
        context, 'Screen 2: Admission details saved successfully.');
  }

  void _resetDefaults() {
    final d = AdmissionSectionData.defaultSample();
    setState(() {
      _iEnrolledCtrl.text = d.iYearEnrolled.toString();
      _iReAdmittedCtrl.text = d.iYearReAdmitted.toString();
      _iiPassOutCtrl.text = d.iiYearPassOut.toString();
      _iiDirectCtrl.text = d.iiYearDirect.toString();
      _iiChangeBranchCtrl.text = d.iiYearChangeBranch.toString();
      _iiLastDcCtrl.text = d.iiYearLastYearDc.toString();
      _iiiPassOutCtrl.text = d.iiiYearPassOut.toString();
      _iiiLastDcCtrl.text = d.iiiYearLastYearDc.toString();
      _pct35Ctrl.text = d.pct35to59.toString();
      _pct60Ctrl.text = d.pct60to79.toString();
      _pct80Ctrl.text = d.pct80plus.toString();
      _remarkCtrl.text = d.remark;
    });
    _saveChanges();
  }

  InputDecoration _inputDeco(String hint) {
    final p = Pal.of(context);
    return InputDecoration(
      hintText: hint,
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
                    'Dept Admission Status',
                    style: AppType.display(p.ink, size: 22, height: 1.2),
                  ),
                  Text(
                    '• Screen 2 / 11 (Computer Technology)',
                    style: TextStyle(fontSize: 12.5, color: p.inkMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Enter year-wise enrollment figures and qualifying examination percentage analysis.',
                style: TextStyle(fontSize: 13, color: p.inkSoft),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Table 1: Year-wise Status
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Year-wise Admission Breakdown',
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
                              _headerCell('I Year\nEnrolled', p),
                              _headerCell('I Year\nRe-admitted', p),
                              _headerCell('II Year\nI Yr Pass', p),
                              _headerCell('II Year\nDirect', p),
                              _headerCell('II Year\nChg Branch', p),
                              _headerCell('II Year\nLast Yr DC', p),
                              _headerCell('III Year\nII Yr Pass', p),
                              _headerCell('III Year\nLast Yr DC', p),
                            ],
                          ),
                          TableRow(
                            children: [
                              _inputCell(_iEnrolledCtrl),
                              _inputCell(_iReAdmittedCtrl),
                              _inputCell(_iiPassOutCtrl),
                              _inputCell(_iiDirectCtrl),
                              _inputCell(_iiChangeBranchCtrl),
                              _inputCell(_iiLastDcCtrl),
                              _inputCell(_iiiPassOutCtrl),
                              _inputCell(_iiiLastDcCtrl),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Section 2: Analysis of 1st Year Admission
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2. Analysis of 1st Year Admission (Qualifying Exam %)',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: p.brand),
              ),
              const SizedBox(height: 6),
              Text(
                'Number of students admitted to 1st year for 2026-27 at entry level having following percentage:',
                style: TextStyle(fontSize: 13, color: p.inkSoft),
              ),
              const SizedBox(height: 16),
              _buildFormRow('35% to 59.99% *', _pct35Ctrl, p),
              _buildFormRow('60% to 79.99% *', _pct60Ctrl, p),
              _buildFormRow('80% and Above *', _pct80Ctrl, p),
              _buildFormRow('Remark', _remarkCtrl, p, isNumeric: false),
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

  Widget _inputCell(TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: SizedBox(
        width: 80,
        child: TextFormField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          decoration: _inputDeco(''),
        ),
      ),
    );
  }

  Widget _buildFormRow(String label, TextEditingController ctrl, Pal p,
      {bool isNumeric = true}) {
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
            flex: 3,
            child: TextFormField(
              controller: ctrl,
              keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
              decoration: _inputDeco('Enter value'),
            ),
          ),
        ],
      ),
    );
  }
}
