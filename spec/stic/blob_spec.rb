require 'spec_helper'

describe Stic::Blob do
  let(:data) { nil }
  let(:site) { double('site') }
  let(:blob) { Stic::Blob.new site: site, data: data }

  describe '#relative_url' do
    before { blob.stub(:url_template).and_return(tpl) }
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
    before { blob.stub(:relative_url).and_return(url) }
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

  describe '#target_path' do
    before { blob.stub(:relative_target_path).and_return(path) }
    before { site.stub(:target).and_return(Pathname.new('/path/to/stic-site')) }
    subject { blob.target_path }

    context 'with path' do
      let(:path) { 'files/css/style.css' }
      it { should eq Pathname.new '/path/to/stic-site/files/css/style.css' }
    end
  end

  describe '#write' do
    let(:target_path) { '/path/to/file.html' }
    let(:content) { 'Just some content!' }

    before { blob.stub(:target_path).and_return(target_path) }
    before { blob.stub(:render).and_return(content) }

    it 'should create directories and file' do
      blob.write
      expect(File.directory?('/path/to')).to be_true
      expect(File.file?('/path/to/file.html')).to be_true
    end

    it 'should write content to file' do
      blob.write
      expect(File.read('/path/to/file.html')).to eq 'Just some content!'
    end
  end
end
