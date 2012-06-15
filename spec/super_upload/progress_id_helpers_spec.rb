require 'spec_helper'
require 'lib/super_upload'

describe SuperUpload::ProgressIdHelpers do
  let(:id) { 'foo' }

  subject do
    double('app', params: {}, request: {}).extend(SuperUpload::ProgressIdHelpers)
  end
  
  describe '#progress_id' do
    context 'if params contain X-Progress-ID key' do
      before { subject.stub(params: { 'X-Progress-ID' => id }) }
      
      it 'returns progress ID' do
        subject.progress_id.should == id
      end
    end

    context 'if params contain :progress_id key' do
      before { subject.stub(params: { 'progress_id' => id }) }
      
      it 'returns progress ID' do
        subject.progress_id.should == id
      end
    end

    context 'if request contains X-Progress-ID header' do
      before { subject.stub(request: { 'X-Progress-ID' => id }) }
      
      it 'returns progress ID' do
        subject.progress_id.should == id
      end
    end

    context 'if params and request do not contain X-Progress-ID key' do
      before do
        subject.stub(params: {})
        subject.stub(request: {})
      end
      
      it 'returns nil' do
        subject.progress_id.should be_nil
      end
    end
  end
end