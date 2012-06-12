require 'spec_helper'
require 'lib/upload_progress'

describe UploadProgress::Queue::Base do
  let(:progress_id) { 'foo' }
  let(:task) { double('task').as_null_object }
  
  describe '#push' do
    it 'initialize a new task' do
      UploadProgress::Queue::Task.should_receive(:new)
      subject.push(progress_id, 1)
    end
  end
  
  describe '#update' do
    before do
      subject.stub(get: task)
    end
    
    it 'gets task by progress_id' do
      subject.should_receive(:get).with(progress_id)
      subject.update(progress_id, 1)
    end
    
    it 'updates task' do
      task.should_receive(:update)
      subject.update(progress_id, 1)
    end
  end
end