import 'package:flutter/material.dart';
import '../../models/cm_sections_model.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_snack_bar.dart';
import '../../widgets/portal_ui.dart';

class ResultAnalysisFormView extends StatefulWidget {
  final AppState appState;
  final VoidCallback onExportPdf;

  const ResultAnalysisFormView({
    super.key,
    required this.appState,
    required this.onExportPdf,
  });

  @override
  State<ResultAnalysisFormView> createState() => _ResultAnalysisFormViewState();
}

class _SemResultRowControllers {
  final TextEditingController appearedCtrl;
  final TextEditingController clearPassedCtrl;
  final TextEditingController failedCtrl;
  final TextEditingController atktCtrl;
  final TextEditingController passingPctCtrl;

  _SemResultRowControllers({
    required this.appearedCtrl,
    required this.clearPassedCtrl,
    required this.failedCtrl,
    required this.atktCtrl,
    required this.passingPctCtrl,
  });

  void dispose() {
    appearedCtrl.dispose();
    clearPassedCtrl.dispose();
    failedCtrl.dispose();
    atktCtrl.dispose();
    passingPctCtrl.dispose();
  }
}

class _ResultAnalysisFormViewState extends State<ResultAnalysisFormView> {
  late List<SemesterResultItem> _results;
  late List<_SemResultRowControllers> _rowControllers;

  // Mentoring of Failed Students
  late String _extraClasses;
  late String _questionPapers;
  late String _personalAttention;
  late String _libraryFacility;

  // Retrospective & Final Year Performance
  late TextEditingController _retro1stCtrl;
  late TextEditingController _retro2ndCtrl;
  late TextEditingController _retroFinalCtrl;
  late TextEditingController _finalCountCtrl;
  late TextEditingController _avgResultCtrl;
  late TextEditingController _pctFirstDivCtrl;

  // Percentage of Students Admitted & Appeared
  late TextEditingController _enrolled1stCtrl;
  late TextEditingController _appeared1stCtrl;
  late TextEditingController _pct1stCtrl;
  late TextEditingController _enrolled2ndCtrl;
  late TextEditingController _appeared2ndCtrl;
  late TextEditingController _pct2ndCtrl;
  late TextEditingController _enrolled3rdCtrl;
  late TextEditingController _appeared3rdCtrl;
  late TextEditingController _pct3rdCtrl;
  late TextEditingController _avgPctAllCtrl;

  // Curriculum Implementation Aspects
  late String _attainmentTargetSet;
  late String _mappingCoPoDone;
  late String _attainmentCalculated;
  late String _attainmentAchieved;
  late String _actionTakenReportDone;

  // Result and Placements Analysis
  late TextEditingController _apiThirdYearCtrl;
  late TextEditingController _apiSecondYearCtrl;
  late TextEditingController _apiFirstYearCtrl;
  late TextEditingController _siWithoutBacklogsCtrl;
  late TextEditingController _siWithBacklogsCtrl;
  late TextEditingController _diffProgressiveAndEseCtrl;
  late TextEditingController _placementHigherStudiesIndexCtrl;

  @override
  void initState() {
    super.initState();
    _loadFromState();
  }

