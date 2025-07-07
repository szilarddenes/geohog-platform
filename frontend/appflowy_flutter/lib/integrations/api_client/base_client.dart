import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflowy_result/appflowy_result.dart';
import 'package:appflowy_backend/log.dart';

/// Base API client for GeoHog private services
/// This is a public interface layer - contains NO geological expertise
abstract class BaseApiClient {
  BaseApiClient({
    required this.baseUrl,
    required this.serviceName,
    this.timeout = const Duration(seconds: 30),
  });

  final String baseUrl;
  final String serviceName;
  final Duration timeout;

  // HTTP client instance
  final http.Client _client = http.Client();

  /// Common headers for all requests
  Map<String, String> get _commonHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'GeoHog-Client/1.0',
      };

  /// GET request with error handling
  Future<FlowyResult<Map<String, dynamic>, String>> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    return _executeRequest(() async {
      final uri = _buildUri(endpoint, queryParams);
      final response = await _client.get(
        uri,
        headers: {..._commonHeaders, ...?headers},
      ).timeout(timeout);

      return _handleResponse(response);
    });
  }

  /// POST request with error handling
  Future<FlowyResult<Map<String, dynamic>, String>> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    return _executeRequest(() async {
      final uri = _buildUri(endpoint, queryParams);
      final response = await _client
          .post(
            uri,
            headers: {..._commonHeaders, ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    });
  }

  /// PUT request with error handling
  Future<FlowyResult<Map<String, dynamic>, String>> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    return _executeRequest(() async {
      final uri = _buildUri(endpoint, queryParams);
      final response = await _client
          .put(
            uri,
            headers: {..._commonHeaders, ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeout);

      return _handleResponse(response);
    });
  }

  /// DELETE request with error handling
  Future<FlowyResult<Map<String, dynamic>, String>> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    return _executeRequest(() async {
      final uri = _buildUri(endpoint, queryParams);
      final response = await _client.delete(
        uri,
        headers: {..._commonHeaders, ...?headers},
      ).timeout(timeout);

      return _handleResponse(response);
    });
  }

  /// Upload file with multipart request
  Future<FlowyResult<Map<String, dynamic>, String>> uploadFile(
    String endpoint,
    String fileFieldName,
    List<int> fileBytes,
    String fileName, {
    Map<String, String>? headers,
    Map<String, String>? fields,
  }) async {
    return _executeRequest(() async {
      final uri = _buildUri(endpoint);
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll({..._commonHeaders, ...?headers});

      // Add file
      request.files.add(
        http.MultipartFile.fromBytes(
          fileFieldName,
          fileBytes,
          filename: fileName,
        ),
      );

      // Add fields
      if (fields != null) {
        request.fields.addAll(fields);
      }

      final streamedResponse = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    });
  }

  /// Execute request with common error handling
  Future<FlowyResult<Map<String, dynamic>, String>> _executeRequest(
    Future<FlowyResult<Map<String, dynamic>, String>> Function() request,
  ) async {
    try {
      return await request();
    } catch (e) {
      Log.error('$serviceName API error: $e');
      return FlowyResult.failure('Service temporarily unavailable: $e');
    }
  }

  /// Handle HTTP response
  FlowyResult<Map<String, dynamic>, String> _handleResponse(
      http.Response response) {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return FlowyResult.success(<String, dynamic>{});
        }

        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          return FlowyResult.success(data);
        } else {
          return FlowyResult.success({'data': data});
        }
      } else {
        Log.error(
            '$serviceName API error: ${response.statusCode} - ${response.body}');
        return FlowyResult.failure(
          'Service error (${response.statusCode}): ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      Log.error('$serviceName response parsing error: $e');
      return FlowyResult.failure('Invalid response format');
    }
  }

  /// Build URI with query parameters
  Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParams]) {
    var uri = Uri.parse('$baseUrl$endpoint');

    if (queryParams != null && queryParams.isNotEmpty) {
      final validParams = <String, String>{};
      queryParams.forEach((key, value) {
        if (value != null) {
          validParams[key] = value.toString();
        }
      });

      if (validParams.isNotEmpty) {
        uri = uri.replace(queryParameters: validParams);
      }
    }

    return uri;
  }

  /// Clean up resources
  void dispose() {
    _client.close();
  }
}

/// Service availability checker
class ServiceHealthChecker {
  static Future<bool> isServiceAvailable(String baseUrl) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      Log.info('Service health check failed: $e');
      return false;
    }
  }
}
