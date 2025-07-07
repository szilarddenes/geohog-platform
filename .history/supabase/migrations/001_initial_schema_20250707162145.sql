-- Enable necessary extensions for geological data
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";
CREATE EXTENSION IF NOT EXISTS "postgis_topology";

-- Create enum types for geological data
CREATE TYPE geological_data_type AS ENUM (
  'seismic',
  'well_log',
  'core_sample',
  'geological_map',
  'geochemical',
  'geophysical',
  'stratigraphic',
  'structural'
);

CREATE TYPE data_quality AS ENUM (
  'excellent',
  'good',
  'fair',
  'poor',
  'unknown'
);

CREATE TYPE processing_status AS ENUM (
  'raw',
  'processing',
  'processed',
  'validated',
  'archived'
);

-- Projects table for organizing geological surveys
CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  location GEOMETRY(POLYGON, 4326),
  start_date DATE,
  end_date DATE,
  client VARCHAR(255),
  project_manager VARCHAR(255),
  budget DECIMAL(15, 2),
  status VARCHAR(50) DEFAULT 'active',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

-- Wells table for drill hole data
CREATE TABLE wells (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  well_name VARCHAR(255) NOT NULL,
  well_number VARCHAR(100),
  location GEOMETRY(POINT, 4326) NOT NULL,
  surface_elevation DECIMAL(10, 3),
  total_depth DECIMAL(10, 3),
  spud_date DATE,
  completion_date DATE,
  well_type VARCHAR(100),
  operator VARCHAR(255),
  api_number VARCHAR(50),
  status VARCHAR(50) DEFAULT 'active',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Geological layers/formations table
CREATE TABLE geological_formations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  formation_name VARCHAR(255) NOT NULL,
  age VARCHAR(100),
  lithology TEXT,
  description TEXT,
  thickness_min DECIMAL(10, 3),
  thickness_max DECIMAL(10, 3),
  depth_top DECIMAL(10, 3),
  depth_bottom DECIMAL(10, 3),
  geometry GEOMETRY(MULTIPOLYGON, 4326),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Sample data table
CREATE TABLE samples (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  well_id UUID REFERENCES wells(id) ON DELETE SET NULL,
  sample_id VARCHAR(255) NOT NULL,
  sample_type geological_data_type NOT NULL,
  location GEOMETRY(POINT, 4326),
  depth_from DECIMAL(10, 3),
  depth_to DECIMAL(10, 3),
  collection_date DATE,
  quality data_quality DEFAULT 'unknown',
  description TEXT,
  laboratory VARCHAR(255),
  analysis_type VARCHAR(255),
  results JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Geological data files storage
CREATE TABLE geological_files (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  well_id UUID REFERENCES wells(id) ON DELETE SET NULL,
  sample_id UUID REFERENCES samples(id) ON DELETE SET NULL,
  file_name VARCHAR(255) NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  file_type VARCHAR(100),
  file_size BIGINT,
  data_type geological_data_type,
  processing_status processing_status DEFAULT 'raw',
  upload_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  processed_date TIMESTAMP WITH TIME ZONE,
  metadata JSONB,
  checksum VARCHAR(64),
  created_by UUID REFERENCES auth.users(id)
);

-- Seismic surveys table
CREATE TABLE seismic_surveys (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  survey_name VARCHAR(255) NOT NULL,
  survey_type VARCHAR(100), -- 2D, 3D, 4D
  acquisition_date DATE,
  contractor VARCHAR(255),
  survey_area GEOMETRY(POLYGON, 4326),
  line_spacing DECIMAL(8, 2),
  shot_spacing DECIMAL(8, 2),
  record_length DECIMAL(6, 3),
  sample_rate DECIMAL(6, 3),
  parameters JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- GIS layers for mapping
CREATE TABLE gis_layers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  layer_name VARCHAR(255) NOT NULL,
  layer_type VARCHAR(100), -- geology, topography, infrastructure, etc.
  geometry_type VARCHAR(50), -- point, line, polygon
  style_config JSONB,
  is_visible BOOLEAN DEFAULT true,
  opacity DECIMAL(3, 2) DEFAULT 1.0,
  z_index INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Feature data for GIS layers
CREATE TABLE gis_features (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  layer_id UUID REFERENCES gis_layers(id) ON DELETE CASCADE,
  geometry GEOMETRY NOT NULL,
  properties JSONB,
  label VARCHAR(255),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create spatial indexes for performance
CREATE INDEX idx_projects_location ON projects USING GIST(location);
CREATE INDEX idx_wells_location ON wells USING GIST(location);
CREATE INDEX idx_samples_location ON samples USING GIST(location);
CREATE INDEX idx_geological_formations_geometry ON geological_formations USING GIST(geometry);
CREATE INDEX idx_seismic_surveys_area ON seismic_surveys USING GIST(survey_area);
CREATE INDEX idx_gis_features_geometry ON gis_features USING GIST(geometry);

-- Create indexes for foreign keys and common queries
CREATE INDEX idx_wells_project_id ON wells(project_id);
CREATE INDEX idx_samples_project_id ON samples(project_id);
CREATE INDEX idx_samples_well_id ON samples(well_id);
CREATE INDEX idx_geological_files_project_id ON geological_files(project_id);
CREATE INDEX idx_seismic_surveys_project_id ON seismic_surveys(project_id);
CREATE INDEX idx_gis_layers_project_id ON gis_layers(project_id);
CREATE INDEX idx_gis_features_layer_id ON gis_features(layer_id);

-- Add updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at columns
CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_wells_updated_at BEFORE UPDATE ON wells FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_geological_formations_updated_at BEFORE UPDATE ON geological_formations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_samples_updated_at BEFORE UPDATE ON samples FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_seismic_surveys_updated_at BEFORE UPDATE ON seismic_surveys FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_gis_layers_updated_at BEFORE UPDATE ON gis_layers FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_gis_features_updated_at BEFORE UPDATE ON gis_features FOR EACH ROW EXECUTE FUNCTION update_updated_at_column(); 