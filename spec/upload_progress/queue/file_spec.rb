require 'spec_helper'
require 'lib/upload_progress'

describe UploadProgress::Queue::File do
  describe '#update' do
    it 'set :receive with given value' do
      expect { subject.update(1) }.to change { subject.received }
    end
  end
end