  void _loadFromState() {
    final d = widget.appState.cmSections.resultAnalysis;
    _results = List.from(d.semesterResults);
    _rowControllers = _results
        .map((r) => _SemResultRowControllers(
              appearedCtrl: TextEditingController(text: r.appeared.toString()),
              clearPassedCtrl:
                  TextEditingController(text: r.clearPassed.toString()),
              failedCtrl: TextEditingController(text: r.failed.toString()),
              atktCtrl: TextEditingController(text: r.atkt.toString()),
              passingPctCtrl:
                  TextEditingController(text: r.passingPct.toStringAsFixed(2)),
            ))
        .toList();

    _extraClasses = d.extraClassesConducted;
    _questionPapers = d.questionPapersSolved;
    _personalAttention = d.personalAttentionToAverage;
    _libraryFacility = d.libraryFacilityProvided;

    _retro1stCtrl =
        TextEditingController(text: d.retrospectiveStudents1stYr.toString());
    _retro2ndCtrl =
        TextEditingController(text: d.retrospectiveStudents2ndYr.toString());
    _retroFinalCtrl =
        TextEditingController(text: d.retrospectiveStudentsFinalYr.toString());
    _finalCountCtrl =
        TextEditingController(text: d.finalYearStudentsCount.toString());
    _avgResultCtrl =
        TextEditingController(text: d.averageResultLast3Years.toString());
    _pctFirstDivCtrl =
        TextEditingController(text: d.percentFirstDivision.toString());

    _enrolled1stCtrl =
        TextEditingController(text: d.enrolled1stYr.toString());
    _appeared1stCtrl =
        TextEditingController(text: d.appeared1stYr.toString());
    _pct1stCtrl =
        TextEditingController(text: d.pctAppeared1stYr.toString());
    _enrolled2ndCtrl =
        TextEditingController(text: d.enrolled2ndYr.toString());
    _appeared2ndCtrl =
        TextEditingController(text: d.appeared2ndYr.toString());
    _pct2ndCtrl =
        TextEditingController(text: d.pctAppeared2ndYr.toString());
    _enrolled3rdCtrl =
        TextEditingController(text: d.enrolled3rdYr.toString());
    _appeared3rdCtrl =
        TextEditingController(text: d.appeared3rdYr.toString());
    _pct3rdCtrl =
        TextEditingController(text: d.pctAppeared3rdYr.toString());
    _avgPctAllCtrl =
        TextEditingController(text: d.avgPctAppearedAllYr.toString());

    _attainmentTargetSet = d.attainmentTargetSet;
    _mappingCoPoDone = d.mappingCoPoDone;
    _attainmentCalculated = d.attainmentCalculated;
    _attainmentAchieved = d.attainmentAchieved;
    _actionTakenReportDone = d.actionTakenReportDone;

    _apiThirdYearCtrl = TextEditingController(text: d.apiThirdYear);
    _apiSecondYearCtrl = TextEditingController(text: d.apiSecondYear);
    _apiFirstYearCtrl = TextEditingController(text: d.apiFirstYear);
    _siWithoutBacklogsCtrl = TextEditingController(text: d.siWithoutBacklogs);
    _siWithBacklogsCtrl = TextEditingController(text: d.siWithBacklogs);
    _diffProgressiveAndEseCtrl =
        TextEditingController(text: d.diffProgressiveAndEse);
    _placementHigherStudiesIndexCtrl =
        TextEditingController(text: d.placementHigherStudiesIndex);
  }

