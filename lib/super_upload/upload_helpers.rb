module SuperUpload
  module UploadHelpers
    def store_file(id, source_path, filename)
      base_path = File.join(UPLOAD_PATH, id)
      file_path = File.join(base_path, filename)
      
      FileUtils.mkdir_p(base_path)
      FileUtils.copy_file(source_path, file_path)
    end
  
    def store_description(id, text)
      base_path = File.join(UPLOAD_PATH, id)
      file_path = File.join(base_path, "#{id}.txt")
      
      FileUtils.mkdir_p(base_path)
      File.open(file_path, 'w', 0644) do |file|
        file << text
      end
    end
    
    def get_uploads(id)
      base_path = File.join(UPLOAD_PATH, id)
      file_mask = File.join(base_path, '*.*')
      
      Dir[file_mask].map { |file_path| File.basename(file_path) }.
                     reject { |filename| filename == "#{id}.txt" }
    end
  
    def get_description(id)
      file_path = File.join(UPLOAD_PATH, id, "#{id}.txt")
      
      File.exists?(file_path) ? File.read(file_path) : ''
    end
    
    def public_files(id)
      base_path = File.join(UPLOAD_PATH, id)
      
      get_uploads(id).reduce({}) do |result, filename|
        result[filename] = "#{base_path}/#{filename}"
        result
      end
    end
  end
end