require 'forwardable'

# Rack::Lint compatible input wrapper
module Rack
  module UploadProgress
    class InputWrapper
      extend Forwardable
      
      def_delegators :@input, :gets, :each, :rewind
      
      attr_reader :length
      attr_reader :received

      def initialize(env)
        @input    = env['rack.input']
        @length   = env['CONTENT_LENGTH'].to_i
        @received = 0
      end

      def read(*args)
        @input.read(*args).tap do |chunk|
          self.increment Rack::Utils.bytesize(chunk)
        end
      end
      
      def increment(value)
        @received += value
      end
    end
  end
end