# Rack middleware to handle upload process with progress indication
module Rack
  module UploadProgress
    UPLOAD_PATH = '/uploads'
    STATUS_PATH = '/status'
    QUERY_PARAM = 'X-Progress-ID'
  end
end

require './lib/rack/upload_progress/middleware'