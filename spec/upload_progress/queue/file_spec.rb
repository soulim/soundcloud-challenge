require 'spec_helper'
require 'lib/upload_progress'

describe UploadProgress::Queue::File do
  describe '#update' do
    it 'sets :receive with given value' do
      expect { subject.update(1) }.to change { subject.received }
    end
    
    context 'if is done' do
      before { subject.stub(done?: true) }
      
      it 'sets :status to "done"' do
        subject.update(1)
        subject.status.should == 'done'
      end
    end

    context 'if is not done' do
      before { subject.stub(done?: false) }

      it 'sets :status to "uploading"' do
        subject.update(1)
        subject.status.should == 'uploading'
      end
    end
  end
end