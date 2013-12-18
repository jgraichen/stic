require 'spec_helper'

describe Stic::Blob do
  let(:data) { nil }
  let(:blob) { Stic::Blob.new site: double('site'), data: data }

  describe '#relative_url' do
    before { blob.stub(:url_template).and_return(tpl) }
    subject { blob.relative_url }

    context 'without placeholders' do
      let(:tpl) { '/assets/styles/blog.css' }
      it { should eq '/assets/styles/blog.css' }
    end

    context 'with one parameter' do
      let(:data) { {slug: "a-blog-title"} }
      let(:tpl) { '/blog/:slug/' }
      it { should eq '/blog/a-blog-title/' }
    end

    context 'with multiple parameters' do
      let(:data) { {slug: "a-blog-title", year: 2013, month: 12} }
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
end
