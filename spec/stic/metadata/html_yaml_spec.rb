require 'spec_helper'

describe Stic::Metadata::HtmlYaml do
  let(:parser) { described_class.new }
  let(:file)   { double 'file' }
  subject { parser.parse(file, blob) }

  context 'with frontmatter (1)' do
    let(:blob) do <<EOF.strip_heredoc
      <!--
      yaml: true
      -->
      CONTENT
EOF
    end

    it { should eq [{'yaml' => true}, "CONTENT\n"] }
  end

  context 'with frontmatter (2)' do
    let(:blob) do <<EOF.strip_heredoc
      <!-- yaml: true -->
      CONTENT
EOF
    end

    it { should eq [{'yaml' => true}, "CONTENT\n"] }
  end

  context 'with frontmatter (3)' do
    let(:blob) do <<EOF.strip_heredoc
      <!--
      yaml: true
          -->
      CONTENT
EOF
    end

    it { should eq [{'yaml' => true}, "CONTENT\n"] }
  end

  context 'with frontmatter (4)' do
    let(:blob) do <<EOF.strip_heredoc
      <!-- yaml: "-->" -->
      CONTENT
EOF
    end

    it { should eq [{'yaml' => '-->'}, "CONTENT\n"] }
  end

  context 'with frontmatter (4)' do
    let(:blob) do <<EOF.strip_heredoc
      <!--yaml: "-->"-->
      CONTENT
EOF
    end

    it { should eq [{'yaml' => '-->'}, "CONTENT\n"] }
  end
end
