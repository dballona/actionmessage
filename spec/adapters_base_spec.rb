require 'spec_helper'

describe ActionMessage::Adapters::Base do
  let(:credentials) { { something: 'this' } }
  subject { ActionMessage::Adapters::Base.new(credentials) }

  context 'instance methods' do
    it '#initialize' do
      expect(subject.instance_variable_get(:@params)).to eq(credentials)
    end

    describe '#send_message' do
      let(:body) { 'This is a message!' }

      it 'raises an error if no senders' do
        expect(subject).to receive(:senders).and_return(nil)
        expect { subject.send_message(body) }.to raise_error(ArgumentError)
      end

      it 'sets receipient if senders present' do
        from = '+11231231234'
        expect(subject).to receive(:senders).thrice.and_return(from)
        subject.send_message(body)
        expect(subject.instance_variable_get(:@from)).to eq(from)
      end
    end

    describe '#senders' do
      let(:sender) { '+11111111111' }
      let(:config_sender) { '+19999999999' }

      it 'prioritizes params provided sender' do
        allow(ActionMessage::Base).to receive_message_chain(:options, :[], :from).and_return(config_sender)
        subject.instance_variable_set(:@params, subject.instance_variable_get(:@params).merge(from: sender))

        expect(subject.senders).to eq(sender)
      end

      it 'uses configured sender if no sender is sent via params' do
        expect(ActionMessage::Base).to receive_message_chain(:options, :[]).and_return(config_sender)
        expect(subject.senders).to eq(config_sender)
      end
    end

    describe '#pick_sender' do
      let(:sender) { '+11111111111' }
      let(:config_sender) { '+19999999999' }

      it 'uses a sample if Array' do
        senders = [sender, config_sender]
        expect(subject).to receive(:senders).twice.and_return(senders)
        expect(senders).to include(subject.send(:pick_sender))
      end

      it 'uses the value passed if String' do
        expect(subject).to receive(:senders).twice.and_return(sender)
        expect(subject.send(:pick_sender)).to eq(sender)
      end
    end
  end
end
