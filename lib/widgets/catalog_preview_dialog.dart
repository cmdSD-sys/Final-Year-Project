import 'package:flutter/material.dart';
import '../services/app_state.dart';

class CatalogPreviewDialog extends StatefulWidget {
  final AppState appState;

  const CatalogPreviewDialog({super.key, required this.appState});

  @override
  State<CatalogPreviewDialog> createState() => _CatalogPreviewDialogState();
}

class _CatalogPreviewDialogState extends State<CatalogPreviewDialog> {
  String? _selectedFacultyDept; // null means 'All Departments'
  String? _selectedCourseDept; // null means 'All Departments'
  int? _selectedCourseSemester; // null means 'All Semesters'

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final programs = widget.appState.programs;
    final allFaculties = widget.appState.faculties;
    final allCourses = widget.appState.courses;

    // Filter faculties
    final filteredFaculties = _selectedFacultyDept == null
        ? allFaculties
        : allFaculties
            .where((f) =>
                f.programCode.toUpperCase() ==
                _selectedFacultyDept!.toUpperCase())
            .toList();

    // Filter courses
    final filteredCourses = allCourses.where((c) {
      if (_selectedCourseDept != null &&
          c.programCode.toUpperCase() != _selectedCourseDept!.toUpperCase()) {
        return false;
      }
      if (_selectedCourseSemester != null &&
          c.semester != _selectedCourseSemester) {
        return false;
      }
      return true;
    }).toList();

    // Available semesters for selected course dept (if dept is selected)
    final availableSemesters = _selectedCourseDept == null
        ? <int>[]
        : (allCourses
            .where((c) =>
                c.programCode.toUpperCase() ==
                _selectedCourseDept!.toUpperCase())
            .map((c) => c.semester)
            .toSet()
            .toList()
          ..sort());