  @override
  void dispose() {
    for (final rc in _rowControllers) {
      rc.dispose();
    }
    _retro1stCtrl.dispose();
    _retro2ndCtrl.dispose();
    _retroFinalCtrl.dispose();
    _finalCountCtrl.dispose();
    _avgResultCtrl.dispose();
    _pctFirstDivCtrl.dispose();

    _enrolled1stCtrl.dispose();
    _appeared1stCtrl.dispose();
    _pct1stCtrl.dispose();
    _enrolled2ndCtrl.dispose();
    _appeared2ndCtrl.dispose();
    _pct2ndCtrl.dispose();
    _enrolled3rdCtrl.dispose();
    _appeared3rdCtrl.dispose();
    _pct3rdCtrl.dispose();
    _avgPctAllCtrl.dispose();

    _apiThirdYearCtrl.dispose();
    _apiSecondYearCtrl.dispose();
    _apiFirstYearCtrl.dispose();
    _siWithoutBacklogsCtrl.dispose();
    _siWithBacklogsCtrl.dispose();
    _diffProgressiveAndEseCtrl.dispose();
    _placementHigherStudiesIndexCtrl.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedResults = <SemesterResultItem>[];
    for (int i = 0; i < _results.length; i++) {
      final old = _results[i];
      final row = _rowControllers[i];
      final app = int.tryParse(row.appearedCtrl.text.trim()) ?? old.appeared;
      final cp =
          int.tryParse(row.clearPassedCtrl.text.trim()) ?? old.clearPassed;
      final f = int.tryParse(row.failedCtrl.text.trim()) ?? old.failed;
      final a = int.tryParse(row.atktCtrl.text.trim()) ?? old.atkt;
      final pct =
          double.tryParse(row.passingPctCtrl.text.trim()) ?? old.passingPct;
      updatedResults.add(old.copyWith(
        appeared: app,
        clearPassed: cp,
        failed: f,
        atkt: a,
        passingPct: pct,
      ));
    }

    final sections = widget.appState.cmSections;
    widget.appState.updateCmSections(CmFullReportSections(
      admission: sections.admission,
      facultyStrength: sections.facultyStrength,
      facultyProfile: sections.facultyProfile,
      laboratory: sections.laboratory,
      curriculum: sections.curriculum,
      studentAttendance: sections.studentAttendance,
      resultAnalysis: ResultAnalysisSectionData(
        semesterResults: updatedResults,
        extraClassesConducted: _extraClasses,
        questionPapersSolved: _questionPapers,
        personalAttentionToAverage: _personalAttention,
        libraryFacilityProvided: _libraryFacility,
        retrospectiveStudents1stYr:
            int.tryParse(_retro1stCtrl.text.trim()) ?? 185,
        retrospectiveStudents2ndYr:
            int.tryParse(_retro2ndCtrl.text.trim()) ?? 174,
        retrospectiveStudentsFinalYr:
            int.tryParse(_retroFinalCtrl.text.trim()) ?? 171,
        finalYearStudentsCount:
            int.tryParse(_finalCountCtrl.text.trim()) ?? 204,
        averageResultLast3Years:
            int.tryParse(_avgResultCtrl.text.trim()) ?? 97,
        percentFirstDivision:
            int.tryParse(_pctFirstDivCtrl.text.trim()) ?? 99,
        enrolled1stYr: int.tryParse(_enrolled1stCtrl.text.trim()) ?? 199,
        appeared1stYr: int.tryParse(_appeared1stCtrl.text.trim()) ?? 194,
        pctAppeared1stYr: int.tryParse(_pct1stCtrl.text.trim()) ?? 97,
        enrolled2ndYr: int.tryParse(_enrolled2ndCtrl.text.trim()) ?? 227,
        appeared2ndYr: int.tryParse(_appeared2ndCtrl.text.trim()) ?? 225,
        pctAppeared2ndYr: int.tryParse(_pct2ndCtrl.text.trim()) ?? 99,
        enrolled3rdYr: int.tryParse(_enrolled3rdCtrl.text.trim()) ?? 205,
        appeared3rdYr: int.tryParse(_appeared3rdCtrl.text.trim()) ?? 204,
        pctAppeared3rdYr: int.tryParse(_pct3rdCtrl.text.trim()) ?? 100,
        avgPctAppearedAllYr: int.tryParse(_avgPctAllCtrl.text.trim()) ?? 99,
        attainmentTargetSet: _attainmentTargetSet,
        mappingCoPoDone: _mappingCoPoDone,
        attainmentCalculated: _attainmentCalculated,
        attainmentAchieved: _attainmentAchieved,
        actionTakenReportDone: _actionTakenReportDone,
        apiThirdYear: _apiThirdYearCtrl.text.trim(),
        apiSecondYear: _apiSecondYearCtrl.text.trim(),
        apiFirstYear: _apiFirstYearCtrl.text.trim(),
        siWithoutBacklogs: _siWithoutBacklogsCtrl.text.trim(),
        siWithBacklogs: _siWithBacklogsCtrl.text.trim(),
        diffProgressiveAndEse: _diffProgressiveAndEseCtrl.text.trim(),
        placementHigherStudiesIndex:
            _placementHigherStudiesIndexCtrl.text.trim(),
      ),
      resources: sections.resources,
      coCurricular: sections.coCurricular,
      anyOther: sections.anyOther,
    ));
    AppSnackBar.showSuccess(
        context, 'Screen 8: Result Analysis saved successfully.');
  }

