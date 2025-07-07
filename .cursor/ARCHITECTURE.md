# GeoHog Architecture Documentation

## Project Structure Overview

GeoHog is built using a **layered architecture** that maintains legal compliance while protecting competitive advantages. This approach follows the strategy outlined in `FORK_ARCHIT.md`.

## Architecture Layers

### 1. Public Foundation Layer (This Repository)
**Location**: `https://github.com/szilarddenes/geohog-platform`
**License**: AGPL v3 (inherited from AppFlowy)
**Contains**:
- AppFlowy base functionality (document editing, collaboration, workspace)
- GeoHog branding and customizations
- Public API integration points
- Interface layer for geological services

### 2. Private Services Layer (Separate Repositories)
**Location**: Private repositories (not created yet)
**License**: Your choice (proprietary recommended)
**Contains**:
- Geological AI services
- Seismic data processing
- Well log analysis
- Core sample analysis
- Proprietary algorithms and models

### 3. Integration Layer (This Repository)
**Location**: `frontend/appflowy_flutter/lib/integrations/`
**License**: AGPL v3
**Contains**:
- API connectors to private services
- Data transformation utilities
- Authentication helpers
- Plugin integration points

## Legal Compliance Strategy

### What MUST be Public (AGPL Requirements)
- ✅ AppFlowy base code (document editing, collaboration)
- ✅ Any modifications to AppFlowy core
- ✅ GeoHog branding and UI customizations
- ✅ Public API integration layer

### What CAN be Private (Separate Works)
- ✅ Geological AI models and algorithms
- ✅ Seismic data processing services
- ✅ Well log analysis engines
- ✅ Core sample analysis tools
- ✅ Proprietary geological expertise
- ✅ Customer data and insights

## Git Strategy

### Upstream Tracking
```bash
# Already configured:
git remote add upstream https://github.com/AppFlowy-IO/AppFlowy.git

# Regular updates:
git fetch upstream
git merge upstream/main  # or rebase as needed
```

### Branch Strategy
- `main`: Production-ready GeoHog
- `develop`: Development branch
- `upstream-sync`: For merging AppFlowy updates
- `feature/*`: Feature branches

## Directory Structure

```
geohog-platform/
├── frontend/appflowy_flutter/
│   ├── lib/
│   │   ├── integrations/           # New: API integration layer
│   │   │   ├── geological/         # Geological service integrations
│   │   │   ├── auth/              # Authentication for private services
│   │   │   └── api_client/        # Base API client
│   │   ├── plugins/               # Existing: AppFlowy plugins
│   │   └── ...                    # Existing AppFlowy structure
│   └── packages/
│       └── geohog_extensions/     # New: GeoHog-specific extensions
└── docs/
    ├── ARCHITECTURE.md            # This file
    ├── FORK_ARCHIT.md            # Legal compliance strategy
    └── PRIVATE_SERVICES.md       # Private services documentation
```

## Private Services Architecture (Future)

These will be separate repositories:

### 1. geohog-ai-service (Private)
- Geological AI assistant
- Machine learning models
- Natural language processing for geological queries

### 2. geohog-seismic-processor (Private)
- Seismic data analysis
- Waveform processing
- Geological interpretation algorithms

### 3. geohog-well-analyzer (Private)
- Well log interpretation
- Formation analysis
- Lithology prediction

### 4. geohog-core-analyzer (Private)
- Core sample image analysis
- Texture and composition analysis
- Automated geological logging

## API Integration Points

The public repository will contain **interface code only**:

```dart
// Public interface - connects to private services
class GeologicalApiClient {
  Future<AnalysisResult> analyzeSeismicData(SeismicData data);
  Future<WellAnalysis> analyzeWellLog(WellLogData data);
  Future<CoreAnalysis> analyzeCoreData(CoreData data);
}
```

## Development Workflow

1. **Base Development**: Work on AppFlowy customizations here
2. **Private Services**: Develop in separate private repositories
3. **Integration**: Use API clients to connect layers
4. **Testing**: Test integration points without revealing private logic
5. **Deployment**: Deploy layers independently

## Benefits of This Architecture

- ✅ **Legal Compliance**: Satisfies AGPL requirements
- ✅ **Competitive Protection**: Geological expertise stays private
- ✅ **Maintainability**: Easy to update from upstream AppFlowy
- ✅ **Scalability**: Private services can scale independently
- ✅ **Flexibility**: Can open-source some parts later if desired

## Next Steps

1. Set up integration layer structure
2. Create API client templates
3. Document private services architecture
4. Set up development environment
5. Create deployment strategy 