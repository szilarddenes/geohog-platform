-- Enable Row Level Security on all tables
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE wells ENABLE ROW LEVEL SECURITY;
ALTER TABLE geological_formations ENABLE ROW LEVEL SECURITY;
ALTER TABLE samples ENABLE ROW LEVEL SECURITY;
ALTER TABLE geological_files ENABLE ROW LEVEL SECURITY;
ALTER TABLE seismic_surveys ENABLE ROW LEVEL SECURITY;
ALTER TABLE gis_layers ENABLE ROW LEVEL SECURITY;
ALTER TABLE gis_features ENABLE ROW LEVEL SECURITY;

-- Projects table policies
CREATE POLICY "Users can view projects they created or are members of" ON projects FOR SELECT 
USING (
  auth.uid() = created_by OR 
  auth.uid() IN (
    SELECT user_id FROM project_members WHERE project_id = projects.id
  )
);

CREATE POLICY "Users can create projects" ON projects FOR INSERT 
WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Project creators and admins can update projects" ON projects FOR UPDATE 
USING (
  auth.uid() = created_by OR 
  auth.uid() IN (
    SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager')
  )
);

CREATE POLICY "Project creators and admins can delete projects" ON projects FOR DELETE 
USING (
  auth.uid() = created_by OR 
  auth.uid() IN (
    SELECT user_id FROM project_members WHERE project_id = projects.id AND role = 'admin'
  )
);

-- Wells table policies
CREATE POLICY "Users can view wells in their projects" ON wells FOR SELECT 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id)
  )
);

CREATE POLICY "Project members can create wells" ON wells FOR INSERT 
WITH CHECK (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist'))
  )
);

CREATE POLICY "Project members can update wells" ON wells FOR UPDATE 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist'))
  )
);

CREATE POLICY "Project admins can delete wells" ON wells FOR DELETE 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager'))
  )
);

-- Geological formations policies
CREATE POLICY "Users can view formations in their projects" ON geological_formations FOR SELECT 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id)
  )
);

CREATE POLICY "Project members can create formations" ON geological_formations FOR INSERT 
WITH CHECK (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist'))
  )
);

CREATE POLICY "Project members can update formations" ON geological_formations FOR UPDATE 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist'))
  )
);

CREATE POLICY "Project admins can delete formations" ON geological_formations FOR DELETE 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager'))
  )
);

-- Samples policies
CREATE POLICY "Users can view samples in their projects" ON samples FOR SELECT 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id)
  )
);

CREATE POLICY "Project members can create samples" ON samples FOR INSERT 
WITH CHECK (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist', 'technician'))
  )
);

CREATE POLICY "Project members can update samples" ON samples FOR UPDATE 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist', 'technician'))
  )
);

CREATE POLICY "Project admins can delete samples" ON samples FOR DELETE 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager'))
  )
);

-- Geological files policies
CREATE POLICY "Users can view files in their projects" ON geological_files FOR SELECT 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id)
  )
);

CREATE POLICY "Project members can upload files" ON geological_files FOR INSERT 
WITH CHECK (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist', 'technician'))
  ) AND auth.uid() = created_by
);

CREATE POLICY "File owners and project admins can update files" ON geological_files FOR UPDATE 
USING (
  auth.uid() = created_by OR 
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager'))
  )
);

CREATE POLICY "File owners and project admins can delete files" ON geological_files FOR DELETE 
USING (
  auth.uid() = created_by OR 
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager'))
  )
);

-- Seismic surveys policies
CREATE POLICY "Users can view seismic surveys in their projects" ON seismic_surveys FOR SELECT 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id)
  )
);

CREATE POLICY "Project members can create seismic surveys" ON seismic_surveys FOR INSERT 
WITH CHECK (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geophysicist'))
  )
);

CREATE POLICY "Project members can update seismic surveys" ON seismic_surveys FOR UPDATE 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geophysicist'))
  )
);

CREATE POLICY "Project admins can delete seismic surveys" ON seismic_surveys FOR DELETE 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager'))
  )
);

-- GIS layers policies
CREATE POLICY "Users can view GIS layers in their projects" ON gis_layers FOR SELECT 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id)
  )
);

CREATE POLICY "Project members can create GIS layers" ON gis_layers FOR INSERT 
WITH CHECK (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist', 'gis_specialist'))
  )
);

CREATE POLICY "Project members can update GIS layers" ON gis_layers FOR UPDATE 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist', 'gis_specialist'))
  )
);

CREATE POLICY "Project admins can delete GIS layers" ON gis_layers FOR DELETE 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager'))
  )
);

-- GIS features policies
CREATE POLICY "Users can view GIS features in their projects" ON gis_features FOR SELECT 
USING (
  layer_id IN (
    SELECT id FROM gis_layers WHERE project_id IN (
      SELECT id FROM projects WHERE 
      auth.uid() = created_by OR 
      auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id)
    )
  )
);

CREATE POLICY "Project members can create GIS features" ON gis_features FOR INSERT 
WITH CHECK (
  layer_id IN (
    SELECT id FROM gis_layers WHERE project_id IN (
      SELECT id FROM projects WHERE 
      auth.uid() = created_by OR 
      auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist', 'gis_specialist'))
    )
  )
);

CREATE POLICY "Project members can update GIS features" ON gis_features FOR UPDATE 
USING (
  layer_id IN (
    SELECT id FROM gis_layers WHERE project_id IN (
      SELECT id FROM projects WHERE 
      auth.uid() = created_by OR 
      auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist', 'gis_specialist'))
    )
  )
);

CREATE POLICY "Project admins can delete GIS features" ON gis_features FOR DELETE 
USING (
  layer_id IN (
    SELECT id FROM gis_layers WHERE project_id IN (
      SELECT id FROM projects WHERE 
      auth.uid() = created_by OR 
      auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager'))
    )
  )
);

-- Create project members table for role-based access
CREATE TABLE project_members (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  role VARCHAR(50) NOT NULL DEFAULT 'viewer', -- admin, manager, geologist, geophysicist, technician, gis_specialist, viewer
  invited_by UUID REFERENCES auth.users(id),
  invited_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  joined_at TIMESTAMP WITH TIME ZONE,
  status VARCHAR(50) DEFAULT 'pending', -- pending, active, inactive
  UNIQUE(project_id, user_id)
);

-- Project members table policies
ALTER TABLE project_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view project memberships they are part of" ON project_members FOR SELECT 
USING (
  user_id = auth.uid() OR 
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager'))
  )
);

CREATE POLICY "Project admins can manage memberships" ON project_members FOR ALL 
USING (
  project_id IN (
    SELECT id FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role = 'admin')
  )
); 