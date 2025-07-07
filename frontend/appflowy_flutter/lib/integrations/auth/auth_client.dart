import 'dart:convert';
import 'package:appflowy_result/appflowy_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appflowy_backend/log.dart';

/// Authentication client for private GeoHog services
/// Manages API keys and tokens securely
class GeoHogAuthClient {
  static const String _apiKeyPrefix = 'geohog_api_key_';
  static const String _tokenPrefix = 'geohog_token_';
  static const String _refreshTokenPrefix = 'geohog_refresh_token_';

  /// Store API key for a specific service
  static Future<FlowyResult<void, String>> storeApiKey(
    String serviceName,
    String apiKey,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_apiKeyPrefix$serviceName', apiKey);
      Log.info('API key stored for service: $serviceName');
      return FlowyResult.success(null);
    } catch (e) {
      Log.error('Failed to store API key for $serviceName: $e');
      return FlowyResult.failure('Failed to store API key');
    }
  }

  /// Get API key for a specific service
  static Future<FlowyResult<String, String>> getApiKey(
      String serviceName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('$_apiKeyPrefix$serviceName');

      if (apiKey == null || apiKey.isEmpty) {
        return FlowyResult.failure('No API key found for $serviceName');
      }

      return FlowyResult.success(apiKey);
    } catch (e) {
      Log.error('Failed to retrieve API key for $serviceName: $e');
      return FlowyResult.failure('Failed to retrieve API key');
    }
  }

  /// Store authentication token
  static Future<FlowyResult<void, String>> storeToken(
    String serviceName,
    String token,
    String? refreshToken,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_tokenPrefix$serviceName', token);

      if (refreshToken != null) {
        await prefs.setString('$_refreshTokenPrefix$serviceName', refreshToken);
      }

      Log.info('Token stored for service: $serviceName');
      return FlowyResult.success(null);
    } catch (e) {
      Log.error('Failed to store token for $serviceName: $e');
      return FlowyResult.failure('Failed to store token');
    }
  }

  /// Get authentication token
  static Future<FlowyResult<String, String>> getToken(
      String serviceName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('$_tokenPrefix$serviceName');

      if (token == null || token.isEmpty) {
        return FlowyResult.failure('No token found for $serviceName');
      }

      return FlowyResult.success(token);
    } catch (e) {
      Log.error('Failed to retrieve token for $serviceName: $e');
      return FlowyResult.failure('Failed to retrieve token');
    }
  }

  /// Get refresh token
  static Future<FlowyResult<String, String>> getRefreshToken(
      String serviceName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('$_refreshTokenPrefix$serviceName');

      if (refreshToken == null || refreshToken.isEmpty) {
        return FlowyResult.failure('No refresh token found for $serviceName');
      }

      return FlowyResult.success(refreshToken);
    } catch (e) {
      Log.error('Failed to retrieve refresh token for $serviceName: $e');
      return FlowyResult.failure('Failed to retrieve refresh token');
    }
  }

  /// Clear all authentication data for a service
  static Future<FlowyResult<void, String>> clearServiceAuth(
      String serviceName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_apiKeyPrefix$serviceName');
      await prefs.remove('$_tokenPrefix$serviceName');
      await prefs.remove('$_refreshTokenPrefix$serviceName');

      Log.info('Authentication data cleared for service: $serviceName');
      return FlowyResult.success(null);
    } catch (e) {
      Log.error('Failed to clear auth data for $serviceName: $e');
      return FlowyResult.failure('Failed to clear authentication data');
    }
  }

  /// Clear all GeoHog authentication data
  static Future<FlowyResult<void, String>> clearAllAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs
          .getKeys()
          .where((key) =>
              key.startsWith(_apiKeyPrefix) ||
              key.startsWith(_tokenPrefix) ||
              key.startsWith(_refreshTokenPrefix))
          .toList();

      for (final key in keys) {
        await prefs.remove(key);
      }

      Log.info('All GeoHog authentication data cleared');
      return FlowyResult.success(null);
    } catch (e) {
      Log.error('Failed to clear all auth data: $e');
      return FlowyResult.failure('Failed to clear authentication data');
    }
  }

  /// Get authentication headers for a service
  static Future<Map<String, String>> getAuthHeaders(String serviceName) async {
    final headers = <String, String>{};

        // Try to get API key first
    final apiKeyResult = await getApiKey(serviceName);
    if (apiKeyResult.isSuccess) {
      final apiKey = apiKeyResult.toNullable();
      if (apiKey != null) {
        headers['X-API-Key'] = apiKey;
        return headers;
      }
    }
    
    // Fall back to token-based auth
    final tokenResult = await getToken(serviceName);
    if (tokenResult.isSuccess) {
      final token = tokenResult.toNullable();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
        return headers;
      }
    }
    
    // No authentication available
    Log.warn('No authentication available for service: $serviceName');
    return headers;
  }

  /// Check if service is authenticated
  static Future<bool> isServiceAuthenticated(String serviceName) async {
    final apiKeyResult = await getApiKey(serviceName);
    if (apiKeyResult.isSuccess) return true;

    final tokenResult = await getToken(serviceName);
    if (tokenResult.isSuccess) return true;

    return false;
  }
}

/// Authentication configuration for services
class GeoHogAuthConfig {
  const GeoHogAuthConfig({
    required this.serviceName,
    required this.baseUrl,
    this.authType = AuthType.apiKey,
    this.requiresAuth = true,
  });

  final String serviceName;
  final String baseUrl;
  final AuthType authType;
  final bool requiresAuth;

  static const seismicProcessor = GeoHogAuthConfig(
    serviceName: 'seismic_processor',
    baseUrl: 'https://seismic-api.geohog.com',
    authType: AuthType.apiKey,
  );

  static const wellAnalyzer = GeoHogAuthConfig(
    serviceName: 'well_analyzer',
    baseUrl: 'https://well-api.geohog.com',
    authType: AuthType.apiKey,
  );

  static const coreAnalyzer = GeoHogAuthConfig(
    serviceName: 'core_analyzer',
    baseUrl: 'https://core-api.geohog.com',
    authType: AuthType.apiKey,
  );

  static const aiAssistant = GeoHogAuthConfig(
    serviceName: 'ai_assistant',
    baseUrl: 'https://ai-api.geohog.com',
    authType: AuthType.bearer,
  );

  static const mapService = GeoHogAuthConfig(
    serviceName: 'map_service',
    baseUrl: 'https://map-api.geohog.com',
    authType: AuthType.apiKey,
  );

  /// Get all configured services
  static List<GeoHogAuthConfig> get allServices => [
        seismicProcessor,
        wellAnalyzer,
        coreAnalyzer,
        aiAssistant,
        mapService,
      ];
}

enum AuthType {
  apiKey,
  bearer,
  basic,
}
