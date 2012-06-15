require './lib/super_upload'
require './lib/upload_progress'

use UploadProgress::Middleware
run SuperUpload::Application