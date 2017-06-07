require 'spec_helper'

describe ActionMessage::Message do
  context 'accessor attributes' do
    %w(action args body to debug).each do |attribute|
      it ":#{attribute}" do
        value = Random.rand
        subject.send(:"#{attribute}=", value)
        expect(subject.send(attribute)).to eq(value)
      end
    end
  end

  context 'reader attributes' do
    it ':adapter' do
      expect(subject).to respond_to(:adapter)
      expect(subject).not_to respond_to(:adapter=)
    end
  end

  context 'instance methods' do
    it '#initialize' do
      expect(subject.adapter).to eq(ActionMessage::Adapters.adapter)
    end

    it '#debug?' do
      expect(subject.debug?).to be_falsey
      subject.debug = true
      expect(subject.debug?).to be_truthy
      subject.debug = nil
      expect(subject.debug?).to be_falsey
    end

    describe '#deliver' do
      it 'do not call send_message debug = true' do
        subject.debug = true
        expect_any_instance_of(ActionMessage::Adapters::Test).not_to receive(:send_message)
        expect(subject.deliver).to be_nil
      end

      it 'doesnt call send_message when interceptor registered' do
        subject.to = '+123456789'
        ActionMessage::Interceptor.register(to: subject.to)
        expect_any_instance_of(ActionMessage::Adapters::Test).not_to receive(:send_message)
        expect(subject.deliver).to be_nil
      end

      it 'call send_message if debug = false' do
        subject.debug = false
        expect_any_instance_of(ActionMessage::Adapters::Test).to receive(:send_message).and_return('called')
        expect(subject.deliver).to eq('called')
      end
    end
  end
end
