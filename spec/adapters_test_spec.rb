require 'spec_helper'

describe ActionMessage::Adapters::Test do
  let(:credentials) { { something: 'this' } }
  subject { ActionMessage::Adapters::Test.new(credentials) }

  context 'instance methods' do
    it '#initialize' do
      expect(subject.instance_variable_get(:@params)).to eq(credentials)
    end

    it '#send_message' do
      sender = '+11111111111'
      expect(subject).to receive(:senders).thrice.and_return(sender)
      subject.send_message('Body')
      expect(subject.instance_variable_get(:@from)).to eq(sender)
    end
  end
end
