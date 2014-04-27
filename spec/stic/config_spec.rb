require 'spec_helper'

describe Stic::Config do
  let(:config) { Stic::Config.new }
  subject { config }

  describe '#load' do
    let(:action) { ->{ config.load(path) } }
    subject { action }

    context 'with non-existent file' do
      let(:path) { Path '/does/not/exist.yaml' }

      it { should_not change(config, :options) }
      it { should change(config, :files).to([path]) }
    end
  end
end
