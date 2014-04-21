require 'spec_helper'

describe Stic::Layout do
  let(:site)    { double 'site' }
  let(:path)    { Path '/layouts/default.html.erb' }
  let(:layout)  { Stic::Layout.new site: site, source: path }
  let(:content) { '<default><%= yield %></default>' }
  before do
    Path.mock {|root, backend| path.mkfile.write content }
  end

  describe '#render' do
    let(:blob) { double 'blob' }
    before do
      allow(blob).to receive(:locals).and_return({})
      allow(blob).to receive(:render).and_return('CONTENT')
    end

    subject { layout.render blob }

    it { should eq '<default>CONTENT</default>' }
  end

  describe 'class' do
    describe '#load' do
      let(:source) { Path '/' }
      let(:config) { {} }

      before do
        Path.mock do |root, backend|
          backend.cwd = '/'

          dir = root.mkdir 'layouts'
          dir.touch 'default.erb'
          dir.touch 'post.slim'
          dir.touch 'author.haml'
        end
      end

      subject { Stic::Layout.load(site, source, config) }

      it { should have(3).items }
      it { should include 'default', 'post', 'author' }
    end
  end
end
