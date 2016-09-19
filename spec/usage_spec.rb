require 'spec_helper'
require 'support/messages/base_message'

describe BaseMessage do
  context 'usage tests' do
    it 'when we are sending a message with one argument' do
      message_delivery = BaseMessage.welcome_with_one_argument('Diego')
      message = message_delivery.send(:processed_sms).send(:welcome_with_one_argument, 'Diego')
      expect(message.body).to eq('Welcome, Diego!')
    end

    it 'when we are sending a message with two arguments' do
      message_delivery = BaseMessage.welcome_with_two_arguments('Diego', 'Company')
      message = message_delivery.send(:processed_sms).send(:welcome_with_two_arguments, 'Diego', 'Company')
      expect(message.body).to eq('Welcome, Diego to Company!')
    end

    it 'when no to is provided' do
      message_delivery = BaseMessage.welcome_without_to('Diego')
      expect {
        message_delivery.send(:processed_sms).send(:welcome_without_to, 'Diego')
      }.to raise_error(ArgumentError, 'You need to provide at least a receipient')
    end
  end
end