    return AlertDialog(
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      title: Row(
        children: [
          Icon(
            Icons.menu_book,
            color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A),
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Active Curriculum & Faculty Catalog',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 720,
        height: 540,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                labelColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A),
                unselectedLabelColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                indicatorColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1E3A8A),
                tabs: const [
                  Tab(
                    icon: Icon(Icons.people, size: 18),
                    text: 'Faculties by Department',
                  ),
                  Tab(
                    icon: Icon(Icons.library_books, size: 18),
                    text: 'Subjects & Semesters',
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab 1: Faculty Catalog (Dept wise filter)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        // Department Filter Bar
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String?>(
                                initialValue: _selectedFacultyDept,
                                isExpanded: true,
                                dropdownColor: dialogBg,
                                decoration: InputDecoration(
                                  labelText: 'Filter Department',
                                  prefixIcon:
                                      const Icon(Icons.filter_alt, size: 18),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child:
                                        Text('All Departments (All Faculties)'),
                                  ),
                                  ...programs.map((p) {
                                    return DropdownMenuItem<String?>(
                                      value: p.code,
                                      child: Text('${p.name} (${p.code})'),
                                    );
                                  }),
                                ],
                                onChanged: (val) {
                                  setState(() => _selectedFacultyDept = val);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF2563EB).withValues(alpha: 0.2)
                                    : Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF3B82F6).withValues(alpha: 0.4)
                                      : Colors.blue.shade200,
                                ),
                              ),
                              child: Text(
                                '${filteredFaculties.length} / ${allFaculties.length}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isDark ? const Color(0xFF93C5FD) : Colors.blue.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Faculty List
                        Expanded(
                          child: filteredFaculties.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.person_off,
                                        size: 48,
                                        color: isDark ? const Color(0xFF64748B) : Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No faculty loaded for ${_selectedFacultyDept ?? "selected filter"}.',
                                        style: TextStyle(
                                          color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.only(top: 8),
                                  itemCount: filteredFaculties.length,
                                  separatorBuilder: (_, _) =>
                                      Divider(height: 1, color: borderColor),
                                  itemBuilder: (context, idx) {
                                    final f = filteredFaculties[idx];
                                    return ListTile(
                                      dense: true,
                                      leading: CircleAvatar(
                                        radius: 15,
                                        backgroundColor:
                                            const Color(0xFF1E3A8A),
                                        child: Text(
                                          f.programCode,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        f.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${f.qualification} • ${f.approvalStatus}',
                                        style: TextStyle(
                                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                        ),
                                      ),
                                      trailing: Chip(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                        side: BorderSide(color: borderColor),
                                        label: Text(
                                          f.programCode,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E3A8A),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),

                    // Tab 2: Courses & Curriculum (First Dept-wise, then Semester-wise)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        // First Filter: Department-wise
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: DropdownButtonFormField<String?>(
                                initialValue: _selectedCourseDept,
                                isExpanded: true,
                                dropdownColor: dialogBg,
                                decoration: InputDecoration(
                                  labelText: '1. Select Department',
                                  prefixIcon:
                                      const Icon(Icons.school, size: 18),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                items: [
                                  const DropdownMenuItem<String?>(
                                    value: null,
                                    child:
                                        Text('All Departments (All Subjects)'),
                                  ),
                                  ...programs.map((p) {
                                    return DropdownMenuItem<String?>(
                                      value: p.code,
                                      child: Text('${p.name} (${p.code})'),
                                    );
                                  }),
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    _selectedCourseDept = val;
                                    // Reset semester filter when department changes
                                    _selectedCourseSemester = null;
                                  });
                                },
                              ),
                            ),
                            // Second Filter: Semester-wise (Appears when department is selected!)
                            if (_selectedCourseDept != null) ...[
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: DropdownButtonFormField<int?>(
                                  key: ValueKey(
                                      'sem_filter_${_selectedCourseDept}_$_selectedCourseSemester'),
                                  initialValue: _selectedCourseSemester,
                                  isExpanded: true,
                                  dropdownColor: dialogBg,
                                  decoration: InputDecoration(
                                    labelText: '2. Select Semester',
                                    prefixIcon: const Icon(Icons.filter_list,
                                        size: 18),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)),
                                  ),
                                  items: [
                                    const DropdownMenuItem<int?>(
                                      value: null,
                                      child: Text('All Semesters'),
                                    ),
                                    ...(availableSemesters.isNotEmpty
                                            ? availableSemesters
                                            : [1, 2, 3, 4, 5, 6])
                                        .map((sem) {
                                      return DropdownMenuItem<int?>(
                                        value: sem,
                                        child: Text('Semester $sem'),
                                      );
                                    }),
                                  ],
                                  onChanged: (val) {
                                    setState(
                                        () => _selectedCourseSemester = val);
                                  },
                                ),
                              ),
                            ],
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF0F766E).withValues(alpha: 0.25)
                                    : Colors.teal.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF14B8A6).withValues(alpha: 0.4)
                                      : Colors.teal.shade200,
                                ),
                              ),
                              child: Text(
                                '${filteredCourses.length} / ${allCourses.length}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isDark ? const Color(0xFF5EEAD4) : Colors.teal.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Course List
                        Expanded(
                          child: filteredCourses.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.library_books,
                                        size: 48,
                                        color: isDark ? const Color(0xFF64748B) : Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No subjects found for ${_selectedCourseDept ?? "all departments"}${_selectedCourseSemester != null ? " (Semester $_selectedCourseSemester)" : ""}.',
                                        style: TextStyle(
                                          color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.only(top: 8),
                                  itemCount: filteredCourses.length,
                                  separatorBuilder: (_, _) =>
                                      Divider(height: 1, color: borderColor),
                                  itemBuilder: (context, idx) {
                                    final c = filteredCourses[idx];
                                    return ListTile(
                                      dense: true,
                                      leading: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: isDark
                                            ? const Color(0xFF14B8A6).withValues(alpha: 0.3)
                                            : Colors.teal.shade100,
                                        child: Text(
                                          '${c.programCode}${c.semester}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? const Color(0xFF5EEAD4) : Colors.teal.shade900,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        c.courseCodeAndAbbr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: textColor,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Dept: ${c.programCode} • Sem: ${c.semester} • Prescribed Hrs: TH: ${c.thPrescribed} | PR: ${c.prPrescribed} | TU: ${c.tuPrescribed}',
                                        style: TextStyle(
                                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                        ),
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? const Color(0xFF0F766E).withValues(alpha: 0.25)
                                              : Colors.teal.shade50,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: isDark
                                                ? const Color(0xFF14B8A6).withValues(alpha: 0.4)
                                                : Colors.teal.shade200,
                                          ),
                                        ),
                                        child: Text(
                                          'Sem ${c.semester}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? const Color(0xFF5EEAD4) : Colors.teal.shade800,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
