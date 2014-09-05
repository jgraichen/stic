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

  context 'with invalid YAML in frontmatter' do
    let(:blob) do <<EOF.strip_heredoc
      ---
      yaml: false
        abc: 8475 fhffj
      ---
      CONTENT
EOF
    end

    it 'should raise error' do
      expect { subject }.to raise_error Stic::InvalidMetadata, /Invalid metadata in/
    end

    it 'should have Psych error as cause' do
      begin
        subject
      rescue => err
        expect(err.cause).to be_a Psych::SyntaxError
      end
    end
  end
end
