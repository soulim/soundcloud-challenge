require 'forwardable'

module UploadProgress
  class InputWrapper
    extend Forwardable
    
    def_delegators :@input, :gets, :each, :rewind
    
    attr_reader :progress_id
    attr_reader :size
    attr_reader :received

    def initialize(env, progress_id, callback)
      @input       = env['rack.input']
      @size        = env['CONTENT_LENGTH'].to_i
      @received    = 0
      @progress_id = progress_id
      @callback    = callback
    end

    def read(*args)
      @input.read(*args).tap do |chunk|
        self.increment Rack::Utils.bytesize(chunk)
      end
    end
    
    def increment(value)
      @received += value
      @callback.call(@progress_id, @received)

      return @received
    end
  end
end