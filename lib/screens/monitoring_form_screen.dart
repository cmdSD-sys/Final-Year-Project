import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../services/docx_service.dart';
import '../utils/app_snack_bar.dart';

class MonitoringFormScreen extends StatefulWidget {
  final AppState appState;

  const MonitoringFormScreen({super.key, required this.appState});

  @override
  State<MonitoringFormScreen> createState() => _MonitoringFormScreenState();
}

class _MonitoringFormScreenState extends State<MonitoringFormScreen> {
  String _semesterType = 'Odd'; // 'Odd' or 'Even'
  ProgramInfo? _selectedProgram;
  int _rowCount = 2;
  late List<MonitoringRowEntry> _rows;
  final _formKey = GlobalKey<FormState>();
  String _nbaStatus = 'Accredited'; // NBA Status dropdown
  int _weeksDoneYear1 = 10; // 1st year (1st and 2nd sem, 1 to 26 weeks, default 10)
  int _weeksDoneYear2 = 10; // 2nd year (3rd and 4th sem, 1 to 26 weeks, default 10)
  int _weeksDoneYear3 = 10; // 3rd year (5th and 6th sem, 1 to 26 weeks, default 10)

  int _getWeeksDoneForAcademicYear(int academicYear) {
    if (academicYear == 1) return _weeksDoneYear1;
    if (academicYear == 2) return _weeksDoneYear2;
    return _weeksDoneYear3;
  }

  @override
  void initState() {
    super.initState();
    final progs = widget.appState.programs;
    if (progs.isNotEmpty) {
      _selectedProgram = progs.first;
    }
    _initRows(_rowCount);
  }

  void _initRows(int count) {
    _rows = List.generate(count, (index) {
      return MonitoringRowEntry(
        srNo: index + 1,
      );
    });
  }

  void _updateRowCount(int newCount) {
    if (newCount < 1) return;
    if (newCount > 50) newCount = 50;

    setState(() {
      _rowCount = newCount;
      if (newCount > _rows.length) {
        final toAdd = newCount - _rows.length;
        for (var i = 0; i < toAdd; i++) {
          _rows.add(MonitoringRowEntry(srNo: _rows.length + 1));
        }
      } else if (newCount < _rows.length) {
        _rows = _rows.sublist(0, newCount);
      }
    });
  }

  /// Returns the semester schemes e.g. CM1K, CM3K, CM5K if Odd, or CM2K, CM4K, CM6K if Even
  List<String> _getAvailableSchemes(String programCode) {
    final code = programCode.toUpperCase();
    if (_semesterType == 'Odd') {
      return ['${code}1K', '${code}3K', '${code}5K'];
    } else {
      return ['${code}2K', '${code}4K', '${code}6K'];
    }
  }

