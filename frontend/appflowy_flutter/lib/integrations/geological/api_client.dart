import 'package:appflowy_result/appflowy_result.dart';
import '../api_client/base_client.dart';
import '../auth/auth_client.dart';

/// Geological API client - Public interface layer only
/// This connects to private geological services but contains NO geological expertise
class GeologicalApiClient extends BaseApiClient {
  GeologicalApiClient._({required String baseUrl})
      : super(baseUrl: baseUrl, serviceName: 'geological');

  static GeologicalApiClient? _instance;
  static GeologicalApiClient get instance {
    _instance ??= GeologicalApiClient._(
      baseUrl: 'https://api.geohog.com', // Configure in production
    );
    return _instance!;
  }

  /// Initialize client with custom base URL
  static void initialize(String baseUrl) {
    _instance = GeologicalApiClient._(baseUrl: baseUrl);
  }

  /// Get authentication headers for geological requests
  Future<Map<String, String>> _getGeoAuthHeaders() async {
    final authHeaders = await GeoHogAuthClient.getAuthHeaders('geological');
    return authHeaders;
  }

  /// Health check for geological services
  /// Returns true if services are available
  Future<bool> checkServiceHealth() async {
    final result = await get('/health');
    return result.isSuccess;
  }

  /// Get available geological services
  /// Returns list of available service endpoints
  Future<FlowyResult<List<String>, String>> getAvailableServices() async {
    final result = await get('/services');
    return result.map((data) {
      final services = data['services'] as List?;
      return services?.cast<String>() ?? <String>[];
    });
  }

  /// Get service configuration
  /// Returns configuration for a specific service
  Future<FlowyResult<Map<String, dynamic>, String>> getServiceConfig(
    String serviceName,
  ) async {
    return await get('/services/$serviceName/config');
  }

  /// Test connection to a specific service
  /// Returns true if service is reachable
  Future<bool> testServiceConnection(String serviceName) async {
    final result = await get('/services/$serviceName/ping');
    return result.isSuccess;
  }

  /// Placeholder for future geological data operations
  /// This will be the integration point for private services
  Future<FlowyResult<Map<String, dynamic>, String>> processGeologicalData({
    required String dataType,
    required Map<String, dynamic> parameters,
  }) async {
    // This is just a placeholder - actual implementation will call private services
    return await post('/process', body: {
      'data_type': dataType,
      'parameters': parameters,
    });
  }

  /// Placeholder for file upload operations
  /// This will handle geological file uploads to private services
  Future<FlowyResult<Map<String, dynamic>, String>> uploadGeologicalFile({
    required String fileType,
    required List<int> fileBytes,
    required String fileName,
    Map<String, dynamic>? metadata,
  }) async {
    // This is just a placeholder - actual implementation will call private services
    return await uploadFile(
      '/upload',
      'file',
      fileBytes,
      fileName,
      fields: {
        'file_type': fileType,
        if (metadata != null) 'metadata': metadata.toString(),
      },
    );
  }

  /// Dispose resources
  @override
  void dispose() {
    super.dispose();
    _instance = null;
  }
}

/// Geological service types - placeholders for future implementation
enum GeologicalServiceType {
  seismicProcessing,
  wellLogAnalysis,
  coreAnalysis,
  aiAssistant,
  mapService,
}

/// Geological data types - placeholders for future implementation
enum GeologicalDataType {
  seismicData,
  wellLogData,
  coreData,
  mapData,
  reportData,
}

/// Configuration for geological services
class GeologicalServiceConfig {
  const GeologicalServiceConfig({
    required this.serviceType,
    required this.endpoint,
    required this.authConfig,
    this.isEnabled = true,
  });

  final GeologicalServiceType serviceType;
  final String endpoint;
  final GeoHogAuthConfig authConfig;
  final bool isEnabled;

  /// Placeholder configurations for future services
  static const seismicProcessor = GeologicalServiceConfig(
    serviceType: GeologicalServiceType.seismicProcessing,
    endpoint: '/seismic',
    authConfig: GeoHogAuthConfig.seismicProcessor,
  );

  static const wellAnalyzer = GeologicalServiceConfig(
    serviceType: GeologicalServiceType.wellLogAnalysis,
    endpoint: '/wells',
    authConfig: GeoHogAuthConfig.wellAnalyzer,
  );

  static const coreAnalyzer = GeologicalServiceConfig(
    serviceType: GeologicalServiceType.coreAnalysis,
    endpoint: '/cores',
    authConfig: GeoHogAuthConfig.coreAnalyzer,
  );

  static const aiAssistant = GeologicalServiceConfig(
    serviceType: GeologicalServiceType.aiAssistant,
    endpoint: '/ai',
    authConfig: GeoHogAuthConfig.aiAssistant,
  );

  static const mapService = GeologicalServiceConfig(
    serviceType: GeologicalServiceType.mapService,
    endpoint: '/maps',
    authConfig: GeoHogAuthConfig.mapService,
  );

  /// Get all service configurations
  static List<GeologicalServiceConfig> get allServices => [
        seismicProcessor,
        wellAnalyzer,
        coreAnalyzer,
        aiAssistant,
        mapService,
      ];
}
