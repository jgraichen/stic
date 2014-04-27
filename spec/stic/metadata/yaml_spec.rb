require 'spec_helper'

describe Stic::Metadata::Yaml do
  let(:parser) { described_class.new }
  let(:file)   { double 'file' }
  subject { parser.parse(file, blob) }

  context 'with YAML frontmatter' do
    let(:blob) do <<EOF.strip_heredoc
      ---
      yaml: true
      ---
      CONTENT
EOF
    end

    it { should eq [{'yaml' => true}, "CONTENT\n"] }
  end
end
