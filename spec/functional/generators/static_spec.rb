require 'spec_helper'

describe 'Static Generator' do
  let(:site)      { ::Stic::Site.new '/', {} }
  let(:config)    { Hash.new }
  let(:generator) { ::Stic::Generators::Static.new site, config }
  before do
    Path.mock do |root, backend|
      root.mkfile '/files/stylesheets/main.css'
      root.mkfile '/files/stylesheets/typo.css'
    end
  end

  it 'should add static file blobs' do
    generator.run

    expect(site.blobs.size).to eq 2
    expect(site.blobs.map(&:source)).to match_array \
      %w(/files/stylesheets/main.css /files/stylesheets/typo.css)
  end
end
