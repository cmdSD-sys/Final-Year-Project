import 'package:flutter/material.dart';
import '../../models/cm_sections_model.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_snack_bar.dart';
import '../../widgets/portal_ui.dart';

class AnyOtherFormView extends StatefulWidget {
  final AppState appState;
  final VoidCallback onExportPdf;

  const AnyOtherFormView({
    super.key,
    required this.appState,
    required this.onExportPdf,
  });

  @override
  State<AnyOtherFormView> createState() => _AnyOtherFormViewState();
}

class _AnyOtherFormViewState extends State<AnyOtherFormView> {
  late String _qualityOfTestPapers;
  late String _ciaanRead;
  late String _curriculumWellInterpreted;
  late String _ciaanFormatsUsed;
  late String _ciaanRecordsMaintained;
  late TextEditingController _otherDetailsCtrl;

  @override
  void initState() {
    super.initState();
    _loadFromState();
  }

  void _loadFromState() {
    final d = widget.appState.cmSections.anyOther;
    _qualityOfTestPapers = d.qualityOfTestPapers;
    _ciaanRead = d.ciaanRead;
    _curriculumWellInterpreted = d.curriculumWellInterpreted;
    _ciaanFormatsUsed = d.ciaanFormatsUsed;
    _ciaanRecordsMaintained = d.ciaanRecordsMaintained;
    _otherDetailsCtrl = TextEditingController(text: d.otherDetails);
  }

  @override
  void dispose() {
    _otherDetailsCtrl.dispose();
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
      studentAttendance: sections.studentAttendance,
      resultAnalysis: sections.resultAnalysis,
      resources: sections.resources,
      coCurricular: sections.coCurricular,
      anyOther: AnyOtherSectionData(
        qualityOfTestPapers: _qualityOfTestPapers,
        ciaanRead: _ciaanRead,
        curriculumWellInterpreted: _curriculumWellInterpreted,
        ciaanFormatsUsed: _ciaanFormatsUsed,
        ciaanRecordsMaintained: _ciaanRecordsMaintained,
        otherDetails: _otherDetailsCtrl.text.trim(),
      ),
    ));
    AppSnackBar.showSuccess(
        context, 'Screen 11: Any Other Information saved successfully.');
  }

  void _resetDefaults() {
    final d = AnyOtherSectionData.defaultSample();
    setState(() {
      _qualityOfTestPapers = d.qualityOfTestPapers;
      _ciaanRead = d.ciaanRead;
      _curriculumWellInterpreted = d.curriculumWellInterpreted;
      _ciaanFormatsUsed = d.ciaanFormatsUsed;
      _ciaanRecordsMaintained = d.ciaanRecordsMaintained;
      _otherDetailsCtrl.text = d.otherDetails;
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
                    'Any Other Information',
                    style: AppType.display(p.ink, size: 22, height: 1.2),
                  ),
                  Text(
                    '• Screen 11 / 11 (Computer Technology)',
                    style: TextStyle(fontSize: 12.5, color: p.inkMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'CIAAN compliance checklist, test paper quality evaluation, and special departmental achievements.',
                style: TextStyle(fontSize: 13, color: p.inkSoft),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 1. CIAAN Checklist Card
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Internal Assessment & CIAAN Quality Checks',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: p.brand),
              ),
              const SizedBox(height: 14),
              _buildDropdownRow(
                'Quality of Test Papers *',
                _qualityOfTestPapers,
                const [
                  DropdownMenuItem(
                      value: 'Appropriate coverage',
                      child: Text('Appropriate coverage')),
                  DropdownMenuItem(
                      value: 'Satisfactory', child: Text('Satisfactory')),
                  DropdownMenuItem(
                      value: 'Needs Improvement',
                      child: Text('Needs Improvement')),
                ],
                (v) => setState(() => _qualityOfTestPapers = v),
              ),
              _buildYesNoRow('CIAAN read *', _ciaanRead,
                  (v) => setState(() => _ciaanRead = v)),
              _buildYesNoRow(
                  'Curriculum component well interpreted *',
                  _curriculumWellInterpreted,
                  (v) => setState(() => _curriculumWellInterpreted = v)),
              _buildYesNoRow(
                  'CIAAN read & formats used *',
                  _ciaanFormatsUsed,
                  (v) => setState(() => _ciaanFormatsUsed = v)),
              _buildYesNoRow(
                  'CIAAN records maintained *',
                  _ciaanRecordsMaintained,
                  (v) => setState(() => _ciaanRecordsMaintained = v)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 2. Department Initiatives Card
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2. Special Initiatives, Student Chapters & Department Activities',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: p.brand),
              ),
              const SizedBox(height: 6),
              Text(
                'Provide details of student chapters (CSI, ISTE), faculty achievements, external monitoring duties, industry MOUs, and other institutional contributions:',
                style: TextStyle(fontSize: 13, color: p.inkSoft),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _otherDetailsCtrl,
                maxLines: 12,
                style: const TextStyle(fontSize: 13.5, height: 1.45),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: p.surfaceAlt,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
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

  Widget _buildYesNoRow(
      String label, String value, ValueChanged<String> onChanged) {
    return _buildDropdownRow(
      label,
      value,
      const [
        DropdownMenuItem(value: 'Yes', child: Text('Yes')),
        DropdownMenuItem(value: 'No', child: Text('No')),
      ],
      onChanged,
    );
  }

  Widget _buildDropdownRow(
      String label,
      String value,
      List<DropdownMenuItem<String>> items,
      ValueChanged<String> onChanged) {
    final p = Pal.of(context);
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
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: value,
              decoration: _inputDeco(),
              items: items,
              onChanged: (v) => onChanged(v!),
            ),
          ),
        ],
      ),
    );
  }
}
