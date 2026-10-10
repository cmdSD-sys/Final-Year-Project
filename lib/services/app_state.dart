import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'api_service.dart';
import 'excel_service.dart';

enum AppRole {
  none,
  user,
  admin,
  superAdmin,
}

class AppState extends ChangeNotifier {
  final ApiService apiService = ApiService();

  AppRole _currentRole = AppRole.none;
  ThemeMode _themeMode = ThemeMode.light;
  AppPaletteId _currentPalette = AppPaletteId.teal;
  List<ProgramInfo> _programs = [];
  List<FacultyInfo> _faculties = [];
  List<CourseInfo> _courses = [];
  final List<MonitoringSubmission> _submissions = [];

  AuthUser? _currentUser;
  bool _isAuthenticated = false;
  bool _isBackendConnected = false;
  bool _isCheckingBackend = false;

  String _adminName = 'Administrator';
  String _userName = 'Faculty Member';
  Uint8List? _adminPfpBytes;
  Uint8List? _userPfpBytes;

  AppRole get currentRole => _currentRole;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  AppPaletteId get currentPalette => _currentPalette;

  List<ProgramInfo> get programs {
    if (!isSuperAdmin && currentUserDepartment != null && currentUserDepartment!.trim().isNotEmpty) {
      final dept = currentUserDepartment!.trim().toUpperCase();
      final filtered = _programs.where((p) => p.code.trim().toUpperCase() == dept).toList();
      if (filtered.isNotEmpty) return List.unmodifiable(filtered);
      return List.unmodifiable([
        ProgramInfo(code: dept, name: '$dept Department'),
      ]);
    }
    return List.unmodifiable(_programs);
  }
  List<FacultyInfo> get faculties => List.unmodifiable(_faculties);
  List<CourseInfo> get courses => List.unmodifiable(_courses);
  List<MonitoringSubmission> get submissions => List.unmodifiable(_submissions);

  AuthUser? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isBackendConnected => _isBackendConnected;
  bool get isCheckingBackend => _isCheckingBackend;

  bool get isSuperAdmin =>
      _currentUser?.isSuperAdmin ?? (_currentRole == AppRole.superAdmin);
  bool get isAdminOrSuper =>
      _currentUser?.isAdminOrSuper ??
      (_currentRole == AppRole.admin || _currentRole == AppRole.superAdmin);
  String? get currentUserDepartment => _currentUser?.department;

  String get currentUserName {
    if (_currentUser != null) return _currentUser!.fullName;
    if (_currentRole == AppRole.superAdmin) return 'Super Administrator';
    return _currentRole == AppRole.admin ? _adminName : _userName;
  }

  Uint8List? get currentUserPfpBytes =>
      (_currentRole == AppRole.admin || _currentRole == AppRole.superAdmin)
          ? _adminPfpBytes
          : _userPfpBytes;

  void updateCurrentUserName(String newName) {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;
    if (_currentUser != null) {
      _currentUser = AuthUser(
        id: _currentUser!.id,
        email: _currentUser!.email,
        fullName: trimmed,
        role: _currentUser!.role,
        department: _currentUser!.department,
        profilePhotoUrl: _currentUser!.profilePhotoUrl,
      );
    }
    if (_currentRole == AppRole.admin || _currentRole == AppRole.superAdmin) {
      _adminName = trimmed;
    } else {
      _userName = trimmed;
    }
    notifyListeners();
  }

  void updateCurrentUserPfp(Uint8List? imageBytes) {
    if (_currentRole == AppRole.admin || _currentRole == AppRole.superAdmin) {
      _adminPfpBytes = imageBytes;
    } else {
      _userPfpBytes = imageBytes;
    }
    notifyListeners();
  }

