-- Create storage buckets for geological data files
INSERT INTO storage.buckets (id, name, public) VALUES 
  ('geological-files', 'geological-files', false),
  ('seismic-data', 'seismic-data', false),
  ('well-logs', 'well-logs', false),
  ('core-samples', 'core-samples', false),
  ('geological-maps', 'geological-maps', false),
  ('web-hosting', 'web-hosting', true);

-- Storage policies for geological-files bucket
CREATE POLICY "Users can view files in their projects" ON storage.objects FOR SELECT 
USING (
  bucket_id = 'geological-files' AND 
  (storage.foldername(name))[1] IN (
    SELECT id::text FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id)
  )
);

CREATE POLICY "Project members can upload files" ON storage.objects FOR INSERT 
WITH CHECK (
  bucket_id = 'geological-files' AND 
  (storage.foldername(name))[1] IN (
    SELECT id::text FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist', 'technician'))
  )
);

CREATE POLICY "File owners and project admins can update files" ON storage.objects FOR UPDATE 
USING (
  bucket_id = 'geological-files' AND 
  (
    owner = auth.uid() OR 
    (storage.foldername(name))[1] IN (
      SELECT id::text FROM projects WHERE 
      auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager'))
    )
  )
);

CREATE POLICY "File owners and project admins can delete files" ON storage.objects FOR DELETE 
USING (
  bucket_id = 'geological-files' AND 
  (
    owner = auth.uid() OR 
    (storage.foldername(name))[1] IN (
      SELECT id::text FROM projects WHERE 
      auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager'))
    )
  )
);

-- Seismic data bucket policies
CREATE POLICY "Users can view seismic data in their projects" ON storage.objects FOR SELECT 
USING (
  bucket_id = 'seismic-data' AND 
  (storage.foldername(name))[1] IN (
    SELECT id::text FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id)
  )
);

CREATE POLICY "Geophysicists can upload seismic data" ON storage.objects FOR INSERT 
WITH CHECK (
  bucket_id = 'seismic-data' AND 
  (storage.foldername(name))[1] IN (
    SELECT id::text FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geophysicist'))
  )
);

-- Well logs bucket policies
CREATE POLICY "Users can view well logs in their projects" ON storage.objects FOR SELECT 
USING (
  bucket_id = 'well-logs' AND 
  (storage.foldername(name))[1] IN (
    SELECT id::text FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id)
  )
);

CREATE POLICY "Geologists can upload well logs" ON storage.objects FOR INSERT 
WITH CHECK (
  bucket_id = 'well-logs' AND 
  (storage.foldername(name))[1] IN (
    SELECT id::text FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist'))
  )
);

-- Core samples bucket policies
CREATE POLICY "Users can view core samples in their projects" ON storage.objects FOR SELECT 
USING (
  bucket_id = 'core-samples' AND 
  (storage.foldername(name))[1] IN (
    SELECT id::text FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id)
  )
);

CREATE POLICY "Technicians can upload core sample data" ON storage.objects FOR INSERT 
WITH CHECK (
  bucket_id = 'core-samples' AND 
  (storage.foldername(name))[1] IN (
    SELECT id::text FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist', 'technician'))
  )
);

-- Geological maps bucket policies
CREATE POLICY "Users can view geological maps in their projects" ON storage.objects FOR SELECT 
USING (
  bucket_id = 'geological-maps' AND 
  (storage.foldername(name))[1] IN (
    SELECT id::text FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id)
  )
);

CREATE POLICY "GIS specialists can upload geological maps" ON storage.objects FOR INSERT 
WITH CHECK (
  bucket_id = 'geological-maps' AND 
  (storage.foldername(name))[1] IN (
    SELECT id::text FROM projects WHERE 
    auth.uid() = created_by OR 
    auth.uid() IN (SELECT user_id FROM project_members WHERE project_id = projects.id AND role IN ('admin', 'manager', 'geologist', 'gis_specialist'))
  )
);

-- Web hosting bucket (public bucket for static website hosting)
CREATE POLICY "Public read access for web hosting" ON storage.objects FOR SELECT 
USING (bucket_id = 'web-hosting');

CREATE POLICY "Authenticated users can upload to web hosting" ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'web-hosting' AND auth.role() = 'authenticated'); 