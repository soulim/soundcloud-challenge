require 'spec_helper'
require 'lib/upload_progress'

describe UploadProgress::Queue::DRb do
  describe '.new' do
    it 'starts DRB service' do
      DRb.should_receive(:start_service)
      UploadProgress::Queue::DRb.new
    end

    it 'initialize DRb object with given URI' do
      DRbObject.should_receive(:new_with_uri).with('foo')
      UploadProgress::Queue::DRb.new('foo')
    end
  end
end