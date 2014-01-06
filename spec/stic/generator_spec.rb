require 'spec_helper'

describe Stic::Generator do
  let(:site)   { double('site') }
  let(:name)   { 'MyCustomGenerator' }
  let(:config) { {} }
  let(:generator) { described_class.new site, config }
  before { allow(described_class).to receive(:name).and_return(name) }

  describe '#name' do
    subject { generator.name }

    it { should eq 'my_custom' }
  end

  describe '#config' do
    let(:config) { {'my_custom' => {'key' => 'value'}} }
    subject { generator.config }

    it { should eq 'key' => 'value' }
    it { should be_a HashWithIndifferentAccess }
  end
end
