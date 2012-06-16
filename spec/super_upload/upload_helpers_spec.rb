require 'spec_helper'
require 'lib/super_upload'

describe SuperUpload::UploadHelpers do
  let(:id)          { 'foo' }
  let(:description) { 'description text' }

  subject { double('app').extend(SuperUpload::UploadHelpers) }

  describe '#store_file' do
    before do
      FileUtils.stub(:mkdir_p)
      FileUtils.stub(:copy_file)
    end

    it 'makes directory for stored file' do
      FileUtils.should_receive(:mkdir_p)
      subject.store_file(id, 'source/path', 'file_name')
    end

    it 'copies uploaded file' do
      FileUtils.should_receive(:copy_file)
      subject.store_file(id, 'source/path', 'file_name')
    end
  end

  describe '#store_description' do
    let(:file_handle) { double('file_handle').as_null_object }

    before do
      FileUtils.stub(:mkdir_p)
      File.stub(:open).and_yield(file_handle)
    end

    it 'makes directory for stored description file' do
      FileUtils.should_receive(:mkdir_p)
      subject.store_description(id, description)
    end

    it 'opens file to store description' do
      File.should_receive(:open)
      subject.store_description(id, description)
    end

    it 'stores description to file' do
      file_handle.should_receive(:<<).with(description)
      subject.store_description(id, description)
    end
  end

  describe '#get_uploads' do
    before do
      Dir.stub(:[] => ['file.ext', "#{id}.txt"])
    end

    it 'takes list of uploaded files' do
      Dir.should_receive(:[])
      subject.get_uploads(id)
    end

    it 'rejects description file from list' do
      list = subject.get_uploads(id)
      list.should_not include("#{id}.txt")
    end
  end

  describe '#get_description' do
    context 'if file exists' do
      before do
        File.stub(exists?: true)
        File.stub(read: description)
      end

      it 'reads description from file' do
        File.should_receive(:read)
        subject.get_description(id)
      end

      it 'returns description' do
        subject.get_description(id).should == description
      end
    end

    context 'if file does not exist' do
      before { File.stub(exists?: false) }

      it 'returns empty string' do
        subject.get_description(id).should == ''
      end
    end
  end

  describe '#public_files' do
    before { subject.stub(get_uploads: []) }

    it 'gets the list of uploaded files' do
      subject.should_receive(:get_uploads)
      subject.public_files(id)
    end
  end
end
