require './lib/application'
require './lib/rack/upload_progress'

use Rack::UploadProgress::Middleware
run Application