  /// Extracts numeric semester from scheme string e.g. "CM1K" -> 1
  int _extractSemNumber(String scheme) {
    final match = RegExp(r'\d+').firstMatch(scheme);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 1;
    }
    return 1;
  }

  void _onSemesterTypeChanged(String? newType) {
    if (newType == null || newType == _semesterType) return;
    setState(() {
      _semesterType = newType;
      // Reset rows semester & course when odd/even switches
      for (final row in _rows) {
        row.branchSemScheme = '';
        row.courseAbbreviationCode = '';
      }
    });
  }

  void _onProgramChanged(ProgramInfo? newProg) {
    if (newProg == null || newProg == _selectedProgram) return;
    setState(() {
      _selectedProgram = newProg;
      // Reset rows when program changes
      for (final row in _rows) {
        row.facultyName = '';
        row.qualification = '';
        row.facultyApproved = '';
        row.branchSemScheme = '';
        row.courseAbbreviationCode = '';
      }
    });
  }

  void _handleSave() {
    if (_selectedProgram == null) {
      AppSnackBar.showError(context, 'Please select a Program.');
      return;
    }

    // Validate rows
    for (var i = 0; i < _rows.length; i++) {
      final r = _rows[i];
      if (r.facultyName.isEmpty) {
        AppSnackBar.showError(
            context, 'Please select Faculty Name for Row ${i + 1}.');
        return;
      }
      if (r.branchSemScheme.isEmpty) {
        AppSnackBar.showError(
            context, 'Please select Semester Scheme for Row ${i + 1}.');
        return;
      }
      if (r.courseAbbreviationCode.isEmpty) {
        AppSnackBar.showError(
            context, 'Please select Course for Row ${i + 1}.');
        return;
      }
      if (r.thPrescribed.isEmpty) {
        final matched = widget.appState.courses.cast<CourseInfo?>().firstWhere(
          (c) => c?.courseCodeAndAbbr == r.courseAbbreviationCode,
          orElse: () => null,
        );
        if (matched != null) {
          r.thPrescribed = matched.thPrescribed;
          r.prPrescribed = matched.prPrescribed;
          r.tuPrescribed = matched.tuPrescribed;
        } else {
          r.thPrescribed = '4';
          r.prPrescribed = 'NA';
          r.tuPrescribed = 'NA';
        }
      }

      // Calculate actual contact hours based on the academic year the subject belongs to
      final entryWeeks = _getWeeksDoneForAcademicYear(r.academicYear);
      r.thActual = DocxService.calcMultipliedHours(r.thPrescribed, entryWeeks);
      r.prActual = DocxService.calcMultipliedHours(r.prPrescribed, entryWeeks);
      r.tuActual = DocxService.calcMultipliedHours(r.tuPrescribed, entryWeeks);
    }

    final submissionId = 'IIM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    final submission = MonitoringSubmission(
      id: submissionId,
      programName: _selectedProgram!.name,
      programCode: _selectedProgram!.code,
      semesterType: _semesterType.toUpperCase(),
      nbaStatus: _nbaStatus,
      weeksDone: _weeksDoneYear1,
      weeksDoneYear1: _weeksDoneYear1,
      weeksDoneYear2: _weeksDoneYear2,
      weeksDoneYear3: _weeksDoneYear3,
      submittedAt: DateTime.now(),
      rows: _rows.map((r) => r.copyWith()).toList(),
    );

    widget.appState.saveSubmission(submission);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Form Saved Successfully'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Submission ID: $submissionId',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Program: ${_selectedProgram!.name} (${_selectedProgram!.code})'),
            Text('Semester: $_semesterType Semester'),
            Text('Weeks Done: 1st Yr: ${_weeksDoneYear1}w | 2nd Yr: ${_weeksDoneYear2}w | 3rd Yr: ${_weeksDoneYear3}w'),
            Text('NBA Status: $_nbaStatus'),
            Text('Total Faculty Entries: ${_rows.length}'),
            const SizedBox(height: 12),
            const Text(
              'Your monitoring data has been safely saved! The Administrator can now review and export the official Format.docx document.',
              style: TextStyle(fontSize: 13.5, color: Color(0xFF475569)),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx); // close dialog
              Navigator.pop(context); // back to user home
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availablePrograms = widget.appState.programs;
    ProgramInfo? prog = _selectedProgram;
    if (availablePrograms.isNotEmpty) {
      if (prog == null || !availablePrograms.contains(prog)) {
        prog = availablePrograms.firstWhere(
          (p) => prog != null && p.code.toUpperCase() == prog.code.toUpperCase(),
          orElse: () => availablePrograms.first,
        );
        _selectedProgram = prog;
      }
    } else {
      prog = null;
      _selectedProgram = null;
    }

    final faculties = prog != null
        ? widget.appState.getFacultiesForProgram(prog.code)
        : <FacultyInfo>[];
    final schemes = prog != null ? _getAvailableSchemes(prog.code) : <String>[];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 2,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/nobgkkwp.png',
                height: 40,
                cacheHeight: 120,
                filterQuality: FilterQuality.high,
                isAntiAlias: true,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => const Icon(Icons.school, size: 24, color: Color(0xFF1E3A8A)),
              ),
            ),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'Internal Institute Monitoring Format (IIM-26-27)',
                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1020),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              children: [
                // Top Configuration Card
                Card(
                  elevation: 2,
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isDark ? const Color(0xFF334155) : Colors.blue.shade100,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.tune,
                              color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Format Setup & Parameters',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 20,
                          runSpacing: 16,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // 1. Even or Odd Semester Dropdown
                            SizedBox(
                              width: 220,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Semester Type',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<String>(
                                    initialValue: _semesterType,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Odd',
                                        child: Text('Odd Semester (1K, 3K, 5K)'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Even',
                                        child: Text('Even Semester (2K, 4K, 6K)'),
                                      ),
                                    ],
                                    onChanged: _onSemesterTypeChanged,
                                  ),
                                ],
                              ),
                            ),

                             // 2. Program Dropdown
                            SizedBox(
                              width: 320,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Program / Branch',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<ProgramInfo>(
                                    key: ValueKey('prog_${_selectedProgram?.code}_${availablePrograms.length}'),
                                    initialValue: (prog != null && availablePrograms.contains(prog)) ? prog : null,
                                    isExpanded: true,
                                    hint: const Text('Select Program'),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    items: availablePrograms
                                        .map((p) => DropdownMenuItem(
                                              value: p,
                                              child: Text(
                                                '${p.name} (${p.code})',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: _onProgramChanged,
                                  ),
                                ],
                              ),
                            ),

                            // 3. NBA Status Dropdown
                            SizedBox(
                              width: 240,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NBA Status',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<String>(
                                    initialValue: _nbaStatus,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Accredited',
                                        child: Text('Accredited'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Applied',
                                        child: Text('Applied'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Not Applied',
                                        child: Text('Not Applied'),
                                      ),
                                    ],
                                    onChanged: (v) {
                                      if (v != null) setState(() => _nbaStatus = v);
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // 4. 1st Year (1st & 2nd Sem) Weeks Done
                            SizedBox(
                              width: 240,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '1st Year (1st & 2nd Sem) Weeks',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<int>(
                                    key: ValueKey('weeks_done_y1_$_weeksDoneYear1'),
                                    initialValue: _weeksDoneYear1,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    items: List.generate(26, (i) => i + 1).map((w) {
                                      return DropdownMenuItem<int>(
                                        value: w,
                                        child: Text('$w ${w == 1 ? "Week" : "Weeks"} Done'),
                                      );
                                    }).toList(),
                                    onChanged: (v) {
                                      if (v != null) setState(() => _weeksDoneYear1 = v);
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // 5. 2nd Year (3rd & 4th Sem) Weeks Done
                            SizedBox(
                              width: 240,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '2nd Year (3rd & 4th Sem) Weeks',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<int>(
                                    key: ValueKey('weeks_done_y2_$_weeksDoneYear2'),
                                    initialValue: _weeksDoneYear2,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    items: List.generate(26, (i) => i + 1).map((w) {
                                      return DropdownMenuItem<int>(
                                        value: w,
                                        child: Text('$w ${w == 1 ? "Week" : "Weeks"} Done'),
                                      );
                                    }).toList(),
                                    onChanged: (v) {
                                      if (v != null) setState(() => _weeksDoneYear2 = v);
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // 6. 3rd Year (5th & 6th Sem) Weeks Done
                            SizedBox(
                              width: 240,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '3rd Year (5th & 6th Sem) Weeks',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  DropdownButtonFormField<int>(
                                    key: ValueKey('weeks_done_y3_$_weeksDoneYear3'),
                                    initialValue: _weeksDoneYear3,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    items: List.generate(26, (i) => i + 1).map((w) {
                                      return DropdownMenuItem<int>(
                                        value: w,
                                        child: Text('$w ${w == 1 ? "Week" : "Weeks"} Done'),
                                      );
                                    }).toList(),
                                    onChanged: (v) {
                                      if (v != null) setState(() => _weeksDoneYear3 = v);
                                    },
                                  ),
                                ],
                              ),
                            ),

                            // 5. Number of Data Rows input
                            SizedBox(
                              width: 240,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'No. of Data to Fill Out',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      IconButton.outlined(
                                        onPressed: _rowCount > 1
                                            ? () => _updateRowCount(_rowCount - 1)
                                            : null,
                                        icon: const Icon(Icons.remove, size: 18),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                            minWidth: 36, minHeight: 36),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 54,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: isDark ? const Color(0xFF334155) : Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: isDark ? const Color(0xFF0F172A) : Colors.white,
                                        ),
                                        child: Text(
                                          '$_rowCount',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton.outlined(
                                        onPressed: _rowCount < 50
                                            ? () => _updateRowCount(_rowCount + 1)
                                            : null,
                                        icon: const Icon(Icons.add, size: 18),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                            minWidth: 36, minHeight: 36),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'rows',
                                        style: TextStyle(
                                            color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Header for Dynamic Rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Faculty Data Rows (${_rows.length})',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Auto-fills Qualification & Approval upon selecting Faculty',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Dynamic Rows List
                ...List.generate(_rows.length, (index) {
                  return _buildRowCard(
                    index: index,
                    faculties: faculties,
                    schemes: schemes,
                  );
                }),

                const SizedBox(height: 32),

                // Save Form Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _handleSave,
                    icon: const Icon(Icons.save),
                    label: Text(
                      'Save Monitoring Form (${_rows.length} Entries)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRowCard({
    required int index,
    required List<FacultyInfo> faculties,
    required List<String> schemes,
  }) {
    final row = _rows[index];
    final semNum = row.branchSemScheme.isNotEmpty
        ? _extractSemNumber(row.branchSemScheme)
        : 0;

    final availableCourses = (_selectedProgram != null && semNum > 0)
        ? widget.appState.getCourses(_selectedProgram!.code, semNum)
        : <CourseInfo>[];

    final uniqueFaculties = <String, FacultyInfo>{};
    for (final f in faculties) {
      uniqueFaculties.putIfAbsent(f.name, () => f);
    }
    final facultyList = uniqueFaculties.values.toList();
    final selectedFacultyName =
        (row.facultyName.isNotEmpty && uniqueFaculties.containsKey(row.facultyName))
            ? row.facultyName
            : null;

    final schemeList = schemes.toSet().toList();
    final selectedScheme =
        (row.branchSemScheme.isNotEmpty && schemeList.contains(row.branchSemScheme))
            ? row.branchSemScheme
            : null;

    final courseCodes = <String>{};
    if (availableCourses.isNotEmpty) {
      for (final c in availableCourses) {
        courseCodes.add(c.courseCodeAndAbbr);
      }
    } else if (row.branchSemScheme.isNotEmpty) {
      courseCodes.add('${row.branchSemScheme.substring(0, 2)}-${semNum}01');
      courseCodes.add('${row.branchSemScheme.substring(0, 2)}-${semNum}02');
    }
    final courseList = courseCodes.toList();
    final selectedCourse = (row.courseAbbreviationCode.isNotEmpty &&
            courseCodes.contains(row.courseAbbreviationCode))
        ? row.courseAbbreviationCode
        : null;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row Header
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFF1E3A8A),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Row #${index + 1} - Faculty Entry',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                if (row.branchSemScheme.isNotEmpty) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2563EB).withValues(alpha: 0.2)
                          : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF3B82F6).withValues(alpha: 0.4)
                            : Colors.blue.shade200,
                      ),
                    ),
                    child: Text(
                      '${row.academicYear == 1 ? "1st Year (Sem 1 & 2)" : row.academicYear == 2 ? "2nd Year (Sem 3 & 4)" : "3rd Year (Sem 5 & 6)"} • ${_getWeeksDoneForAcademicYear(row.academicYear)} Wks',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? const Color(0xFF93C5FD) : Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // Form Fields Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return Wrap(
                  spacing: 16,
                  runSpacing: 14,
                  children: [
                    // 1. Name of Faculty Dropdown
                    SizedBox(
                      width: isWide ? (constraints.maxWidth - 48) / 3 : constraints.maxWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '1. Name of Faculty *',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            key: ValueKey('fac_${index}_${selectedFacultyName}_${facultyList.length}_${_rows.map((r) => r.facultyName).join("_")}'),
                            initialValue: selectedFacultyName,
                            isExpanded: true,
                            hint: const Text('Select Faculty'),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            selectedItemBuilder: (context) {
                              return facultyList.map((f) {
                                return Text(
                                  f.name,
                                  overflow: TextOverflow.ellipsis,
                                );
                              }).toList();
                            },
                            items: facultyList.map((f) {
                              final usedInRowNumbers = <int>[];
                              for (var r = 0; r < _rows.length; r++) {
                                if (r != index && _rows[r].facultyName == f.name && f.name.isNotEmpty) {
                                  usedInRowNumbers.add(r + 1);
                                }
                              }

                              return DropdownMenuItem<String>(
                                value: f.name,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        f.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (usedInRowNumbers.isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Tooltip(
                                        message: usedInRowNumbers.length == 1
                                            ? 'Used in Row ${usedInRowNumbers.first}'
                                            : 'Used in ${usedInRowNumbers.length} places: ${usedInRowNumbers.map((rn) => "Row $rn").join(", ")}',
                                        waitDuration: Duration.zero,
                                        showDuration: const Duration(seconds: 4),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFEF3C7),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                                color: const Color(0xFFF59E0B)),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.warning_amber_rounded,
                                                size: 13,
                                                color: Color(0xFFB45309),
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                usedInRowNumbers.length == 1
                                                    ? 'Row ${usedInRowNumbers.first}'
                                                    : '${usedInRowNumbers.length} places',
                                                style: const TextStyle(
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFB45309),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? selectedName) {
                              if (selectedName == null) return;
                              final match = uniqueFaculties[selectedName];
                              if (match != null) {
                                setState(() {
                                  row.facultyName = match.name;
                                  // Auto-fill qualification and faculty approved!
                                  row.qualification = match.qualification;
                                  row.facultyApproved = match.approvalStatus;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // 2. Auto-filled Qualification
                    SizedBox(
                      width: isWide ? (constraints.maxWidth - 48) / 3 : constraints.maxWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Qualification (Auto-filled)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            key: ValueKey('qual_${index}_${row.qualification}'),
                            initialValue: row.qualification,
                            readOnly: true,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              filled: true,
                              fillColor: isDark ? const Color(0xFF0F172A) : Colors.grey.shade100,
                              hintText: 'Auto-filled upon faculty selection',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: isDark ? const Color(0xFF64748B) : Colors.grey.shade400,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isDark ? const Color(0xFF334155) : Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isDark ? const Color(0xFF334155) : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 3. Auto-filled Faculty Approved
                    SizedBox(
                      width: isWide ? (constraints.maxWidth - 48) / 3 : constraints.maxWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Faculty Approved (Auto-filled)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            key: ValueKey('appr_${index}_${row.facultyApproved}'),
                            initialValue: row.facultyApproved,
                            readOnly: true,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              filled: true,
                              fillColor: isDark ? const Color(0xFF0F172A) : Colors.grey.shade100,
                              hintText: 'Auto-filled upon faculty selection',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: isDark ? const Color(0xFF64748B) : Colors.grey.shade400,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isDark ? const Color(0xFF334155) : Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isDark ? const Color(0xFF334155) : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 4. Semester Scheme Selection (e.g. CM1K, CM3K, CM5K if Odd, or CM2K, CM4K, CM6K if Even)
                    SizedBox(
                      width: isWide ? (constraints.maxWidth - 32) / 2 : constraints.maxWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2. Semester / Scheme (${_semesterType == 'Odd' ? '1K, 3K, 5K' : '2K, 4K, 6K'}) *',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            key: ValueKey('scheme_${index}_${selectedScheme}_${schemeList.length}'),
                            initialValue: selectedScheme,
                            isExpanded: true,
                            hint: const Text('Select Semester Scheme'),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: schemeList.map((s) {
                              return DropdownMenuItem(
                                value: s,
                                child: Text(s),
                              );
                            }).toList(),
                            onChanged: (String? selectedScheme) {
                              if (selectedScheme == null) return;
                              setState(() {
                                row.branchSemScheme = selectedScheme;
                                // Reset course when sem changes
                                row.courseAbbreviationCode = '';
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // 5. Course Abbreviation and Code Dropdown
                    SizedBox(
                      width: isWide ? (constraints.maxWidth - 32) / 2 : constraints.maxWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '3. Course Abbreviation & Code *',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            key: ValueKey('course_${index}_${selectedCourse}_${courseList.length}'),
                            initialValue: selectedCourse,
                            isExpanded: true,
                            hint: Text(
                              row.branchSemScheme.isEmpty
                                  ? 'Select Semester Scheme first'
                                  : 'Select Course',
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: courseList.map((code) {
                              return DropdownMenuItem(
                                value: code,
                                child: Text(
                                  code,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? selectedCourse) {
                              if (selectedCourse == null) return;
                              setState(() {
                                row.courseAbbreviationCode = selectedCourse;
                                final matchedCourse = widget.appState.courses.cast<CourseInfo?>().firstWhere(
                                  (c) => c?.courseCodeAndAbbr == selectedCourse &&
                                         (c?.programCode == _selectedProgram?.code),
                                  orElse: () => widget.appState.courses.cast<CourseInfo?>().firstWhere(
                                    (c) => c?.courseCodeAndAbbr == selectedCourse,
                                    orElse: () => null,
                                  ),
                                );
                                if (matchedCourse != null) {
                                  row.thPrescribed = matchedCourse.thPrescribed;
                                  row.prPrescribed = matchedCourse.prPrescribed;
                                  row.tuPrescribed = matchedCourse.tuPrescribed;
                                  final entryWeeks = _getWeeksDoneForAcademicYear(row.academicYear);
                                  row.thActual = DocxService.calcMultipliedHours(row.thPrescribed, entryWeeks);
                                  row.prActual = DocxService.calcMultipliedHours(row.prPrescribed, entryWeeks);
                                  row.tuActual = DocxService.calcMultipliedHours(row.tuPrescribed, entryWeeks);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    // 6. K1 II-C-2 Dropdown (Yes / No)
                    SizedBox(
                      width: isWide ? (constraints.maxWidth - 48) / 3 : constraints.maxWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'K1 (II-C-2)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            key: ValueKey('k1_${index}_${row.k1}'),
                            initialValue: row.k1,
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                              DropdownMenuItem(value: 'No', child: Text('No')),
                            ],
                            onChanged: (String? val) {
                              if (val != null) {
                                setState(() => row.k1 = val);
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // 7. K2-A/K2-B II-C-3 Dropdown (Yes / No)
                    SizedBox(
                      width: isWide ? (constraints.maxWidth - 48) / 3 : constraints.maxWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'K2-A/K2-B (II-C-3)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            key: ValueKey('k2_${index}_${row.k2}'),
                            initialValue: row.k2,
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                              DropdownMenuItem(value: 'No', child: Text('No')),
                            ],
                            onChanged: (String? val) {
                              if (val != null) {
                                setState(() => row.k2 = val);
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // 8. K3 Dropdown (Yes / No)
                    SizedBox(
                      width: isWide ? (constraints.maxWidth - 48) / 3 : constraints.maxWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'K3',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            key: ValueKey('k3_${index}_${row.k3}'),
                            initialValue: row.k3,
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                              DropdownMenuItem(value: 'No', child: Text('No')),
                            ],
                            onChanged: (String? val) {
                              if (val != null) {
                                setState(() => row.k3 = val);
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // 9. K6-SLA Created/Maintained/Refined II-C-12,13 Dropdown (Records Checked / Records Not Checked)
                    SizedBox(
                      width: isWide ? (constraints.maxWidth - 32) / 2 : constraints.maxWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'K6 SLA (II-C-12,13)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            key: ValueKey('k6_${index}_${row.k6}'),
                            initialValue: row.k6,
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Records Checked',
                                child: Text('Records Checked'),
                              ),
                              DropdownMenuItem(
                                value: 'Records Not Checked',
                                child: Text('Records Not Checked'),
                              ),
                            ],
                            onChanged: (String? val) {
                              if (val != null) {
                                setState(() => row.k6 = val);
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // 10. K-7 CT-1 Dropdown (Yes / No)
                    SizedBox(
                      width: isWide ? (constraints.maxWidth - 32) / 2 : constraints.maxWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'K-7 CT-1',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            key: ValueKey('k7_${index}_${row.k7}'),
                            initialValue: row.k7,
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                              DropdownMenuItem(value: 'No', child: Text('No')),
                            ],
                            onChanged: (String? val) {
                              if (val != null) {
                                setState(() => row.k7 = val);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );

  }
}