  void _resetDefaults() {
    final d = ResultAnalysisSectionData.defaultSample();
    setState(() {
      for (final rc in _rowControllers) {
        rc.dispose();
      }
      _results = List.from(d.semesterResults);
      _rowControllers = _results
          .map((r) => _SemResultRowControllers(
                appearedCtrl:
                    TextEditingController(text: r.appeared.toString()),
                clearPassedCtrl:
                    TextEditingController(text: r.clearPassed.toString()),
                failedCtrl: TextEditingController(text: r.failed.toString()),
                atktCtrl: TextEditingController(text: r.atkt.toString()),
                passingPctCtrl: TextEditingController(
                    text: r.passingPct.toStringAsFixed(2)),
              ))
          .toList();

      _extraClasses = d.extraClassesConducted;
      _questionPapers = d.questionPapersSolved;
      _personalAttention = d.personalAttentionToAverage;
      _libraryFacility = d.libraryFacilityProvided;

      _retro1stCtrl.text = d.retrospectiveStudents1stYr.toString();
      _retro2ndCtrl.text = d.retrospectiveStudents2ndYr.toString();
      _retroFinalCtrl.text = d.retrospectiveStudentsFinalYr.toString();
      _finalCountCtrl.text = d.finalYearStudentsCount.toString();
      _avgResultCtrl.text = d.averageResultLast3Years.toString();
      _pctFirstDivCtrl.text = d.percentFirstDivision.toString();

      _enrolled1stCtrl.text = d.enrolled1stYr.toString();
      _appeared1stCtrl.text = d.appeared1stYr.toString();
      _pct1stCtrl.text = d.pctAppeared1stYr.toString();
      _enrolled2ndCtrl.text = d.enrolled2ndYr.toString();
      _appeared2ndCtrl.text = d.appeared2ndYr.toString();
      _pct2ndCtrl.text = d.pctAppeared2ndYr.toString();
      _enrolled3rdCtrl.text = d.enrolled3rdYr.toString();
      _appeared3rdCtrl.text = d.appeared3rdYr.toString();
      _pct3rdCtrl.text = d.pctAppeared3rdYr.toString();
      _avgPctAllCtrl.text = d.avgPctAppearedAllYr.toString();

      _attainmentTargetSet = d.attainmentTargetSet;
      _mappingCoPoDone = d.mappingCoPoDone;
      _attainmentCalculated = d.attainmentCalculated;
      _attainmentAchieved = d.attainmentAchieved;
      _actionTakenReportDone = d.actionTakenReportDone;

      _apiThirdYearCtrl.text = d.apiThirdYear;
      _apiSecondYearCtrl.text = d.apiSecondYear;
      _apiFirstYearCtrl.text = d.apiFirstYear;
      _siWithoutBacklogsCtrl.text = d.siWithoutBacklogs;
      _siWithBacklogsCtrl.text = d.siWithBacklogs;
      _diffProgressiveAndEseCtrl.text = d.diffProgressiveAndEse;
      _placementHigherStudiesIndexCtrl.text = d.placementHigherStudiesIndex;
    });
    _saveChanges();
  }

  InputDecoration _inputDeco() {
    final p = Pal.of(context);
    return InputDecoration(
      filled: true,
      fillColor: p.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
    );
  }

