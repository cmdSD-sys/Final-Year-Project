import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'api_service.dart';
import 'cm_report_pdf_service.dart';
import 'excel_service.dart';

enum AppRole {
  none,
  user,
  admin,
  superAdmin,
}

class AppState extends ChangeNotifier {
  final ApiService apiService = ApiService();

  DeptInfoModel _currentDeptInfo = DeptInfoModel.defaultSample();
  DeptInfoModel get currentDeptInfo => _currentDeptInfo;

  void updateDeptInfo(DeptInfoModel newInfo) {
    _currentDeptInfo = newInfo;
    notifyListeners();
  }

  CmFullReportSections _cmSections = CmFullReportSections.defaultSample();
  CmFullReportSections get cmSections => _cmSections;

  void updateCmSections(CmFullReportSections newSections) {
    _cmSections = newSections;
    notifyListeners();
  }

  Future<Uint8List> exportCmReportPdf() async {
    return await CmReportPdfService.generateCmReportPdf(data: _currentDeptInfo);
  }

  AppRole _currentRole = AppRole.none;
  ThemeMode _themeMode = ThemeMode.light;
  AppPaletteId _currentPalette = AppPaletteId.teal;
  final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);
  final ValueNotifier<AppPaletteId> paletteNotifier = ValueNotifier(AppPaletteId.teal);
  final ValueNotifier<bool> authStateNotifier = ValueNotifier(false);
  List<ProgramInfo> _programs = [];
  List<FacultyInfo> _faculties = [];
  List<CourseInfo> _courses = [];
  final List<MonitoringSubmission> _submissions = [];

  AuthUser? _currentUser;
  bool _isAuthenticated = false;
  bool _isBackendConnected = true;
  bool _isCheckingBackend = false;

  String _adminName = 'Administrator';
  String _userName = 'Faculty Member';
  Uint8List? _adminPfpBytes;
  Uint8List? _userPfpBytes;

  // Mock in-memory users for frontend mode
  final List<AuthUser> _mockUsers = [
    const AuthUser(
      id: 'admin-cm-001',
      email: 'admin@kkwagh.edu.in',
      fullName: 'CM Administrator',
      role: 'ADMIN',
      department: 'CM',
    ),
    const AuthUser(
      id: 'user-cm-002',
      email: 'user@kkwagh.edu.in',
      fullName: 'CM Faculty Member',
      role: 'USER',
      department: 'CM',
    ),
  ];

  AppRole get currentRole => _currentRole;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  AppPaletteId get currentPalette => _currentPalette;

  List<ProgramInfo> get programs {
    if (!isSuperAdmin &&
        currentUserDepartment != null &&
        currentUserDepartment!.trim().isNotEmpty) {
      final dept = currentUserDepartment!.trim().toUpperCase();
      final filtered =
          _programs.where((p) => p.code.trim().toUpperCase() == dept).toList();
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
    if (AppConfig.useRemoteBackend && _isAuthenticated) {
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
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    themeModeNotifier.value = _themeMode;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      themeModeNotifier.value = _themeMode;
      notifyListeners();
    }
  }

  void setPalette(AppPaletteId palette) {
    if (_currentPalette != palette) {
      _currentPalette = palette;
      Pal.activePalette = palette;
      paletteNotifier.value = palette;
      notifyListeners();
    }
  }

  AppState() {
    // App starts empty by default; data is loaded on demand, via Excel upload, or demo login
  }

  /// Check connectivity to backend API server
  /// (Immediately succeeds in frontend mode)
  Future<bool> checkBackendConnection({bool notify = true}) async {
    if (!AppConfig.useRemoteBackend) {
      _isCheckingBackend = false;
      _isBackendConnected = true;
      if (notify) notifyListeners();
      return true;
    }

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

  /// Authenticate user session
  /// Supports standalone frontend mode (instant mock) or remote REST backend
  Future<void> login(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();

    if (AppConfig.useRemoteBackend) {
      // Live Backend Integration
      final result = await apiService.login(cleanEmail, password);
      _currentUser = result['user'] as AuthUser;
      _isAuthenticated = true;
      _isBackendConnected = true;
      authStateNotifier.value = true;

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
      await refreshCatalogFromBackend();
      await refreshSubmissionsFromBackend();
      return;
    }

    // Pure Frontend Mock Mode (Zero network lag, 100% reliable)
    final isSuper = cleanEmail.contains('superadmin');
    final isAd = cleanEmail.contains('admin');
    final role = isSuper
        ? AppRole.superAdmin
        : (isAd ? AppRole.admin : AppRole.user);

    _currentUser = AuthUser(
      id: isAd ? 'admin-cm-001' : (isSuper ? 'super-001' : 'user-cm-002'),
      email: cleanEmail,
      fullName: isSuper
          ? 'Super Administrator'
          : (isAd ? 'CM Administrator' : 'CM Faculty Member'),
      role: isSuper ? 'SUPER_ADMIN' : (isAd ? 'ADMIN' : 'USER'),
      department: 'CM',
      profilePhotoUrl: null,
    );

    _currentRole = role;
    _isAuthenticated = true;
    _isBackendConnected = true;
    authStateNotifier.value = true;
    if (role == AppRole.admin || role == AppRole.superAdmin) {
      _adminName = _currentUser!.fullName;
    } else {
      _userName = _currentUser!.fullName;
    }

    loadSampleDemoData();
    notifyListeners();
  }

  /// One-click quick login for testing/demo
  Future<void> loginDemo(AppRole role,
      {String? customEmail, String? customPassword}) async {
    final email = customEmail ??
        (role == AppRole.superAdmin
            ? 'superadmin@kkwagh.edu.in'
            : (role == AppRole.admin
                ? 'admin@kkwagh.edu.in'
                : 'user@kkwagh.edu.in'));
    final password = customPassword ??
        (role == AppRole.superAdmin
            ? 'SuperAdmin@12345'
            : (role == AppRole.admin ? 'Admin@12345' : 'User@12345'));
    await login(email, password);
  }

  /// Sign out and clear credentials
  Future<void> logout() async {
    if (AppConfig.useRemoteBackend && _isAuthenticated) {
      try {
        await apiService.logout();
      } catch (_) {}
    }
    _currentUser = null;
    _isAuthenticated = false;
    _currentRole = AppRole.none;
    authStateNotifier.value = false;
    _programs = [];
    _faculties = [];
    _courses = [];
    _submissions.clear();
    notifyListeners();
  }

  /// Sync academic programs, faculty rosters, and curriculum courses from backend
  Future<void> refreshCatalogFromBackend() async {
    if (!AppConfig.useRemoteBackend || !_isAuthenticated) return;
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
    if (!AppConfig.useRemoteBackend || !_isAuthenticated) return;
    try {
      final subs = await apiService.fetchSubmissions();
      _submissions.clear();
      _submissions.addAll(subs);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to refresh submissions: $e');
    }
  }

  /// Load sample catalog and subject datasets
  void loadSampleDemoData() {
    _programs = List.from(ExcelService.getDefaultPrograms());
    _faculties = List.from(ExcelService.getDefaultFaculties());
    _courses = List.from(ExcelService.getDefaultCourses());
    notifyListeners();
  }

  void setRole(AppRole role) {
    _currentRole = role;
    _isAuthenticated = role != AppRole.none;
    authStateNotifier.value = _isAuthenticated;
    notifyListeners();
  }

  List<FacultyInfo> getFacultiesForProgram(String programCode) {
    final cleanCode = programCode.trim().toUpperCase();
    if (cleanCode.isEmpty) {
      if (!isSuperAdmin &&
          currentUserDepartment != null &&
          currentUserDepartment!.isNotEmpty) {
        final dept = currentUserDepartment!.trim().toUpperCase();
        return _faculties
            .where((f) => f.programCode.trim().toUpperCase() == dept)
            .toList();
      }
      return _faculties;
    }
    final matched = _faculties
        .where((f) => f.programCode.trim().toUpperCase() == cleanCode)
        .toList();
    if (matched.isNotEmpty) return matched;

    return _faculties.where((f) {
      final facDept = f.programCode.trim().toUpperCase();
      return facDept == cleanCode ||
          (cleanCode.isNotEmpty && facDept.contains(cleanCode));
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

  /// Save submission to backend or local memory
  Future<MonitoringSubmission> saveSubmission(
      MonitoringSubmission submission) async {
    if (AppConfig.useRemoteBackend && _isAuthenticated) {
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
    if (AppConfig.useRemoteBackend && _isAuthenticated) {
      try {
        await apiService.deleteSubmission(id);
      } catch (e) {
        debugPrint('Backend delete error: $e');
      }
    }
    _submissions.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  /// Upload Faculty Excel to backend (or parse locally if in frontend mode)
  Future<Map<String, dynamic>> uploadFacultyExcel(
      Uint8List bytes, String filename) async {
    final forcedDept = isSuperAdmin ? null : currentUserDepartment;
    if (AppConfig.useRemoteBackend && _isAuthenticated) {
      final res = await apiService.uploadFacultyExcel(bytes, filename,
          department: forcedDept);
      await refreshCatalogFromBackend();
      return res;
    } else {
      final parseResult =
          ExcelService.parseFacultySheet(bytes, forcedDepartment: forcedDept);
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

  /// Upload Subject Excel to backend (or parse locally if in frontend mode)
  Future<Map<String, dynamic>> uploadCourseExcel(
      Uint8List bytes, String filename) async {
    final forcedDept = isSuperAdmin ? null : currentUserDepartment;
    if (AppConfig.useRemoteBackend && _isAuthenticated) {
      final res = await apiService.uploadCourseExcel(bytes, filename,
          department: forcedDept);
      await refreshCatalogFromBackend();
      return res;
    } else {
      final courses =
          ExcelService.parseSubjectSheet(bytes, forcedDepartment: forcedDept);
      if (courses.isEmpty) {
        throw Exception('No courses found in the uploaded sheet.');
      }
      updateCourses(courses);
      return {'count': courses.length};
    }
  }

  /// Create user via backend API or local state
  Future<AuthUser> createUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? department,
  }) async {
    if (AppConfig.useRemoteBackend && _isAuthenticated) {
      return await apiService.createUser(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        department: department,
      );
    }
    final newUser = AuthUser(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      email: email.trim().toLowerCase(),
      fullName: fullName.trim(),
      role: role.toUpperCase(),
      department: department ?? 'CM',
    );
    _mockUsers.add(newUser);
    notifyListeners();
    return newUser;
  }

  /// Fetch users from backend or local mock list
  Future<List<AuthUser>> fetchUsers({
    String? search,
    String? role,
    String? department,
    int page = 1,
    int limit = 100,
  }) async {
    if (AppConfig.useRemoteBackend && _isAuthenticated) {
      return await apiService.fetchUsers(
        search: search,
        role: role,
        department: department,
        page: page,
        limit: limit,
      );
    }
    var list = List<AuthUser>.from(_mockUsers);
    if (search != null && search.isNotEmpty) {
      final s = search.toLowerCase();
      list = list
          .where((u) =>
              u.fullName.toLowerCase().contains(s) ||
              u.email.toLowerCase().contains(s))
          .toList();
    }
    if (role != null && role.isNotEmpty) {
      list = list.where((u) => u.role.toUpperCase() == role.toUpperCase()).toList();
    }
    return list;
  }

  /// Change user role (Super Admin only: USER <-> ADMIN)
  Future<AuthUser> changeUserRole(String userId, String newRole) async {
    if (AppConfig.useRemoteBackend && _isAuthenticated) {
      return await apiService.changeUserRole(userId, newRole);
    }
    final idx = _mockUsers.indexWhere((u) => u.id == userId);
    if (idx != -1) {
      final old = _mockUsers[idx];
      final updated = AuthUser(
        id: old.id,
        email: old.email,
        fullName: old.fullName,
        role: newRole.toUpperCase(),
        department: old.department,
        profilePhotoUrl: old.profilePhotoUrl,
      );
      _mockUsers[idx] = updated;
      notifyListeners();
      return updated;
    }
    throw Exception('User not found.');
  }

  /// Delete a user account permanently
  Future<bool> deleteUser(String userId) async {
    if (AppConfig.useRemoteBackend && _isAuthenticated) {
      return await apiService.deleteUser(userId);
    }
    _mockUsers.removeWhere((u) => u.id == userId);
    notifyListeners();
    return true;
  }

  /// Clear faculties individually (optionally filtered by department)
  Future<int> clearFaculties({String? programCode}) async {
    if (AppConfig.useRemoteBackend && _isAuthenticated) {
      final count = await apiService.clearFaculties(programCode: programCode);
      await refreshCatalogFromBackend();
      return count;
    }
    int count = _faculties.length;
    if (programCode != null && programCode.isNotEmpty) {
      final before = _faculties.length;
      _faculties = _faculties
          .where((f) =>
              f.programCode.toUpperCase() != programCode.toUpperCase())
          .toList();
      count = before - _faculties.length;
    } else {
      _faculties = [];
    }
    notifyListeners();
    return count;
  }

  /// Clear courses individually (optionally filtered by department)
  Future<int> clearCourses({String? programCode}) async {
    if (AppConfig.useRemoteBackend && _isAuthenticated) {
      final count = await apiService.clearCourses(programCode: programCode);
      await refreshCatalogFromBackend();
      return count;
    }
    int count = _courses.length;
    if (programCode != null && programCode.isNotEmpty) {
      final before = _courses.length;
      _courses = _courses
          .where(
              (c) => c.programCode.toUpperCase() != programCode.toUpperCase())
          .toList();
      count = before - _courses.length;
    } else {
      _courses = [];
    }
    notifyListeners();
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
    loadSampleDemoData();
  }
}
