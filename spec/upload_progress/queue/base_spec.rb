require 'spec_helper'
require 'lib/upload_progress'

describe UploadProgress::Queue::Base do
  let(:progress_id) { 'foo' }
  let(:file) { double('file').as_null_object }
  
  describe '#get' do
    before { subject.set(progress_id, file) }

    it 'gets file by given ProgressID' do
      subject.get(progress_id).should == file
    end
  end

  describe '#set' do
    it 'sets file to queue by given ProgressID' do
      subject.set(progress_id, file)
      subject.get(progress_id).should == file
    end
  end
  
  describe '#start' do
    it 'initialize a new file task' do
      UploadProgress::Queue::File.should_receive(:new)
      subject.start(progress_id, 1)
    end
    
    it 'sets file to queue' do
      subject.should_receive(:set)
      subject.start(progress_id, 1)
    end
  end
  
  describe '#update' do
    before { subject.stub(get: file) }
    
    it 'gets file by progress_id' do
      subject.should_receive(:get).with(progress_id)
      subject.update(progress_id, 1)
    end
    
    it 'updates file stats' do
      file.should_receive(:update)
      subject.update(progress_id, 1)
    end
  end
end