  Future<void> uploadAvatar(Uint8List imageBytes, String filename) async {
    updateCurrentUserPfp(imageBytes);
    if (_isAuthenticated) {
      try {
        final photoUrl = await apiService.uploadAvatar(imageBytes, filename);
        if (_currentUser != null && photoUrl != null) {
          _currentUser = AuthUser(
            id: _currentUser!.id,
            email: _currentUser!.email,
            fullName: _currentUser!.fullName,
            role: _currentUser!.role,
            department: _currentUser!.department,
            profilePhotoUrl: photoUrl,
          );
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Avatar upload to server failed: $e');
      }
    }
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

  void setPalette(AppPaletteId palette) {
    if (_currentPalette != palette) {
      _currentPalette = palette;
      Pal.activePalette = palette;
      notifyListeners();
    }
  }

  AppState() {
    _initDefaults();
  }

  void _initDefaults() {
    _programs = [];
    _faculties = [];
    _courses = [];
    _submissions.clear();
  }

  /// Check connectivity to backend API server
  Future<bool> checkBackendConnection({bool notify = true}) async {
    _isCheckingBackend = true;
    if (notify) notifyListeners();
    try {
      _isBackendConnected = await apiService.checkHealth();
    } catch (_) {
      _isBackendConnected = false;
    } finally {
      _isCheckingBackend = false;
      if (notify) notifyListeners();
    }
    return _isBackendConnected;
  }

  /// Authenticate with backend API
  Future<void> login(String email, String password) async {
    final result = await apiService.login(email, password);
    _currentUser = result['user'] as AuthUser;
    _isAuthenticated = true;
    _isBackendConnected = true;

    if (_currentUser!.isSuperAdmin) {
      _currentRole = AppRole.superAdmin;
      _adminName = _currentUser!.fullName;
    } else if (_currentUser!.isAdmin) {
      _currentRole = AppRole.admin;
      _adminName = _currentUser!.fullName;
    } else {
      _currentRole = AppRole.user;
      _userName = _currentUser!.fullName;
    }

    notifyListeners();

    // Fetch initial data from backend
    await refreshCatalogFromBackend();
    await refreshSubmissionsFromBackend();
  }

  /// One-click quick login for testing/demo
  Future<void> loginDemo(AppRole role, {String? customEmail, String? customPassword}) async {
    final isOnline = await checkBackendConnection();
    if (isOnline) {
      final email = customEmail ??
          (role == AppRole.superAdmin
              ? 'superadmin@kkwagh.edu.in'
              : (role == AppRole.admin
                  ? 'CMadmin@kkwagh.edu.in'
                  : 'faculty@kkwagh.edu.in'));
      final password = customPassword ??
          (role == AppRole.superAdmin
              ? 'SuperAdmin@12345'
              : (role == AppRole.admin ? 'Admin@12345' : 'Faculty@12345'));
      try {
        await login(email, password);
        return;
      } catch (_) {
        // Fall through to offline demo mode
      }
    }

    // Offline Demo Mode
    _currentRole = role;
    _isAuthenticated = false;
    loadSampleDemoData();
    notifyListeners();
  }

  /// Sign out and clear credentials
  Future<void> logout() async {
    if (_isAuthenticated) {
      try {
        await apiService.logout();
      } catch (_) {}
    }
    _currentUser = null;
    _isAuthenticated = false;
    _currentRole = AppRole.none;
    _initDefaults();
    notifyListeners();
  }

  /// Sync academic programs, faculty rosters, and curriculum courses from backend
  Future<void> refreshCatalogFromBackend() async {
    if (!_isAuthenticated) return;
    try {
      final progs = await apiService.fetchPrograms();
      final facs = await apiService.fetchFaculties();
      final crss = await apiService.fetchCourses();

      _programs = progs;
      _faculties = facs;
      _courses = crss;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to refresh catalogs: $e');
    }
  }

  /// Sync all submissions from backend
  Future<void> refreshSubmissionsFromBackend() async {
    if (!_isAuthenticated) return;
    try {
      final subs = await apiService.fetchSubmissions();
      _submissions.clear();
      _submissions.addAll(subs);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to refresh submissions: $e');
    }
  }

  /// Helper if user clicks 'Load Demo Data' in offline mode
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
    final cleanCode = programCode.trim().toUpperCase();
    if (cleanCode.isEmpty) {
      if (!isSuperAdmin && currentUserDepartment != null && currentUserDepartment!.isNotEmpty) {
        final dept = currentUserDepartment!.trim().toUpperCase();
        return _faculties.where((f) => f.programCode.trim().toUpperCase() == dept).toList();
      }
      return _faculties;
    }
    final matched = _faculties
        .where((f) => f.programCode.trim().toUpperCase() == cleanCode)
        .toList();
    if (matched.isNotEmpty) return matched;

    return _faculties.where((f) {
      final facDept = f.programCode.trim().toUpperCase();
      return facDept == cleanCode || (cleanCode.isNotEmpty && facDept.contains(cleanCode));
    }).toList();
  }

  List<CourseInfo> getCourses(String programCode, int semester) {
    final cleanCode = programCode.trim().toUpperCase();
    return _courses
        .where((c) =>
            c.programCode.trim().toUpperCase() == cleanCode &&
            c.semester == semester)
        .toList();
  }

  /// Save submission to backend or locally
  Future<MonitoringSubmission> saveSubmission(MonitoringSubmission submission) async {
    if (_isAuthenticated) {
      try {
        final created = await apiService.createSubmission(submission);
        _submissions.insert(0, created);
        notifyListeners();
        return created;
      } catch (e) {
        debugPrint('Backend save failed, keeping local: $e');
        _submissions.insert(0, submission);
        notifyListeners();
        rethrow;
      }
    } else {
      _submissions.insert(0, submission);
      notifyListeners();
      return submission;
    }
  }

  /// Delete submission from backend and local list
  Future<void> deleteSubmission(String id) async {
    if (_isAuthenticated) {
      try {
        await apiService.deleteSubmission(id);
      } catch (e) {
        debugPrint('Backend delete error: $e');
      }
    }
    _submissions.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  /// Upload Faculty Excel to backend (or parse locally if offline)
  Future<Map<String, dynamic>> uploadFacultyExcel(Uint8List bytes, String filename) async {
    final forcedDept = isSuperAdmin ? null : currentUserDepartment;
    if (_isAuthenticated) {
      final res = await apiService.uploadFacultyExcel(bytes, filename, department: forcedDept);
      await refreshCatalogFromBackend();
      return res;
    } else {
      final parseResult = ExcelService.parseFacultySheet(bytes, forcedDepartment: forcedDept);
      if (parseResult.error != null) {
        throw Exception(parseResult.error);
      }
      updateFacultyAndPrograms(
        newPrograms: parseResult.programs,
        newFaculties: parseResult.faculties,
      );
      return {'count': parseResult.faculties.length};
    }
  }

  /// Upload Subject Excel to backend (or parse locally if offline)
  Future<Map<String, dynamic>> uploadCourseExcel(Uint8List bytes, String filename) async {
    final forcedDept = isSuperAdmin ? null : currentUserDepartment;
    if (_isAuthenticated) {
      final res = await apiService.uploadCourseExcel(bytes, filename, department: forcedDept);
      await refreshCatalogFromBackend();
      return res;
    } else {
      final courses = ExcelService.parseSubjectSheet(bytes, forcedDepartment: forcedDept);
      if (courses.isEmpty) {
        throw Exception('No courses found in the uploaded sheet.');
      }
      updateCourses(courses);
      return {'count': courses.length};
    }
  }

  /// Create user via backend API
  Future<AuthUser> createUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? department,
  }) async {
    return await apiService.createUser(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
      department: department,
    );
  }

  /// Fetch users from backend (Admin / Super Admin)
  Future<List<AuthUser>> fetchUsers({
    String? search,
    String? role,
    String? department,
    int page = 1,
    int limit = 100,
  }) async {
    return await apiService.fetchUsers(
      search: search,
      role: role,
      department: department,
      page: page,
      limit: limit,
    );
  }

  /// Change user role (Super Admin only: USER <-> ADMIN)
  Future<AuthUser> changeUserRole(String userId, String newRole) async {
    return await apiService.changeUserRole(userId, newRole);
  }

  /// Delete a user account permanently (Super Admin or Dept Admin)
  Future<bool> deleteUser(String userId) async {
    return await apiService.deleteUser(userId);
  }

  /// Clear faculties individually (optionally filtered by department)
  Future<int> clearFaculties({String? programCode}) async {
    final count = await apiService.clearFaculties(programCode: programCode);
    await refreshCatalogFromBackend();
    return count;
  }

  /// Clear courses individually (optionally filtered by department)
  Future<int> clearCourses({String? programCode}) async {
    final count = await apiService.clearCourses(programCode: programCode);
    await refreshCatalogFromBackend();
    return count;
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
