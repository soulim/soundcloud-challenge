module SuperUpload
  module ProgressIdHelpers
    def generate_progress_id
      Digest::MD5.hexdigest(Time.now.to_f.to_s)
    end

    def progress_id
      params["X-Progress-ID"] || request["X-Progress-ID"] || params["progress_id"]
    end
  end
end
