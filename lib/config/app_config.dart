/// Application Configuration.
///
/// Controls environment variables, backend connectivity toggles, and base URLs.
/// To switch to a live backend once developed by your backend teammate, change
/// [useRemoteBackend] to `true` and update [remoteApiBaseUrl].
class AppConfig {
  /// Set to `false` for standalone frontend execution with reliable mock data.
  /// Set to `true` when the remote backend API server is running.
  static const bool useRemoteBackend = false;

  /// Base URL of the backend REST API server.
  static const String remoteApiBaseUrl = 'http://localhost:5000/api/v1';

  /// Base URL for media and uploaded file assets (NBA certificates, avatars, excel sheets).
  static const String storageBaseUrl = 'http://localhost:5000/uploads';

  /// Default timeout for network calls when running in remote backend mode.
  static const Duration requestTimeout = Duration(seconds: 10);
}
