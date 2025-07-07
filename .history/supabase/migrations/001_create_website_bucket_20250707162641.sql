-- Create storage bucket for website hosting
INSERT INTO storage.buckets (id, name, public) 
VALUES ('website', 'website', true)
ON CONFLICT (id) DO NOTHING;

-- Create policy to allow public access to website files
CREATE POLICY "Public read access for website files" ON storage.objects 
FOR SELECT USING (bucket_id = 'website');

-- Create policy to allow authenticated uploads for CI/CD
CREATE POLICY "Allow authenticated uploads to website bucket" ON storage.objects 
FOR INSERT WITH CHECK (bucket_id = 'website' AND auth.role() = 'authenticated'); 