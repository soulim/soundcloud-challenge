require 'drb/drb'

module UploadProgress
  module Queue
    class DRb < Base
      DEFAULT_SERVER_URI = 'druby://localhost:8787'

      def initialize(uri = DEFAULT_SERVER_URI)
        ::DRb.start_service
        @queue = ::DRbObject.new_with_uri(uri)
      end
    end
  end
end
