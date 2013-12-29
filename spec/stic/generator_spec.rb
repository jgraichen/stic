require 'spec_helper'

describe Stic::Generator do
  let(:site) { double('site') }
  let(:name) { 'MyCustomGenerator' }
  let(:generator) { Stic::Generator.new site }
  before { allow(generator.class).to receive(:name).and_return(name) }

  describe '#name' do
    subject { generator.name }

    it { should eq 'my_custom' }
  end

  describe '#config' do
    let(:config) { ::Stic::Config.new({'generators' => {'my_custom' => {'key' => 'value'}}}) }
    before { allow(site).to receive(:config).and_return(config) }
    subject { generator.config }

    it { should eq 'key' => 'value' }
    it { should be_a HashWithIndifferentAccess }
  end
end
