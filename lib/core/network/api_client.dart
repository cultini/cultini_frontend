import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../errors/failure.dart';
import 'network_info.dart';
import '../constants/end_points.dart';

class ApiClient {
  final http.Client _client;
  final NetworkInfo _networkInfo;

  /// When set, this base URL is used instead of the default auth backend.
  /// Lets a single [ApiClient] class serve multiple backends (e.g. the AI
  /// instance points at [EndPoints.aiBaseUrl]).
  final String? _baseUrlOverride;

  String? _accessToken;

  ApiClient({
    required http.Client client,
    required NetworkInfo networkInfo,
    String? baseUrlOverride,
  }) : _client = client,
       _networkInfo = networkInfo,
       _baseUrlOverride = baseUrlOverride;

  String get baseUrl => _baseUrlOverride ?? EndPoints.authBaseUrl;

  void setAccessToken(String token) => _accessToken = token;
  void clearAccessToken() => _accessToken = null;

  String? get currentAccessToken => _accessToken;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
  };

  Future<void> checkConnection() async {
    if (!await _networkInfo.isConnected) {
      throw const NetworkFailure(message: 'No internet connection');
    }
  }

  // ── Existing GET, POST, POST void, DELETE methods untouched ───────────────
  Future<dynamic> get(String endpoint) async {
    await checkConnection();
    final response = await _client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    await checkConnection();
    final response = await _client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: requiresAuth ? _headers : {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<void> postVoid(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    await checkConnection();
    final response = await _client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: requiresAuth ? _headers : {'Content-Type': 'application/json'},
      body: body != null ? jsonEncode(body) : null,
    );
    _handleVoidResponse(response);
  }

  Future<void> delete(String endpoint) async {
    await checkConnection();
    final response = await _client.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );
    _handleVoidResponse(response);
  }

  void _handleVoidResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 204) return;
    switch (response.statusCode) {
      case 400:
      case 422:
        throw ServerFailure(message: _parseError(response));
      case 401:
        throw const UnauthorizedFailure(
          message: 'Session expired. Please log in again.',
        );
      case 403:
        throw const ServerFailure(message: 'Access denied.');
      case 404:
        throw const ServerFailure(message: 'Resource not found.');
      case 429:
        throw const ServerFailure(
          message: 'Too many attempts. Try again later.',
        );
      case 500:
        throw const ServerFailure(message: 'Server error. Try again later.');
      default:
        throw ServerFailure(message: _parseError(response));
    }
  }

  // ── New: POST multipart for face enrollment only ──────────────────────────
  Future<void> postMultipart(
    String endpoint, {
    required List<File> files,
    required List<String> fieldNames,
    bool requiresAuth = false,
  }) async {
    await checkConnection();
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);

    if (requiresAuth && currentAccessToken != null) {
      request.headers['Authorization'] = 'Bearer $currentAccessToken';
    }

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();

      request.files.add(
        http.MultipartFile(
          fieldNames[i],
          stream,
          length,
          filename: file.path.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 401) {
      throw const UnauthorizedFailure(
        message: 'Session expired. Please log in again.',
      );
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerFailure(
        message: 'Failed to upload photos. Please try again.',
      );
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    switch (response.statusCode) {
      case 400:
      case 422:
        throw ServerFailure(message: _parseError(response));
      case 401:
        throw const UnauthorizedFailure(
          message: 'Session expired. Please log in again.',
        );
      case 403:
        throw const ServerFailure(message: 'Access denied.');
      case 404:
        // Auth endpoints use 404 with a meaningful body (e.g. "User not
        // found"); surface it instead of a generic message.
        throw ServerFailure(message: _parseError(response));
      case 429:
        throw const ServerFailure(
          message: 'Too many attempts. Try again later.',
        );
      case 500:
        throw const ServerFailure(message: 'Server error. Try again later.');
      default:
        throw ServerFailure(message: _parseError(response));
    }
  }

  String _parseError(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['message'] as String? ??
          body['error'] as String? ??
          'Unknown server error';
    } catch (_) {
      return 'Server error ${response.statusCode}';
    }
  }
}
