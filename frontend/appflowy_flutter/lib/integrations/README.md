# GeoHog Integration Layer

This directory contains the **public interface layer** that connects the GeoHog workspace to private geological services.

## 🔒 Legal Compliance Notice

This integration layer is **public code** (AGPL v3) and contains **NO proprietary algorithms or geological expertise**. It serves as a bridge between the public AppFlowy workspace and private geological services.

## Directory Structure

```
integrations/
├── geological/          # Geological service integrations
│   ├── api_client.dart  # Base API client for geological services
│   ├── models/          # Data models for API communication
│   ├── seismic/         # Seismic data integration
│   ├── well_logs/       # Well log integration
│   ├── core_analysis/   # Core sample integration
│   └── ai_assistant/    # AI service integration
├── auth/                # Authentication for private services
│   ├── auth_client.dart
│   └── token_manager.dart
└── api_client/          # Base API utilities
    ├── base_client.dart
    ├── http_client.dart
    └── websocket_client.dart
```

## What This Layer Does

### ✅ Public Interface Functions
- **API Communication**: HTTP/WebSocket clients for private services
- **Data Transformation**: Convert between AppFlowy and geological data formats
- **Authentication**: Manage API keys and tokens for private services
- **Error Handling**: Graceful degradation when private services are unavailable
- **UI Integration**: Widgets that display geological data within AppFlowy

### ❌ What This Layer Does NOT Do
- **Geological Processing**: No seismic analysis, well log interpretation, or AI models
- **Proprietary Algorithms**: No geological expertise or competitive advantages
- **Business Logic**: No geological decision-making or analysis
- **Data Storage**: No geological databases or proprietary data formats

## Private Services Connection

This layer connects to private services running on separate infrastructure:

```dart
// Example: Public interface only
class SeismicApiClient {
  Future<SeismicAnalysisResult> analyzeSeismicData({
    required Uint8List seismicFile,
    required String format,
    Map<String, dynamic>? parameters,
  }) async {
    // Public HTTP client call to private service
    final response = await httpClient.post(
      Uri.parse('$baseUrl/api/seismic/analyze'),
      body: /* request data */,
    );
    
    // Return standardized result
    return SeismicAnalysisResult.fromJson(response.body);
  }
}
```

## Development Guidelines

1. **No Business Logic**: Keep all geological expertise in private services
2. **Standardized APIs**: Use consistent request/response formats
3. **Error Handling**: Always handle service unavailability gracefully
4. **Documentation**: Document all public interfaces
5. **Testing**: Test with mock services, not real geological data

## Private Services (NOT in this repository)

The actual geological processing happens in separate private repositories:

- `geohog-ai-service` - Geological AI assistant
- `geohog-seismic-processor` - Seismic data analysis
- `geohog-well-analyzer` - Well log interpretation  
- `geohog-core-analyzer` - Core sample analysis

## Usage Example

```dart
// In AppFlowy document plugin
class GeologicalDocumentBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GeologicalData>(
      future: GeologicalApiClient.instance.fetchData(projectId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GeologicalDataWidget(data: snapshot.data!);
        }
        return LoadingWidget();
      },
    );
  }
}
```

This keeps the public workspace focused on document management while geological expertise remains private and protected. 