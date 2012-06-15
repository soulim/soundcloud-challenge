module SuperUpload
  module ProgressIdHelpers
    def progress_id
      params["X-Progress-ID"] || request["X-Progress-ID"] || params["progress_id"]
    end
  end
end