  InputDecoration _tableInputDeco() {
    final p = Pal.of(context);
    return InputDecoration(
      filled: true,
      fillColor: p.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      isDense: true,
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
                    'Result Analysis',
                    style: AppType.display(p.ink, size: 22, height: 1.2),
                  ),
                  Text(
                    '• Screen 8 / 11 (Computer Technology)',
                    style: TextStyle(fontSize: 12.5, color: p.inkMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Semester examination performance, mentoring of slow learners, curriculum implementation attainment, and academic performance indices.',
                style: TextStyle(fontSize: 13, color: p.inkSoft),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 1. Semester-wise Examination Results (Editable Data Table)
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
                      '1. Semester-wise Examination Results',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: p.brand,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: p.brandTint,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: p.brand.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      'All Cells Editable',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: p.brand,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Enter overall results of previous odd/even examination terms as per MSBTE monitoring instructions.',
                style: TextStyle(fontSize: 12.5, color: p.inkMuted),
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
                        headingRowColor:
                            WidgetStateProperty.all(p.surfaceAlt),
                        dataRowMinHeight: 52,
                        dataRowMaxHeight: 56,
                        columns: const [
                          DataColumn(label: Text('Sr.')),
                          DataColumn(label: Text('Sem / Year')),
                          DataColumn(label: Text('Appeared *')),
                          DataColumn(label: Text('Clear Passed *')),
                          DataColumn(label: Text('Failed *')),
                          DataColumn(label: Text('ATKT *')),
                          DataColumn(label: Text('% Passing *')),
                        ],
                        rows: List.generate(_results.length, (idx) {
                          final r = _results[idx];
                          final rc = _rowControllers[idx];
                          return DataRow(
                            cells: [
                              DataCell(Text('${idx + 1}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: p.inkMuted))),
                              DataCell(Text('Sem ${r.semYear}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))),
                              DataCell(
                                SizedBox(
                                  width: 85,
                                  child: TextFormField(
                                    controller: rc.appearedCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: _tableInputDeco(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 85,
                                  child: TextFormField(
                                    controller: rc.clearPassedCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: _tableInputDeco(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 85,
                                  child: TextFormField(
                                    controller: rc.failedCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: _tableInputDeco(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 85,
                                  child: TextFormField(
                                    controller: rc.atktCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: _tableInputDeco(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 95,
                                  child: TextFormField(
                                    controller: rc.passingPctCtrl,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: _tableInputDeco(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: p.brand,
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

        const SizedBox(height: 16),

        // 2. Mentoring of Failed Students
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2. Mentoring of Failed / Average Students',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: p.brand,
                ),
              ),
              const SizedBox(height: 14),
              _buildYesNoRow('1) Extra classes conducted *', _extraClasses,
                  (v) => setState(() => _extraClasses = v)),
              _buildYesNoRow('2) Question papers solved *', _questionPapers,
                  (v) => setState(() => _questionPapers = v)),
              _buildYesNoRow(
                  '3) Personal attention to average students *',
                  _personalAttention,
                  (v) => setState(() => _personalAttention = v)),
              _buildYesNoRow(
                  '4) Library facility provided *',
                  _libraryFacility,
                  (v) => setState(() => _libraryFacility = v)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 3. Retrospective & Performance of Final Year Students
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '3. Retrospective Performance of Final Year Students Passed in Current Year',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: p.brand,
                ),
              ),
              const SizedBox(height: 14),
              _buildFieldRow(
                  '1) Number of Students with same enrollment number (1st Year) *',
                  _retro1stCtrl),
              _buildFieldRow(
                  '2) Number of Students with same enrollment number (2nd Year) *',
                  _retro2ndCtrl),
              _buildFieldRow(
                  '3) Number of Students with same enrollment number (Final Year) *',
                  _retroFinalCtrl),
              Divider(height: 24, color: p.rule),
              Text(
                'Performance of Final Year Students',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: p.ink,
                ),
              ),
              const SizedBox(height: 12),
              _buildFieldRow(
                  'Total No. of Final Year Students *', _finalCountCtrl),
              _buildFieldRow(
                  'Average Result of Final Year (Last 3 years %) *',
                  _avgResultCtrl),
              _buildFieldRow(
                  '% of Final Year Students Passed in First Division *',
                  _pctFirstDivCtrl),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 4. Percentage of Students Admitted and Appeared for Examination
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '4. Percentage of Students Admitted and Appeared for the Examination',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: p.brand,
                ),
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
                        headingRowColor:
                            WidgetStateProperty.all(p.surfaceAlt),
                        columns: const [
                          DataColumn(label: Text('Year / Sem')),
                          DataColumn(label: Text('Students Enrolled *')),
                          DataColumn(label: Text('Appeared for Exam *')),
                          DataColumn(label: Text('% Appeared *')),
                          DataColumn(label: Text('Avg % (All Years)')),
                        ],
                        rows: [
                          DataRow(cells: [
                            const DataCell(Text(
                                '1st year (1st & 2nd Semester)',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(
                              SizedBox(
                                width: 90,
                                child: TextFormField(
                                  controller: _enrolled1stCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: _tableInputDeco(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 90,
                                child: TextFormField(
                                  controller: _appeared1stCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: _tableInputDeco(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 80,
                                child: TextFormField(
                                  controller: _pct1stCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: _tableInputDeco(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const DataCell(Text('-')),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text(
                                '2nd year (3rd & 4th Semester)',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(
                              SizedBox(
                                width: 90,
                                child: TextFormField(
                                  controller: _enrolled2ndCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: _tableInputDeco(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 90,
                                child: TextFormField(
                                  controller: _appeared2ndCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: _tableInputDeco(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 80,
                                child: TextFormField(
                                  controller: _pct2ndCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: _tableInputDeco(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const DataCell(Text('-')),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text(
                                '3rd year (5th & 6th Semester)',
                                style:
                                    TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(
                              SizedBox(
                                width: 90,
                                child: TextFormField(
                                  controller: _enrolled3rdCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: _tableInputDeco(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 90,
                                child: TextFormField(
                                  controller: _appeared3rdCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: _tableInputDeco(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 80,
                                child: TextFormField(
                                  controller: _pct3rdCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: _tableInputDeco(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            DataCell(
                              SizedBox(
                                width: 80,
                                child: TextFormField(
                                  controller: _avgPctAllCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: _tableInputDeco(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: p.brand,
                                  ),
                                ),
                              ),
                            ),
                          ]),
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

        // 5. Result and Placements: Curriculum Implementation Aspects
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '5. Result and Placements : Curriculum Implementation Aspects',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: p.brand,
                ),
              ),
              const SizedBox(height: 14),
              _buildYesNoRow(
                'Whether Attainment level target set by program *',
                _attainmentTargetSet,
                (v) => setState(() => _attainmentTargetSet = v),
              ),
              _buildYesNoRow(
                'Whether mapping of CO-PO with curricular and co-curricular activities done *',
                _mappingCoPoDone,
                (v) => setState(() => _mappingCoPoDone = v),
              ),
              _buildYesNoRow(
                'Whether attainment level calculated *',
                _attainmentCalculated,
                (v) => setState(() => _attainmentCalculated = v),
              ),
              _buildYesNoRow(
                'Whether attainment level achieved *',
                _attainmentAchieved,
                (v) => setState(() => _attainmentAchieved = v),
              ),
              _buildYesNoRow(
                'Whether action taken report w.r.t gap analysis done *',
                _actionTakenReportDone,
                (v) => setState(() => _actionTakenReportDone = v),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 6. Result and Placements Analysis (API and Success Indices)
        PortalPanel(
          color: p.surface,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '6. Result and Placements Analysis',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: p.brand,
                ),
              ),
              const SizedBox(height: 14),
              _buildFieldRow(
                '1) Academic Performance Index (API) of Third Year *',
                _apiThirdYearCtrl,
                subtext: 'API = 1.5 * ((Mean GPA) or (Mean marks/10)) * (successful / appeared)',
              ),
              _buildFieldRow(
                '2) Academic Performance Index (API) of Second Year *',
                _apiSecondYearCtrl,
                subtext: 'API = 2.0 * ((Mean GPA) or (Mean marks/10)) * (successful / appeared)',
              ),
              _buildFieldRow(
                '3) Academic Performance Index (API) of First Year *',
                _apiFirstYearCtrl,
                subtext: 'API = 2.5 * ((Mean GPA) or (Mean marks/10)) * (successful / appeared)',
              ),
              _buildFieldRow(
                '4) Success rate without backlogs (40 x Average SI) *',
                _siWithoutBacklogsCtrl,
                subtext: 'Success rate without backlogs in any year of study',
              ),
              _buildFieldRow(
                '5) Success rate with backlogs (20 x Average SI) *',
                _siWithBacklogsCtrl,
                subtext: 'General Success rate for past three batches',
              ),
              _buildFieldRow(
                '6) Difference between % progressive test & ESE exam *',
                _diffProgressiveAndEseCtrl,
                subtext: 'Only theory differences (NA if not applicable)',
              ),
              _buildFieldRow(
                '7) Placement and Higher Studies Index *',
                _placementHigherStudiesIndexCtrl,
                subtext: 'Index = 40 * (1.25X + Y) / N',
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
              initialValue: value,
              decoration: _inputDeco(),
              items: const [
                DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                DropdownMenuItem(value: 'No', child: Text('No')),
              ],
              onChanged: (v) => onChanged(v!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldRow(String label, TextEditingController ctrl,
      {String? subtext}) {
    final p = Pal.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: p.ink),
                ),
                if (subtext != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtext,
                    style: TextStyle(fontSize: 11.5, color: p.inkMuted),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: TextFormField(
              controller: ctrl,
              decoration: _inputDeco(),
            ),
          ),
        ],
      ),
    );
  }
}
