import 'package:flutter/material.dart';
import '../../models/cm_sections_model.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_snack_bar.dart';
import '../../widgets/portal_ui.dart';

class CoCurricularFormView extends StatefulWidget {
  final AppState appState;
  final VoidCallback onExportPdf;

  const CoCurricularFormView({
    super.key,
    required this.appState,
    required this.onExportPdf,
  });

  @override
  State<CoCurricularFormView> createState() => _CoCurricularFormViewState();
}

class _CoCurricularFormViewState extends State<CoCurricularFormView> {
  late List<CoCurricularActivityItem> _activities;
  late TextEditingController _demandedCtrl;
  late TextEditingController _allocatedCtrl;
  late TextEditingController _utilisedCtrl;

  @override
  void initState() {
    super.initState();
    _loadFromState();
  }

  void _loadFromState() {
    final d = widget.appState.cmSections.coCurricular;
    _activities = List.from(d.activities);
    _demandedCtrl = TextEditingController(text: d.budgetDemanded.toString());
    _allocatedCtrl = TextEditingController(text: d.budgetAllocated.toString());
    _utilisedCtrl = TextEditingController(text: d.budgetUtilised.toString());
  }

  @override
  void dispose() {
    _demandedCtrl.dispose();
    _allocatedCtrl.dispose();
    _utilisedCtrl.dispose();
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
      coCurricular: CoCurricularSectionData(
        activities: _activities,
        budgetDemanded: double.tryParse(_demandedCtrl.text) ?? 52.0,
        budgetAllocated: double.tryParse(_allocatedCtrl.text) ?? 52.0,
        budgetUtilised: double.tryParse(_utilisedCtrl.text) ?? 50.57,
      ),
      anyOther: sections.anyOther,
    ));
    AppSnackBar.showSuccess(
        context, 'Screen 10: Co-Curricular Activities saved successfully.');
  }

  void _resetDefaults() {
    final d = CoCurricularSectionData.defaultSample();
    setState(() {
      _activities = List.from(d.activities);
      _demandedCtrl.text = d.budgetDemanded.toString();
      _allocatedCtrl.text = d.budgetAllocated.toString();
      _utilisedCtrl.text = d.budgetUtilised.toString();
    });
    _saveChanges();
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);

    int totalPlanned = 0;
    int totalActual = 0;
    int totalBeneficiaries = 0;
    for (final a in _activities) {
      totalPlanned += a.numberPlanned;
      totalActual += a.actualArranged;
      totalBeneficiaries += a.numberOfBeneficiaries;
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
                    'Co-Curricular Activities',
                    style: AppType.display(p.ink, size: 22, height: 1.2),
                  ),
                  Text(
                    '• Screen 10 / 11 (Computer Technology)',
                    style: TextStyle(fontSize: 12.5, color: p.inkMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Industrial visits, guest expert lectures, student projects, FDP training deputations, and technical competitions.',
                style: TextStyle(fontSize: 13, color: p.inkSoft),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Activities Table Card
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Co-Curricular & Industry Collaboration Activities',
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
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(p.surfaceAlt),
                        columns: const [
                          DataColumn(label: Text('Sr.No')),
                          DataColumn(label: Text('Nature of Activity')),
                          DataColumn(label: Text('Planned')),
                          DataColumn(label: Text('Actual Arranged')),
                          DataColumn(label: Text('Deficiency')),
                          DataColumn(label: Text('Beneficiaries')),
                          DataColumn(label: Text('Remarks / Companies')),
                        ],
                        rows: [
                          ...List.generate(_activities.length, (idx) {
                            final act = _activities[idx];
                            return DataRow(
                              cells: [
                                DataCell(Text(act.srNo.toString())),
                                DataCell(
                                  SizedBox(
                                    width: 260,
                                    child: Text(
                                      act.natureOfActivity,
                                      style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 65,
                                    child: TextFormField(
                                      key: ValueKey('cocurr_plan_${act.srNo}'),
                                      initialValue: act.numberPlanned.toString(),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                        filled: true,
                                        fillColor: p.surfaceAlt,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                      ),
                                      onChanged: (val) {
                                        final p = int.tryParse(val) ?? 0;
                                        _activities[idx] = act.copyWith(numberPlanned: p);
                                        _saveChanges();
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 65,
                                    child: TextFormField(
                                      key: ValueKey('cocurr_act_${act.srNo}'),
                                      initialValue: act.actualArranged.toString(),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                        filled: true,
                                        fillColor: p.surfaceAlt,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                      ),
                                      onChanged: (val) {
                                        final a = int.tryParse(val) ?? 0;
                                        _activities[idx] = act.copyWith(actualArranged: a);
                                        _saveChanges();
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 55,
                                    child: TextFormField(
                                      key: ValueKey('cocurr_def_${act.srNo}'),
                                      initialValue: act.deficiency.toString(),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                        filled: true,
                                        fillColor: p.surfaceAlt,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                      ),
                                      onChanged: (val) {
                                        final d = int.tryParse(val) ?? 0;
                                        _activities[idx] = act.copyWith(deficiency: d);
                                        _saveChanges();
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 75,
                                    child: TextFormField(
                                      key: ValueKey('cocurr_ben_${act.srNo}'),
                                      initialValue: act.numberOfBeneficiaries.toString(),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                        filled: true,
                                        fillColor: p.surfaceAlt,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                      ),
                                      onChanged: (val) {
                                        final b = int.tryParse(val) ?? 0;
                                        _activities[idx] = act.copyWith(numberOfBeneficiaries: b);
                                        _saveChanges();
                                      },
                                    ),
                                  ),
                                ),
                                DataCell(
                                  SizedBox(
                                    width: 220,
                                    child: TextFormField(
                                      key: ValueKey('cocurr_rem_${act.srNo}'),
                                      initialValue: act.remarks,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                        filled: true,
                                        fillColor: p.surfaceAlt,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                      ),
                                      onChanged: (val) {
                                        _activities[idx] = act.copyWith(remarks: val.trim());
                                        _saveChanges();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          // Summary Row
                          DataRow(
                            color: WidgetStateProperty.all(p.brandTint),
                            cells: [
                              const DataCell(Text('')),
                              DataCell(Text('TOTAL ACTIVITIES (${_activities.length})',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: p.brand))),
                              DataCell(Text(totalPlanned.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: p.brand))),
                              DataCell(Text(totalActual.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: p.brand))),
                              const DataCell(Text('0',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(Text(totalBeneficiaries.toString(),
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

        // Budget Allocation & Utilisation Panel
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2. Department Budget Allocation & Utilisation (Previous Financial Year)',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: p.brand),
              ),
              const SizedBox(height: 6),
              Text(
                'Recurring, Non-recurring & Maintenance budget in ₹ Lakhs as reported in MSBTE Academic Monitoring.',
                style: TextStyle(fontSize: 12.5, color: p.inkSoft),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _demandedCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Budget Demanded (₹ Lakhs)',
                        filled: true,
                        fillColor: p.surfaceAlt,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onChanged: (_) => _saveChanges(),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _allocatedCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Budget Allocated (₹ Lakhs)',
                        filled: true,
                        fillColor: p.surfaceAlt,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onChanged: (_) => _saveChanges(),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _utilisedCtrl,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Budget Utilised (₹ Lakhs)',
                        filled: true,
                        fillColor: p.surfaceAlt,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onChanged: (_) => _saveChanges(),
                    ),
                  ),
                ],
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
