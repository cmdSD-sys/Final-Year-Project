import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/app_snack_bar.dart';

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
  void initState() {
    super.initState();
    final isSuper = widget.appState.isSuperAdmin;
    final userDept = widget.appState.currentUserDepartment;
    if (!isSuper && userDept != null && userDept.trim().isNotEmpty) {
      _selectedFacultyDept = userDept.trim().toUpperCase();
      _selectedCourseDept = userDept.trim().toUpperCase();
    }
  }

  Future<void> _handleClearFaculties() async {
    final targetDept = _selectedFacultyDept;
    final deptName = targetDept != null ? 'department "$targetDept"' : 'ALL departments';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFB3261E), size: 24),
              SizedBox(width: 8),
              Text(
                'Clear Faculty Catalog?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to permanently clear all faculties for $deptName?\n\n'
            'This action cannot be undone. You will need to upload an updated Excel sheet to restore faculty records.',
            style: TextStyle(
              fontSize: 13.5,
              color: isDark ? const Color(0xFFC0CDD3) : const Color(0xFF2B4650),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB3261E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Clear Faculties'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final count = await widget.appState.clearFaculties(programCode: targetDept);
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        'Successfully cleared $count faculties for $deptName!',
      );
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(
        context,
        e.toString().replaceAll('ApiException: ', ''),
      );
    }
  }

  Future<void> _handleClearCourses() async {
    final targetDept = _selectedCourseDept;
    final deptName = targetDept != null ? 'department "$targetDept"' : 'ALL departments';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFB3261E), size: 24),
              SizedBox(width: 8),
              Text(
                'Clear Course Catalog?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to permanently clear all courses/curriculum for $deptName?\n\n'
            'This action cannot be undone. You will need to upload an updated Excel sheet to restore curriculum subjects.',
            style: TextStyle(
              fontSize: 13.5,
              color: isDark ? const Color(0xFFC0CDD3) : const Color(0xFF2B4650),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB3261E),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Clear Courses'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final count = await widget.appState.clearCourses(programCode: targetDept);
      if (!mounted) return;
      AppSnackBar.showSuccess(
        context,
        'Successfully cleared $count courses for $deptName!',
      );
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(
        context,
        e.toString().replaceAll('ApiException: ', ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = Pal.of(context).surface;
    final textColor = Pal.of(context).ink;
    final borderColor = Pal.of(context).rule;
    final isSuper = widget.appState.isSuperAdmin;
    final userDept = widget.appState.currentUserDepartment;

    if (!isSuper && userDept != null && userDept.trim().isNotEmpty) {
      _selectedFacultyDept = userDept.trim().toUpperCase();
      _selectedCourseDept = userDept.trim().toUpperCase();
    }

    final programs = widget.appState.programs;
    final allFaculties = (!isSuper && userDept != null && userDept.trim().isNotEmpty)
        ? widget.appState.faculties
            .where((f) => f.programCode.trim().toUpperCase() == userDept.trim().toUpperCase())
            .toList()
        : widget.appState.faculties;
    final allCourses = (!isSuper && userDept != null && userDept.trim().isNotEmpty)
        ? widget.appState.courses
            .where((c) => c.programCode.trim().toUpperCase() == userDept.trim().toUpperCase())
            .toList()
        : widget.appState.courses;

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
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor),
      ),
      title: Row(
        children: [
          Icon(
            Icons.menu_book,
            color: isDark ? const Color(0xFF5DB8DB) : const Color(0xFF0B6A90),
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Active Curriculum & Faculty Catalog',
              style: AppType.display(textColor, size: 22, height: 1.2),
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
                labelColor: isDark ? const Color(0xFF5DB8DB) : const Color(0xFF0B6A90),
                unselectedLabelColor: isDark ? const Color(0xFF8FA6AF) : const Color(0xFF5B6E76),
                indicatorColor: isDark ? const Color(0xFF5DB8DB) : const Color(0xFF0B6A90),
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
                                  suffixIcon: !isSuper
                                      ? const Tooltip(
                                          message: 'Locked to your department',
                                          child: Icon(Icons.lock_outline, size: 16),
                                        )
                                      : null,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                items: [
                                  if (isSuper)
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
                                onChanged: !isSuper
                                    ? null
                                    : (val) {
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
                                    ? const Color(0xFF1281B0).withValues(alpha: 0.2)
                                    : Color(0xFFE3F0F5),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF2E93BD).withValues(alpha: 0.4)
                                      : Color(0xFFB5D9E8),
                                ),
                              ),
                              child: Text(
                                '${filteredFaculties.length} / ${allFaculties.length}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isDark ? const Color(0xFF9BD0E6) : Color(0xFF084E6B),
                                ),
                              ),
                            ),
                            if (widget.appState.isAdminOrSuper) ...[
                              const SizedBox(width: 8),
                              Tooltip(
                                message: _selectedFacultyDept != null
                                    ? 'Clear faculties for $_selectedFacultyDept'
                                    : 'Clear all faculties',
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFB3261E),
                                    side: const BorderSide(color: Color(0xFFC7443A)),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  icon: const Icon(Icons.delete_sweep, size: 16),
                                  label: Text(
                                    _selectedFacultyDept != null ? 'Clear ($_selectedFacultyDept)' : 'Clear All',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: _handleClearFaculties,
                                ),
                              ),
                            ],
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
                                        color: isDark ? const Color(0xFF5B6E76) : Color(0xFF8FA6AF),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No faculty loaded for ${_selectedFacultyDept ?? "selected filter"}.',
                                        style: TextStyle(
                                          color: isDark ? const Color(0xFF8FA6AF) : Color(0xFF5B6E76),
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
                                            const Color(0xFF0B6A90),
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
                                          color: isDark ? const Color(0xFF8FA6AF) : const Color(0xFF5B6E76),
                                        ),
                                      ),
                                      trailing: Chip(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: isDark ? const Color(0xFF0E222A) : const Color(0xFFE9EFF1),
                                        side: BorderSide(color: borderColor),
                                        label: Text(
                                          f.programCode,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDark ? const Color(0xFF9BD0E6) : const Color(0xFF0B6A90),
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
                                  suffixIcon: !isSuper
                                      ? const Tooltip(
                                          message: 'Locked to your department',
                                          child: Icon(Icons.lock_outline, size: 16),
                                        )
                                      : null,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                items: [
                                  if (isSuper)
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
                                onChanged: !isSuper
                                    ? null
                                    : (val) {
                                        setState(() {
                                          _selectedCourseDept = val;
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
                                            BorderRadius.circular(5)),
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
                                    ? const Color(0xFF0B6A90).withValues(alpha: 0.25)
                                    : Color(0xFFE3F0F5),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: isDark
                                      ? const Color(0xFF2E93BD).withValues(alpha: 0.4)
                                      : Color(0xFFB5D9E8),
                                ),
                              ),
                              child: Text(
                                '${filteredCourses.length} / ${allCourses.length}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isDark ? const Color(0xFF5DB8DB) : Color(0xFF084E6B),
                                ),
                              ),
                            ),
                            if (widget.appState.isAdminOrSuper) ...[
                              const SizedBox(width: 8),
                              Tooltip(
                                message: _selectedCourseDept != null
                                    ? 'Clear courses for $_selectedCourseDept'
                                    : 'Clear all courses',
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFB3261E),
                                    side: const BorderSide(color: Color(0xFFC7443A)),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  ),
                                  icon: const Icon(Icons.delete_sweep, size: 16),
                                  label: Text(
                                    _selectedCourseDept != null ? 'Clear ($_selectedCourseDept)' : 'Clear All',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: _handleClearCourses,
                                ),
                              ),
                            ],
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
                                        color: isDark ? const Color(0xFF5B6E76) : Color(0xFF8FA6AF),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No subjects found for ${_selectedCourseDept ?? "all departments"}${_selectedCourseSemester != null ? " (Semester $_selectedCourseSemester)" : ""}.',
                                        style: TextStyle(
                                          color: isDark ? const Color(0xFF8FA6AF) : Color(0xFF5B6E76),
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
                                            ? const Color(0xFF2E93BD).withValues(alpha: 0.3)
                                            : Color(0xFFCFE6F0),
                                        child: Text(
                                          '${c.programCode}${c.semester}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? const Color(0xFF5DB8DB) : Color(0xFF084E6B),
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
                                          color: isDark ? const Color(0xFF8FA6AF) : const Color(0xFF5B6E76),
                                        ),
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? const Color(0xFF0B6A90).withValues(alpha: 0.25)
                                              : Color(0xFFE3F0F5),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                            color: isDark
                                                ? const Color(0xFF2E93BD).withValues(alpha: 0.4)
                                                : Color(0xFFB5D9E8),
                                          ),
                                        ),
                                        child: Text(
                                          'Sem ${c.semester}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? const Color(0xFF5DB8DB) : Color(0xFF0B6A90),
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
