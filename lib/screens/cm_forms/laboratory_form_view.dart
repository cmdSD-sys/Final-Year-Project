import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/cm_sections_model.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_snack_bar.dart';
import '../../widgets/portal_ui.dart';

class LaboratoryFormView extends StatefulWidget {
  final AppState appState;
  final VoidCallback onExportPdf;

  const LaboratoryFormView({
    super.key,
    required this.appState,
    required this.onExportPdf,
  });

  @override
  State<LaboratoryFormView> createState() => _LaboratoryFormViewState();
}

class _LaboratoryFormViewState extends State<LaboratoryFormView> {
  late List<LaboratoryItem> _laboratories;
  late TextEditingController _equipAvailCtrl;
  late TextEditingController _labsReqCtrl;
  late TextEditingController _labsAvailCtrl;

  final NumberFormat _currencyFormat = NumberFormat('#,##,###');

  @override
  void initState() {
    super.initState();
    _loadFromState();
  }

  void _loadFromState() {
    final d = widget.appState.cmSections.laboratory;
    _laboratories = List.from(d.laboratories);
    _equipAvailCtrl = TextEditingController(
        text: d.equipmentAvailabilitySyllabusPct.toString());
    _labsReqCtrl =
        TextEditingController(text: d.labsRequiredNorms.toString());
    _labsAvailCtrl =
        TextEditingController(text: d.labsActuallyAvailable.toString());
  }

  @override
  void dispose() {
    _equipAvailCtrl.dispose();
    _labsReqCtrl.dispose();
    _labsAvailCtrl.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final sections = widget.appState.cmSections;
    widget.appState.updateCmSections(CmFullReportSections(
      admission: sections.admission,
      facultyStrength: sections.facultyStrength,
      facultyProfile: sections.facultyProfile,
      laboratory: LaboratorySectionData(
        laboratories: _laboratories,
        equipmentAvailabilitySyllabusPct:
            int.tryParse(_equipAvailCtrl.text.trim()) ?? 100,
        labsRequiredNorms: int.tryParse(_labsReqCtrl.text.trim()) ?? 6,
        labsActuallyAvailable:
            int.tryParse(_labsAvailCtrl.text.trim()) ?? 7,
      ),
      curriculum: sections.curriculum,
      studentAttendance: sections.studentAttendance,
      resultAnalysis: sections.resultAnalysis,
      resources: sections.resources,
      coCurricular: sections.coCurricular,
      anyOther: sections.anyOther,
    ));
    AppSnackBar.showSuccess(
        context, 'Screen 5: Laboratory details saved successfully.');
  }

  void _resetDefaults() {
    final d = LaboratorySectionData.defaultSample();
    setState(() {
      _laboratories = List.from(d.laboratories);
      _equipAvailCtrl.text = d.equipmentAvailabilitySyllabusPct.toString();
      _labsReqCtrl.text = d.labsRequiredNorms.toString();
      _labsAvailCtrl.text = d.labsActuallyAvailable.toString();
    });
    _saveChanges();
  }

