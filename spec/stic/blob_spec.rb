require 'spec_helper'

describe Stic::Blob do
  let(:data) { nil }
  let(:site) { double('site') }
  let(:blob) do
    blob = Stic::Blob.new site: site, data: data
    allow(blob).to receive(:url_template){ url_template }
    blob
  end

  describe '#relative_url' do
    let(:url_template) { Path.new tpl }
    subject { blob.relative_url }

    context 'without placeholders' do
      let(:tpl) { '/assets/styles/blog.css' }
      it { should eq '/assets/styles/blog.css' }
    end

    context 'with one parameter' do
      let(:data) { {slug: 'a-blog-title'} }
      let(:tpl) { '/blog/:slug/' }
      it { should eq '/blog/a-blog-title/' }
    end

    context 'with multiple parameters' do
      let(:data) { {slug: 'a-blog-title', year: 2013, month: 12} }
      let(:tpl) { '/blog/:year/:month/:slug/' }
      it { should eq '/blog/2013/12/a-blog-title/' }
    end
  end

  describe '#relative_target_path' do
    let(:url_template) { Path.new url }
    subject { blob.relative_target_path }

    context 'with full file URL' do
      let(:url) { '/assets/styles/blog.css' }
      it { should eq '/assets/styles/blog.css' }
    end

    context 'with directory URL' do
      let(:url) { '/blog/2013/12/a-blog-post/' }
      it { should eq '/blog/2013/12/a-blog-post/index.html' }
    end
  end

  describe '#mime_type' do
    subject { blob.mime_type }
    let(:path) { 'file' }
    let(:url_template) { Path.new path }

    it 'should return MIME::Type' do
      should be_a MIME::Type
    end

    context 'with .css file' do
      let(:path) { 'files/css/style.css' }
      it { expect(subject.to_s).to eq 'text/css' }
    end

    context 'with .html file' do
      let(:path) { 'files/index.html' }
      it { expect(subject.to_s).to eq 'text/html' }
    end

    context 'with .js file' do
      let(:path) { 'files/js/jquery.js' }
      it { expect(subject.to_s).to eq 'application/javascript' }
    end
  end

  describe '#target_path' do
    let(:url_template) { Path.new path }
    before { allow(site).to receive(:target).and_return(Path.new('/path/to/stic-site')) }
    subject { blob.target_path }

    context 'with path' do
      let(:path) { 'files/css/style.css' }
      it { should eq '/path/to/stic-site/files/css/style.css' }
    end
  end

  describe '#write' do
    around { |example| within_temporary_fixture_base(&example) }
    let(:target_path) { Path.new fixture_path '/path/to/file.html' }
    let(:content) { 'Just some content!' }

    before { allow(blob).to receive(:target_path).and_return(target_path) }
    before { allow(blob).to receive(:render).and_return(content) }

    it 'should create directories and file' do
      blob.write
      expect(File.directory?(fixture_path '/path/to')).to be true
      expect(File.file?(fixture_path '/path/to/file.html')).to be true
    end

    it 'should write content to file' do
      blob.write
      expect(File.read(fixture_path '/path/to/file.html'))
        .to eq 'Just some content!'
    end
  end
end
