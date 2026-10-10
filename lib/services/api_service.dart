import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/models.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String _baseUrl = 'http://localhost:5000/api/v1';

  String get baseUrl => _baseUrl;
  set baseUrl(String url) {
    var trimmed = url.trim();
    if (trimmed.endsWith('/')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    _baseUrl = trimmed;
  }

  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get hasValidToken => _accessToken != null && _accessToken!.isNotEmpty;

  void setTokens({required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
  }

  Map<String, String> _headers({bool requireAuth = true}) {
    final map = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    if (requireAuth && _accessToken != null) {
      map['Authorization'] = 'Bearer $_accessToken';
    }
    return map;
  }

  /// Check whether the backend API server is reachable
  Future<bool> checkHealth() async {
    try {
      final uri = Uri.parse('$_baseUrl/health');
      final response = await http.get(uri).timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ==========================================
  // AUTHENTICATION ENDPOINTS
  // ==========================================

  /// Authenticate with email & password
  Future<Map<String, dynamic>> login(String email, String password) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    final response = await http.post(
      uri,
      headers: _headers(requireAuth: false),
      body: jsonEncode({
        'email': email.trim().toLowerCase(),
        'password': password,
      }),
    );

    final data = _parseJson(response);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final inner = data['data'] as Map<String, dynamic>;
      final user = AuthUser.fromJson(inner['user'] as Map<String, dynamic>);
      final tokens = AuthTokens.fromJson(inner['tokens'] as Map<String, dynamic>);

      setTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );

      return {'user': user, 'tokens': tokens};
    } else {
      throw ApiException(
        data['message'] as String? ?? 'Invalid credentials or login failed.',
        response.statusCode,
      );
    }
  }

  /// Refresh JWT Access Token using the refresh token
  Future<bool> refreshTokens() async {
    if (_refreshToken == null) return false;
    try {
      final uri = Uri.parse('$_baseUrl/auth/refresh');
      final response = await http.post(
        uri,
        headers: _headers(requireAuth: false),
        body: jsonEncode({'refreshToken': _refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = _parseJson(response);
        final inner = data['data'] as Map<String, dynamic>;
        final tokens = AuthTokens.fromJson(inner['tokens'] as Map<String, dynamic>);
        setTokens(
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
        );
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Terminate session and invalidate refresh token
  Future<void> logout() async {
    if (_refreshToken != null) {
      try {
        final uri = Uri.parse('$_baseUrl/auth/logout');
        await http.post(
          uri,
          headers: _headers(requireAuth: true),
          body: jsonEncode({'refreshToken': _refreshToken}),
        );
      } catch (_) {}
    }
    clearTokens();
  }

  /// Get current user profile
  Future<AuthUser?> getMe() async {
    if (!hasValidToken) return null;
    final uri = Uri.parse('$_baseUrl/auth/me');
    final response = await _authenticatedGet(uri);
    if (response.statusCode == 200) {
      final data = _parseJson(response);
      return AuthUser.fromJson(data['data'] as Map<String, dynamic>);
    }
    return null;
  }

  // ==========================================
  // CATALOG ENDPOINTS
  // ==========================================

  /// Get all registered academic programs
  Future<List<ProgramInfo>> fetchPrograms() async {
    final uri = Uri.parse('$_baseUrl/catalogs/programs');
    final response = await _authenticatedGet(uri);
    if (response.statusCode == 200) {
      final json = _parseJson(response);
      final list = json['data'] as List<dynamic>? ?? [];
      return list
          .map((item) => ProgramInfo.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw ApiException('Failed to fetch programs (${response.statusCode})', response.statusCode);
  }

  /// Get faculty list (optionally filtered by programCode)
  Future<List<FacultyInfo>> fetchFaculties({String? programCode}) async {
    var url = '$_baseUrl/catalogs/faculties';
    if (programCode != null && programCode.trim().isNotEmpty) {
      url += '?programCode=${Uri.encodeComponent(programCode.trim())}';
    }
    final response = await _authenticatedGet(Uri.parse(url));
    if (response.statusCode == 200) {
      final json = _parseJson(response);
      final list = json['data'] as List<dynamic>? ?? [];
      return list
          .map((item) => FacultyInfo.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw ApiException('Failed to fetch faculty list (${response.statusCode})', response.statusCode);
  }

  /// Get curriculum courses (optionally filtered by programCode and semester)
  Future<List<CourseInfo>> fetchCourses({String? programCode, int? semester}) async {
    final queryParams = <String, String>{};
    if (programCode != null && programCode.trim().isNotEmpty) {
      queryParams['programCode'] = programCode.trim();
    }
    if (semester != null) {
      queryParams['semester'] = semester.toString();
    }

    final uri = Uri.parse('$_baseUrl/catalogs/courses').replace(queryParameters: queryParams.isEmpty ? null : queryParams);
    final response = await _authenticatedGet(uri);
    if (response.statusCode == 200) {
      final json = _parseJson(response);
      final list = json['data'] as List<dynamic>? ?? [];
      return list
          .map((item) => CourseInfo.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw ApiException('Failed to fetch courses (${response.statusCode})', response.statusCode);
  }

  /// Upload Faculty & Program Master Excel file directly to backend
  Future<Map<String, dynamic>> uploadFacultyExcel(Uint8List bytes, String filename, {String? department}) async {
    var uri = Uri.parse('$_baseUrl/catalogs/upload-faculty-excel');
    if (department != null && department.trim().isNotEmpty) {
      uri = uri.replace(queryParameters: {'department': department.trim().toUpperCase()});
    }
    final request = http.MultipartRequest('POST', uri);
    if (_accessToken != null) {
      request.headers['Authorization'] = 'Bearer $_accessToken';
    }
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: MediaType('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    final json = _parseJson(response);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json['data'] as Map<String, dynamic>? ?? json;
    }
    throw ApiException(
      json['message'] as String? ?? 'Failed to upload faculty Excel sheet.',
      response.statusCode,
    );
  }

  /// Upload Subject & Curriculum Master Excel file directly to backend
  Future<Map<String, dynamic>> uploadCourseExcel(Uint8List bytes, String filename, {String? department}) async {
    var uri = Uri.parse('$_baseUrl/catalogs/upload-course-excel');
    if (department != null && department.trim().isNotEmpty) {
      uri = uri.replace(queryParameters: {'department': department.trim().toUpperCase()});
    }
    final request = http.MultipartRequest('POST', uri);
    if (_accessToken != null) {
      request.headers['Authorization'] = 'Bearer $_accessToken';
    }
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: MediaType('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    final json = _parseJson(response);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json['data'] as Map<String, dynamic>? ?? json;
    }
    throw ApiException(
      json['message'] as String? ?? 'Failed to upload subject Excel sheet.',
      response.statusCode,
    );
  }

  /// Clear faculties individually (all or by department)
  Future<int> clearFaculties({String? programCode}) async {
    var url = '$_baseUrl/catalogs/faculties';
    if (programCode != null && programCode.trim().isNotEmpty) {
      url += '?programCode=${Uri.encodeComponent(programCode.trim().toUpperCase())}';
    }
    final response = await _authenticatedDelete(Uri.parse(url));
    final json = _parseJson(response);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return (json['count'] as num?)?.toInt() ?? 0;
    }
    throw ApiException(
      json['message'] as String? ?? 'Failed to clear faculties.',
      response.statusCode,
    );
  }

  /// Clear courses individually (all or by department)
  Future<int> clearCourses({String? programCode}) async {
    var url = '$_baseUrl/catalogs/courses';
    if (programCode != null && programCode.trim().isNotEmpty) {
      url += '?programCode=${Uri.encodeComponent(programCode.trim().toUpperCase())}';
    }
    final response = await _authenticatedDelete(Uri.parse(url));
    final json = _parseJson(response);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return (json['count'] as num?)?.toInt() ?? 0;
    }
    throw ApiException(
      json['message'] as String? ?? 'Failed to clear courses.',
      response.statusCode,
    );
  }

  // ==========================================
  // SUBMISSIONS ENDPOINTS
  // ==========================================

  /// Fetch submissions (Admin gets all, Faculty gets own)
  Future<List<MonitoringSubmission>> fetchSubmissions({
    String? programCode,
    String? semesterType,
  }) async {
    final queryParams = <String, String>{};
    if (programCode != null && programCode.trim().isNotEmpty) {
      queryParams['programCode'] = programCode.trim();
    }
    if (semesterType != null && semesterType.trim().isNotEmpty) {
      queryParams['semesterType'] = semesterType.trim().toUpperCase();
    }

    final uri = Uri.parse('$_baseUrl/submissions').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    final response = await _authenticatedGet(uri);
    if (response.statusCode == 200) {
      final json = _parseJson(response);
      final list = json['data'] as List<dynamic>? ?? [];
      return list
          .map((item) => MonitoringSubmission.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw ApiException('Failed to fetch submissions (${response.statusCode})', response.statusCode);
  }

  /// Save new monitoring submission
  Future<MonitoringSubmission> createSubmission(MonitoringSubmission submission) async {
    final uri = Uri.parse('$_baseUrl/submissions');
    final payload = {
      'programName': submission.programName,
      'programCode': submission.programCode,
      'semesterType': submission.semesterType.toUpperCase(),
      'nbaStatus': submission.nbaStatus,
      'weeksDone': submission.weeksDone,
      'weeksDoneYear1': submission.weeksDoneYear1,
      'weeksDoneYear2': submission.weeksDoneYear2,
      'weeksDoneYear3': submission.weeksDoneYear3,
      'rows': submission.rows.map((r) => r.toJson()).toList(),
    };

    final response = await _authenticatedPost(uri, payload);
    final json = _parseJson(response);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return MonitoringSubmission.fromJson(json['data'] as Map<String, dynamic>);
    }
    throw ApiException(
      json['message'] as String? ?? 'Failed to save submission.',
      response.statusCode,
    );
  }

  /// Delete a submission (Admin only)
  Future<bool> deleteSubmission(String id) async {
    final uri = Uri.parse('$_baseUrl/submissions/$id');
    final response = await _authenticatedDelete(uri);
    if (response.statusCode == 200) {
      return true;
    }
    final json = _parseJson(response);
    throw ApiException(
      json['message'] as String? ?? 'Failed to delete submission.',
      response.statusCode,
    );
  }

  /// Download official filled Format.docx generated on the server
  Future<Uint8List> exportSubmissionDocx(String id) async {
    final uri = Uri.parse('$_baseUrl/submissions/$id/export-docx');
    final response = await _authenticatedGet(uri);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    throw ApiException(
      'Server failed to generate Word document (${response.statusCode})',
      response.statusCode,
    );
  }

  // ==========================================
  // ==========================================
  // USER MANAGEMENT ENDPOINTS (ADMIN & SUPER ADMIN)
  // ==========================================

  /// Create new faculty or administrator user in database
  Future<AuthUser> createUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? department,
  }) async {
    final uri = Uri.parse('$_baseUrl/users');
    final payload = <String, dynamic>{
      'fullName': fullName.trim(),
      'email': email.trim().toLowerCase(),
      'password': password,
      'role': role.toUpperCase() == 'ADMIN' ? 'ADMIN' : (role.toUpperCase() == 'SUPER_ADMIN' ? 'SUPER_ADMIN' : 'USER'),
    };
    if (department != null && department.trim().isNotEmpty) {
      payload['department'] = department.trim().toUpperCase();
    }

    final response = await _authenticatedPost(uri, payload);
    final json = _parseJson(response);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return AuthUser.fromJson(json['data'] as Map<String, dynamic>);
    }
    throw ApiException(
      json['message'] as String? ?? 'Failed to create user.',
      response.statusCode,
    );
  }

  /// List users with optional search, role, and department filters
  Future<List<AuthUser>> fetchUsers({
    String? search,
    String? role,
    String? department,
    int page = 1,
    int limit = 100,
  }) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }
    if (role != null && role.trim().isNotEmpty) {
      queryParams['role'] = role.trim();
    }
    if (department != null && department.trim().isNotEmpty) {
      queryParams['department'] = department.trim();
    }

    final uri = Uri.parse('$_baseUrl/users').replace(queryParameters: queryParams);
    final response = await _authenticatedGet(uri);
    final json = _parseJson(response);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final list = json['data'] as List<dynamic>? ?? [];
      return list.map((u) => AuthUser.fromJson(u as Map<String, dynamic>)).toList();
    }
    throw ApiException(
      json['message'] as String? ?? 'Failed to fetch users.',
      response.statusCode,
    );
  }

  /// Change a user's role (Super Admin only: USER <-> ADMIN)
  Future<AuthUser> changeUserRole(String userId, String newRole) async {
    final uri = Uri.parse('$_baseUrl/users/$userId/role');
    final payload = {'role': newRole.toUpperCase()};
    final response = await _authenticatedPatch(uri, payload);
    final json = _parseJson(response);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return AuthUser.fromJson(json['data'] as Map<String, dynamic>);
    }
    throw ApiException(
      json['message'] as String? ?? 'Failed to update user authority.',
      response.statusCode,
    );
  }

  /// Delete a user account permanently (Super Admin or Dept Admin)
  Future<bool> deleteUser(String userId) async {
    final uri = Uri.parse('$_baseUrl/users/$userId');
    final response = await _authenticatedDelete(uri);
    final json = _parseJson(response);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    }
    throw ApiException(
      json['message'] as String? ?? 'Failed to delete user.',
      response.statusCode,
    );
  }

  /// Upload user profile picture avatar to backend
  Future<String?> uploadAvatar(Uint8List bytes, String filename) async {
    final uri = Uri.parse('$_baseUrl/users/me/avatar');
    final request = http.MultipartRequest('POST', uri);
    if (_accessToken != null) {
      request.headers['Authorization'] = 'Bearer $_accessToken';
    }

    final ext = filename.toLowerCase().endsWith('.png')
        ? 'png'
        : (filename.toLowerCase().endsWith('.webp') ? 'webp' : 'jpeg');

    request.files.add(
      http.MultipartFile.fromBytes(
        'avatar',
        bytes,
        filename: filename,
        contentType: MediaType('image', ext),
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    final json = _parseJson(response);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json['data'] as Map<String, dynamic>? ?? {};
      return data['profilePhotoUrl'] as String?;
    }
    throw ApiException(
      json['message'] as String? ?? 'Failed to upload profile picture.',
      response.statusCode,
    );
  }

  // ==========================================
  // INTERNAL HELPERS & REFRESH ROTATION
  // ==========================================

  Future<http.Response> _authenticatedGet(Uri uri) async {
    var response = await http.get(uri, headers: _headers(requireAuth: true));
    if (response.statusCode == 401 && _refreshToken != null) {
      final refreshed = await refreshTokens();
      if (refreshed) {
        response = await http.get(uri, headers: _headers(requireAuth: true));
      }
    }
    return response;
  }

  Future<http.Response> _authenticatedPost(Uri uri, Object body) async {
    var response = await http.post(
      uri,
      headers: _headers(requireAuth: true),
      body: jsonEncode(body),
    );
    if (response.statusCode == 401 && _refreshToken != null) {
      final refreshed = await refreshTokens();
      if (refreshed) {
        response = await http.post(
          uri,
          headers: _headers(requireAuth: true),
          body: jsonEncode(body),
        );
      }
    }
    return response;
  }

  Future<http.Response> _authenticatedPatch(Uri uri, Object body) async {
    var response = await http.patch(
      uri,
      headers: _headers(requireAuth: true),
      body: jsonEncode(body),
    );
    if (response.statusCode == 401 && _refreshToken != null) {
      final refreshed = await refreshTokens();
      if (refreshed) {
        response = await http.patch(
          uri,
          headers: _headers(requireAuth: true),
          body: jsonEncode(body),
        );
      }
    }
    return response;
  }

  Future<http.Response> _authenticatedDelete(Uri uri) async {
    var response = await http.delete(uri, headers: _headers(requireAuth: true));
    if (response.statusCode == 401 && _refreshToken != null) {
      final refreshed = await refreshTokens();
      if (refreshed) {
        response = await http.delete(uri, headers: _headers(requireAuth: true));
      }
    }
    return response;
  }

  Map<String, dynamic> _parseJson(http.Response response) {
    try {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      return {'message': response.body};
    }
  }
}
