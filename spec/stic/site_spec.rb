require 'spec_helper'

describe Stic::Site do
  let(:source) { '/site/src' }
  let(:config) { double('config') }
  let(:site)   { ::Stic::Site.new source, config }
  before { allow(config).to receive(:[]).with('generators').and_return(nil) }

  describe '#source' do
    subject { site.source }

    it { should be_a Path }
    it { expect(subject.to_s).to eq '/site/src' }
  end

  describe '#target' do
    subject { site.target }

    it { should be_a Path }
    it { expect(subject.to_s).to eq '/site/src/site' }
  end

  describe '#blobs' do
    let(:opts)  { Hash.new }
    let(:blobs) { (0..4).map{ Object.new } }
    subject { site.blobs opts }

    before { blobs.each{|b| site << b } }
    it { expect(subject.size).to eq 5 }
    it { expect(subject).to eq blobs }

    context 'with type options' do
      let(:blobs) { [Exception.new, StandardError.new, NameError.new, Object.new] }

      it 'should filter by class' do
        expect(site.blobs(type: StandardError)).to eq blobs[1..2]
      end
    end
  end

  describe '#generators' do
    let(:generator_class) { double('Generator') }
    let(:generator) { double('generator') }
    let(:config) { {'key' => 'val'} }
    before { allow(config).to receive(:[]).with('generators').and_return(config) }
    subject { site.generators }

    it 'should create an instance all registered generators' do
      expect(::Stic::Site).to receive(:generators).and_return([generator_class])
      expect(generator_class).to receive(:new).with(kind_of(::Stic::Site), config).and_return(generator)

      expect(subject).to eq [generator]
    end
  end

  describe '#run' do
    let(:generator)  { double('generator') }
    let(:generators) { [generator] }
    before  { allow(site).to receive(:generators).and_return(generators) }
    before  { allow(generator).to receive(:run) }

    it 'should invoke generators' do
      expect(generator).to receive(:run)
      site.run
    end

    it 'should pass generator to passed block' do
      block = proc{}
      expect(block).to receive(:call).with(generator)
      site.run(&block)
    end

    it 'should return self' do
      expect(site.run).to equal site
    end
  end

  describe '#write' do
    let(:blob)  { double('blob') }
    let(:blobs) { [blob] }
    before  { allow(site).to receive(:blobs).and_return(blobs) }
    before  { allow(blob).to receive(:write) }

    it 'should write blob' do
      expect(blob).to receive(:write)
      site.write
    end

    it 'should pass blob to passed block' do
      block = proc{}
      expect(block).to receive(:call).with(blob)
      site.write(&block)
    end

    it 'should return self' do
      expect(site.write).to equal site
    end
  end

  describe '#cleanup' do
    it 'should return self' do
      expect(site.cleanup).to equal site
    end
  end

  describe '#class' do
    describe '#generators' do
      subject { described_class.generators }

      it 'should contain list (of generators)' do
        expect(subject).to be_kind_of Array
      end
    end

    describe '#lookup' do
      let(:dir)    { Dir.pwd }
      let(:args)   { [] }
      let(:config) { double('config') }
      subject { described_class.lookup(*args) }
      before do
        Path.mock do |root, backend|
          root.mkfile('stic.yaml').write YAML.dump({})
          Path.getwd.mkfile('my/magic/stic.yml').write YAML.dump({})
          Path.getwd.mkpath('my/magic/path').expand
        end
      end

      context 'without args' do
        it 'should return ::Stic::Site' do
          expect(subject).to be_a ::Stic::Site
        end

        it 'its source should be dir with found yaml' do
          expect(subject.source).to eq '/'
        end
      end

      context 'with given path' do
        let(:args) { ['my/magic/path'] }

        it 'should return matching site' do
          expect(subject.source).to eq Path('my/magic').expand
        end
      end
    end
  end
end
