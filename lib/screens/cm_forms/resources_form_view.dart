import 'package:flutter/material.dart';
import '../../models/cm_sections_model.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_snack_bar.dart';
import '../../widgets/portal_ui.dart';

class ResourcesFormView extends StatefulWidget {
  final AppState appState;
  final VoidCallback onExportPdf;

  const ResourcesFormView({
    super.key,
    required this.appState,
    required this.onExportPdf,
  });

  @override
  State<ResourcesFormView> createState() => _ResourcesFormViewState();
}

class _ResourcesFormViewState extends State<ResourcesFormView> {
  late TextEditingController _cdAvailCtrl;
  late TextEditingController _cdAddCtrl;
  late TextEditingController _pptAvailCtrl;
  late TextEditingController _pptAddCtrl;
  late TextEditingController _flashAvailCtrl;
  late TextEditingController _flashAddCtrl;
  late TextEditingController _lcdAvailCtrl;
  late TextEditingController _lcdAddCtrl;
  late TextEditingController _boardAvailCtrl;
  late TextEditingController _boardAddCtrl;
  late TextEditingController _vlcAvailCtrl;
  late TextEditingController _vlcAddCtrl;
  late TextEditingController _remarkCtrl;

  @override
  void initState() {
    super.initState();
    _loadFromState();
  }

  void _loadFromState() {
    final d = widget.appState.cmSections.resources;
    _cdAvailCtrl = TextEditingController(text: d.cdDvdAvailable.toString());
    _cdAddCtrl = TextEditingController(text: d.cdDvdAdded.toString());
    _pptAvailCtrl = TextEditingController(text: d.pptsAvailable.toString());
    _pptAddCtrl = TextEditingController(text: d.pptsAdded.toString());
    _flashAvailCtrl = TextEditingController(text: d.flashAvailable.toString());
    _flashAddCtrl = TextEditingController(text: d.flashAdded.toString());
    _lcdAvailCtrl = TextEditingController(text: d.lcdAvailable.toString());
    _lcdAddCtrl = TextEditingController(text: d.lcdAdded.toString());
    _boardAvailCtrl =
        TextEditingController(text: d.interactiveBoardAvailable.toString());
    _boardAddCtrl =
        TextEditingController(text: d.interactiveBoardAdded.toString());
    _vlcAvailCtrl = TextEditingController(text: d.vlcAvailable.toString());
    _vlcAddCtrl = TextEditingController(text: d.vlcAdded.toString());
    _remarkCtrl = TextEditingController(text: d.remark);
  }

