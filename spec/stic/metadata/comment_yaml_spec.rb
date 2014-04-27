require 'spec_helper'

describe Stic::Metadata::CommentYaml do
  let(:parser) { described_class.new }
  let(:file)   { double 'file' }
  let(:path)   { Path 'file.txt' }
  subject { parser.parse(file, blob) }
  before { allow(file).to receive(:path).and_return(path) }

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

  context 'with frontmatter (3)' do
    let(:blob) do <<EOF.strip_heredoc
      # A New Adventure: Bob's Crisis
      CONTENT
EOF
    end
    let(:path)   { Path 'file.md' }

    it { should eq nil }
  end
end
