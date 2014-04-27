require 'spec_helper'

describe Stic::Metadata::CommentYaml do
  let(:parser) { described_class.new }
  let(:file)   { double 'file' }
  subject { parser.parse(file, blob) }

  context 'with frontmatter (1)' do
    let(:blob) do <<EOF.strip_heredoc
      // yaml: true
      // val: 1
      CONTENT
EOF
    end

    it { should eq [{'yaml' => true, 'val' => 1}, "CONTENT\n"] }
  end

  context 'with frontmatter (2)' do
    let(:blob) do <<EOF.strip_heredoc
      # yaml: true
      # val: 1
      CONTENT
EOF
    end

    it { should eq [{'yaml' => true, 'val' => 1}, "CONTENT\n"] }
  end
end