  @override
  void dispose() {
    _cdAvailCtrl.dispose();
    _cdAddCtrl.dispose();
    _pptAvailCtrl.dispose();
    _pptAddCtrl.dispose();
    _flashAvailCtrl.dispose();
    _flashAddCtrl.dispose();
    _lcdAvailCtrl.dispose();
    _lcdAddCtrl.dispose();
    _boardAvailCtrl.dispose();
    _boardAddCtrl.dispose();
    _vlcAvailCtrl.dispose();
    _vlcAddCtrl.dispose();
    _remarkCtrl.dispose();
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
      resources: ResourcesSectionData(
        cdDvdAvailable: int.tryParse(_cdAvailCtrl.text.trim()) ?? 10,
        cdDvdAdded: int.tryParse(_cdAddCtrl.text.trim()) ?? 8,
        pptsAvailable: int.tryParse(_pptAvailCtrl.text.trim()) ?? 650,
        pptsAdded: int.tryParse(_pptAddCtrl.text.trim()) ?? 140,
        flashAvailable: int.tryParse(_flashAvailCtrl.text.trim()) ?? 5,
        flashAdded: int.tryParse(_flashAddCtrl.text.trim()) ?? 2,
        lcdAvailable: int.tryParse(_lcdAvailCtrl.text.trim()) ?? 7,
        lcdAdded: int.tryParse(_lcdAddCtrl.text.trim()) ?? 0,
        interactiveBoardAvailable:
            int.tryParse(_boardAvailCtrl.text.trim()) ?? 1,
        interactiveBoardAdded:
            int.tryParse(_boardAddCtrl.text.trim()) ?? 1,
        vlcAvailable: int.tryParse(_vlcAvailCtrl.text.trim()) ?? 0,
        vlcAdded: int.tryParse(_vlcAddCtrl.text.trim()) ?? 0,
        remark: _remarkCtrl.text.trim(),
      ),
      coCurricular: sections.coCurricular,
      anyOther: sections.anyOther,
    ));
    AppSnackBar.showSuccess(
        context, 'Screen 9: Learning Resources saved successfully.');
  }

  void _resetDefaults() {
    final d = ResourcesSectionData.defaultSample();
    setState(() {
      _cdAvailCtrl.text = d.cdDvdAvailable.toString();
      _cdAddCtrl.text = d.cdDvdAdded.toString();
      _pptAvailCtrl.text = d.pptsAvailable.toString();
      _pptAddCtrl.text = d.pptsAdded.toString();
      _flashAvailCtrl.text = d.flashAvailable.toString();
      _flashAddCtrl.text = d.flashAdded.toString();
      _lcdAvailCtrl.text = d.lcdAvailable.toString();
      _lcdAddCtrl.text = d.lcdAdded.toString();
      _boardAvailCtrl.text = d.interactiveBoardAvailable.toString();
      _boardAddCtrl.text = d.interactiveBoardAdded.toString();
      _vlcAvailCtrl.text = d.vlcAvailable.toString();
      _vlcAddCtrl.text = d.vlcAdded.toString();
      _remarkCtrl.text = d.remark;
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
                    'Dept Learning Resources',
                    style: AppType.display(p.ink, size: 22, height: 1.2),
                  ),
                  Text(
                    '• Screen 9 / 11 (Computer Technology)',
                    style: TextStyle(fontSize: 12.5, color: p.inkMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Digital learning resources, presentations, smart boards, projector inventory, and LMS access.',
                style: TextStyle(fontSize: 13, color: p.inkSoft),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Resources Table Card
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Types of Learning Resources / Material',
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
                      constraints:
                          BoxConstraints(minWidth: constraints.maxWidth),
                      child: Table(
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        border: TableBorder.all(color: p.rule, width: 1),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: p.surfaceAlt),
                            children: [
                              _headerCell('Sr.No', p),
                              _headerCell('Types of Learning Resources', p),
                              _headerCell('Nos. Available', p),
                              _headerCell('Nos. Added Current Yr', p),
                              _headerCell('Total', p),
                            ],
                          ),
                          _buildTableRow('1', 'CD/DVD', _cdAvailCtrl, _cdAddCtrl, p),
                          _buildTableRow('2', 'Powerpoint Presentations (PPTs)', _pptAvailCtrl, _pptAddCtrl, p),
                          _buildTableRow('3', 'Flash Presentations', _flashAvailCtrl, _flashAddCtrl, p),
                          _buildTableRow('4', 'LCD Projector', _lcdAvailCtrl, _lcdAddCtrl, p),
                          _buildTableRow('5', 'Interactive Board', _boardAvailCtrl, _boardAddCtrl, p),
                          _buildTableRow('6', 'Virtual Learning Center', _vlcAvailCtrl, _vlcAddCtrl, p),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Remark / Any Other Equipment:',
                style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: p.ink),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _remarkCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: p.surfaceAlt,
                  contentPadding: const EdgeInsets.all(12),
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

  Widget _headerCell(String label, Pal p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 12.5, fontWeight: FontWeight.bold, color: p.ink),
      ),
    );
  }

  TableRow _buildTableRow(String sr, String title,
      TextEditingController availCtrl, TextEditingController addCtrl, Pal p) {
    final avail = int.tryParse(availCtrl.text.trim()) ?? 0;
    final add = int.tryParse(addCtrl.text.trim()) ?? 0;
    final total = avail + add;

    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(sr, textAlign: TextAlign.center),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: SizedBox(
            width: 80,
            child: TextFormField(
              controller: availCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                filled: true,
                fillColor: p.surfaceAlt,
                contentPadding: const EdgeInsets.all(6),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6),
          child: SizedBox(
            width: 80,
            child: TextFormField(
              controller: addCtrl,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                filled: true,
                fillColor: p.surfaceAlt,
                contentPadding: const EdgeInsets.all(6),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            total.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13.5, color: p.brand),
          ),
        ),
      ],
    );
  }
}
