require 'spec_helper'

describe Stic::File do
  let(:source) { '/full/path/to/file.txt' }
  let(:path)   { 'to/file.txt' }
  let(:site)   { double('site') }
  let(:name)   { nil }
  let(:args)   { {site: site, source: source, path: path, name: name} }
  let(:file)   { ::Stic::File.new args }
  subject { file }

  describe '#source' do
    subject { file.source }

    it { should be_a ::Path }
    it { expect(subject.to_s).to eq '/full/path/to/file.txt' }

    context 'when initialized with relative path' do
      let(:source) { 'to/file.txt' }

      it 'should be converted to absolute path' do
        expect(subject.to_s).to eq '/root/to/file.txt'
      end
    end
  end

  describe '#path' do
    subject { file.path }

    it { should be_a ::Path }
    it { expect(subject.to_s).to eq 'to/file.txt' }

    context 'when initialized with leading slash' do
      let(:path) { '/to/file.txt' }

      it 'should be converted to relative path' do
        expect(subject.to_s).to eq 'to/file.txt'
      end
    end
  end

  describe '#name' do
    subject { file.name }

    it { should eq 'file.txt' }

    context 'when initialized with name' do
      let(:name) { 'index.html' }
      it { should eq 'index.html' }
    end
  end

  describe '#source_path' do
    subject { file.source_path }

    it { should be_a ::Path }
    it { expect(subject.to_s).to eq '/full/path/to/file.txt' }
  end

  describe '#url_template' do
    let(:path) { 'path/to/source.txt' }
    let(:name) { 'styles.css' }
    subject { file.url_template }

    it { should eq '/path/to/styles.css' }
  end

  describe '#render' do
    before { expect(file).to receive(:content).and_return('CONTENT!') }
    subject { file.render }

    it { should eq 'CONTENT!' }
  end

  describe '#content' do
    before { expect(file).to receive(:read).once.and_return('CONTENT!') }
    subject { file.content }

    it { should eq 'CONTENT!' }
    it 'should cache red content' do
      expect(subject).to eq 'CONTENT!'
      expect(subject).to eq 'CONTENT!'
      expect(subject).to eq 'CONTENT!'
    end
  end

  describe '#read' do
    before { allow(site).to receive(:source).and_return(Path('source')) }
    before { Path('/full/path/to/file.txt').mkfile.write 'CONTENT!' }
    subject { file.read }

    it { should eq 'CONTENT!' }
  end
end
