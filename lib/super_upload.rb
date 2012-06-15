module SuperUpload
  ROOT_PATH    = File.expand_path(File.join('..', '..'), __FILE__)
  LIBRARY_PATH = File.join(ROOT_PATH, 'lib', 'super_upload')
  PUBLIC_PATH  = File.join(ROOT_PATH, 'public')
  UPLOAD_DIR   = 'files'
  UPLOAD_PATH  = File.join(PUBLIC_PATH, UPLOAD_DIR)
  
  autoload :Application, File.join(LIBRARY_PATH, 'application')
  autoload :UploadHelpers, File.join(LIBRARY_PATH, 'upload_helpers')
  autoload :ProgressIdHelpers, File.join(LIBRARY_PATH, 'progress_id_helpers')
end