require 'spec_helper'

describe ActionMessage::Adapters do
  context 'class methods' do
    subject { ActionMessage::Adapters }

    it '.adapter_klass' do
      klass_name = ActionMessage::Base.options[:adapter][:name].to_s.capitalize
      expect(subject.adapter_klass).to eq(klass_name)
      expect(subject.class_variable_get(:@@adapter_klass)).to eq(klass_name)
    end

    it '.adapter_params' do
      params = ActionMessage::Base.options[:adapter]
      expect(subject.adapter_params).to eq(params)
      expect(subject.class_variable_get(:@@adapter_params)).to eq(params)
    end

    it '.adapter_credentials' do
      params = ActionMessage::Base.options[:adapter][:credentials]
      expect(subject.adapter_credentials).to eq(params)
      expect(subject.class_variable_get(:@@adapter_credentials)).to eq(params)
    end

    it '.adapter' do
      credentials = { something: 'this' }

      expect(subject).to receive(:adapter_klass).and_return('Test')
      expect(subject).to receive(:adapter_credentials).and_return(credentials)

      expect(subject.adapter).to be_an(ActionMessage::Adapters::Test)
      expect(subject.adapter.instance_variable_get(:@params)).to eq(credentials)
    end
  end
end
