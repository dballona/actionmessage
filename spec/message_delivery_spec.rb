require 'spec_helper'
require 'support/messages/base_message'

describe ActionMessage::MessageDelivery do
  let(:message_class) { BaseMessage }
  let(:action) { :welcome_with_two_arguments }
  let(:args) { ['John Doe', 'johnshoes.com'] }
  subject { ActionMessage::MessageDelivery.new(message_class, action, *args) }

  context 'reader attributes' do
    %w(message_class action args).each do |attribute|
      it ":#{attribute}" do
        expect(subject).to respond_to(attribute)
        expect(subject).not_to respond_to(:"#{attribute}=")
      end
    end
  end

  context 'instance methods' do
    describe '#initialize' do
      it 'sets up #message_class' do
        expect(subject.message_class).to eq(message_class)
      end

      it 'sets up #action' do
        expect(subject.action).to eq(action)
      end

      it 'sets up #args' do
        expect(subject.args).to eq(args)
      end
    end

    it '#deliver_now' do
      message = double
      expect_any_instance_of(message_class).to receive(:welcome_with_two_arguments).with(*args).and_return(message)
      expect(message).to receive(:deliver).and_return('Sent!')
      expect(subject.deliver_now).to eq('Sent!')
    end

    it '#deliver_later' do
      job = double
      expect(ActionMessage::DeliveryJob).to receive(:set).and_return(job)
      expect(job).to receive(:perform_later).with(message_class.to_s, action.to_s, 'deliver_now', *args)
      subject.deliver_later
    end

    it '#processed_sms' do
      message = subject.send(:processed_sms)
      expect(message).to be_a(BaseMessage)
      expect(message.template_name).to eq('welcome_with_two_arguments')
    end
  end
end
