import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'excel_service.dart';

enum AppRole {
  none,
  user,
  admin,
}

class AppState extends ChangeNotifier {
  AppRole _currentRole = AppRole.none;
  ThemeMode _themeMode = ThemeMode.light;
  List<ProgramInfo> _programs = [];
  List<FacultyInfo> _faculties = [];
  List<CourseInfo> _courses = [];
  final List<MonitoringSubmission> _submissions = [];

  String _adminName = 'Administrator';
  String _userName = 'Faculty Member';
  Uint8List? _adminPfpBytes;
  Uint8List? _userPfpBytes;

  AppRole get currentRole => _currentRole;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  List<ProgramInfo> get programs => List.unmodifiable(_programs);
  List<FacultyInfo> get faculties => List.unmodifiable(_faculties);
  List<CourseInfo> get courses => List.unmodifiable(_courses);
  List<MonitoringSubmission> get submissions => List.unmodifiable(_submissions);

  String get currentUserName =>
      _currentRole == AppRole.admin ? _adminName : _userName;
  Uint8List? get currentUserPfpBytes =>
      _currentRole == AppRole.admin ? _adminPfpBytes : _userPfpBytes;

  void updateCurrentUserName(String newName) {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    if (_currentRole == AppRole.admin) {
      _adminName = trimmed;
    } else {
      _userName = trimmed;
    }
    notifyListeners();
  }

  void updateCurrentUserPfp(Uint8List? imageBytes) {
    if (_currentRole == AppRole.admin) {
      _adminPfpBytes = imageBytes;
    } else {
      _userPfpBytes = imageBytes;
    }
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  AppState() {
    _initDefaults();
  }

  void _initDefaults() {
    // By default keep everything empty ("only through upload it will work")
    _programs = [];
    _faculties = [];
    _courses = [];
    _submissions.clear();
  }

  /// Optional helper if user clicks 'Load Demo Data'
  void loadSampleDemoData() {
    _programs = ExcelService.getDefaultPrograms();
    _faculties = ExcelService.getDefaultFaculties();
    _courses = ExcelService.getDefaultCourses();
    notifyListeners();
  }

  void setRole(AppRole role) {
    _currentRole = role;
    notifyListeners();
  }

  List<FacultyInfo> getFacultiesForProgram(String programCode) {
    return _faculties
        .where((f) => f.programCode.toUpperCase() == programCode.toUpperCase())
        .toList();
  }

  List<CourseInfo> getCourses(String programCode, int semester) {
    return _courses
        .where((c) =>
            c.programCode.toUpperCase() == programCode.toUpperCase() &&
            c.semester == semester)
        .toList();
  }

  void saveSubmission(MonitoringSubmission submission) {
    // Insert newest first
    _submissions.insert(0, submission);
    notifyListeners();
  }

  void deleteSubmission(String id) {
    _submissions.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  void updateFacultyAndPrograms({
    required List<ProgramInfo> newPrograms,
    required List<FacultyInfo> newFaculties,
  }) {
    if (newPrograms.isNotEmpty) {
      final map = {for (var p in _programs) p.code: p};
      for (var p in newPrograms) {
        map[p.code] = p;
      }
      _programs = map.values.toList();
    }

    if (newFaculties.isNotEmpty) {
      _faculties = List.from(newFaculties);
    }
    notifyListeners();
  }

  void updateCourses(List<CourseInfo> newCourses) {
    if (newCourses.isNotEmpty) {
      _courses = List.from(newCourses);
      notifyListeners();
    }
  }

  void resetToDefaultData() {
    _initDefaults();
    notifyListeners();
  }
}