  void _showAddLabDialog() {
    final nameCtrl = TextEditingController();
    final countCtrl = TextEditingController(text: '15');
    final costCtrl = TextEditingController(text: '1000000');

    showDialog(
      context: context,
      builder: (ctx) {
        final p = Pal.of(context);
        return AlertDialog(
          backgroundColor: p.surface,
          title: Text('Add New Laboratory',
              style: TextStyle(color: p.ink, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Laboratory Name',
                    filled: true,
                    fillColor: p.surfaceAlt,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: countCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'No. of Major Equipments',
                    filled: true,
                    fillColor: p.surfaceAlt,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: costCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total Cost of Equipments & Furniture (₹)',
                    filled: true,
                    fillColor: p.surfaceAlt,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: p.brand, foregroundColor: p.onBrand),
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                setState(() {
                  _laboratories.add(LaboratoryItem(
                    srNo: _laboratories.length + 1,
                    name: name.toUpperCase(),
                    majorEquipmentsCount:
                        int.tryParse(countCtrl.text.trim()) ?? 0,
                    totalCost: int.tryParse(costCtrl.text.trim()) ?? 0,
                  ));
                });
                Navigator.pop(ctx);
                _saveChanges();
              },
              child: const Text('Add Laboratory'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateCostDialog(int idx) {
    final lab = _laboratories[idx];
    final costCtrl = TextEditingController(text: lab.totalCost.toString());
    final equipCtrl =
        TextEditingController(text: lab.majorEquipmentsCount.toString());

    showDialog(
      context: context,
      builder: (ctx) {
        final p = Pal.of(context);
        return AlertDialog(
          backgroundColor: p.surface,
          title: Text('Update Cost: ${lab.name}',
              style: TextStyle(
                  color: p.ink, fontWeight: FontWeight.bold, fontSize: 16)),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: costCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total Cost of Equipments & Furniture (₹)',
                    filled: true,
                    fillColor: p.surfaceAlt,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: equipCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'No. of Major Equipments',
                    filled: true,
                    fillColor: p.surfaceAlt,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: p.brand, foregroundColor: p.onBrand),
              onPressed: () {
                final newCost =
                    int.tryParse(costCtrl.text.trim()) ?? lab.totalCost;
                final newEquip = int.tryParse(equipCtrl.text.trim()) ??
                    lab.majorEquipmentsCount;
                setState(() {
                  _laboratories[idx] = lab.copyWith(
                    totalCost: newCost,
                    majorEquipmentsCount: newEquip,
                  );
                });
                Navigator.pop(ctx);
                _saveChanges();
              },
              child: const Text('Save Cost'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);

    int totalEquipments = 0;
    int totalCost = 0;
    for (final l in _laboratories) {
      totalEquipments += l.majorEquipmentsCount;
      totalCost += l.totalCost;
    }

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
                    'Laboratory Information',
                    style: AppType.display(p.ink, size: 22, height: 1.2),
                  ),
                  Text(
                    '• Screen 5 / 11 (Computer Technology)',
                    style: TextStyle(fontSize: 12.5, color: p.inkMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Department laboratory equipment inventory, investment costs, and AICTE compliance status.',
                style: TextStyle(fontSize: 13, color: p.inkSoft),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Laboratories Table Card
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '1. Department Laboratories (${_laboratories.length} Labs)',
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    onPressed: _showAddLabDialog,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Laboratory',
                        style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(p.surfaceAlt),
                        columns: const [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Name of Laboratory')),
                          DataColumn(label: Text('Major Equipments')),
                          DataColumn(label: Text('Total Cost (₹)')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: [
                          ...List.generate(_laboratories.length, (idx) {
                            final lab = _laboratories[idx];
                            return DataRow(
                              cells: [
                                DataCell(Text(lab.srNo.toString())),
                                DataCell(Text(lab.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600))),
                                DataCell(
                                  SizedBox(
                                    width: 70,
                                    child: TextFormField(
                                      key: ValueKey('equip_${lab.srNo}_${lab.majorEquipmentsCount}'),
                                      initialValue: lab.majorEquipmentsCount.toString(),
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(fontSize: 13),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        filled: true,
                                        fillColor: p.surfaceAlt,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                      ),
                                      onChanged: (val) {
                                        final parsed = int.tryParse(val) ?? lab.majorEquipmentsCount;
                                        _laboratories[idx] = lab.copyWith(majorEquipmentsCount: parsed);
                                        _saveChanges();
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 150,
                                    child: TextFormField(
                                      key: ValueKey('cost_${lab.srNo}_${lab.totalCost}'),
                                      initialValue: lab.totalCost.toString(),
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      decoration: InputDecoration(
                                        prefixText: '₹ ',
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        filled: true,
                                        fillColor: p.surfaceAlt,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                      ),
                                      onChanged: (val) {
                                        final parsed = int.tryParse(val.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                                        setState(() {
                                          _laboratories[idx] = lab.copyWith(totalCost: parsed);
                                        });
                                        _saveChanges();
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      OutlinedButton.icon(
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                          foregroundColor: p.brand,
                                          side: BorderSide(color: p.brand.withValues(alpha: 0.4)),
                                        ),
                                        icon: const Icon(Icons.edit, size: 14),
                                        label: const Text('Update Cost', style: TextStyle(fontSize: 11)),
                                        onPressed: () => _showUpdateCostDialog(idx),
                                      ),
                                      const SizedBox(width: 4),
                                      IconButton(
                                        icon: Icon(Icons.delete_outline,
                                            size: 18, color: p.danger),
                                        tooltip: 'Delete Lab',
                                        onPressed: () {
                                          setState(
                                              () => _laboratories.removeAt(idx));
                                          _saveChanges();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                          // Summary row
                          DataRow(
                            color: WidgetStateProperty.all(p.brandTint),
                            cells: [
                              const DataCell(Text('')),
                              DataCell(Text('TOTAL (${_laboratories.length} Laboratories)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: p.brand))),
                              DataCell(Text(totalEquipments.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: p.brand))),
                              DataCell(Text('₹ ${_currencyFormat.format(totalCost)}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: p.brand))),
                              const DataCell(Text('')),
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

        // Compliance Metrics Card
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2. AICTE/PCI Compliance Metrics',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: p.brand),
              ),
              const SizedBox(height: 14),
              _buildRow(
                  'Availability of equipments for conduct of experiments/jobs as per MSBTE norms (% of syllabus) *',
                  _equipAvailCtrl,
                  p),
              _buildRow(
                  'Number of laboratories required as per AICTE/PCI norms *',
                  _labsReqCtrl,
                  p),
              _buildRow(
                  'Number of laboratories actually available at department *',
                  _labsAvailCtrl,
                  p),
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

  Widget _buildRow(String label, TextEditingController ctrl, Pal p) {
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
              decoration: InputDecoration(
                filled: true,
                fillColor: p.surfaceAlt,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
