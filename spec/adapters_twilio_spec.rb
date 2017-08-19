require 'spec_helper'

describe ActionMessage::Adapters::Test do
  let(:credentials) { { account_sid: '123', auth_token: '456' } }
  subject { ActionMessage::Adapters::Twilio.new(credentials) }

  context 'instance methods' do
    it '#initialize' do
      expect(subject.instance_variable_get(:@params)).to eq(credentials)
      expect(subject.instance_variable_get(:@account_sid)).to eq(credentials[:account_sid])
      expect(subject.instance_variable_get(:@auth_token)).to eq(credentials[:auth_token])
    end

    it '#client' do
      expect(subject.client).to be_a(Twilio::REST::Client)
    end

    describe '#send_message' do
      let(:to) { '+11111111111' }
      let(:from) { '+12222222222' }
      let(:body) { 'Body' }

      before do
        expect(subject).to receive(:senders).thrice.and_return(from)
        stub_request(:post, /.*twilio.*123\/Messages.json/).to_return(status: 200, body: "{}", headers: {})
      end

      it 'when no media_url' do
        sms = { to: to, from: from, body: body  }
        expect(subject.client).to receive_message_chain(:api, :account, :messages, :create).with(sms)
        subject.send_message(body, to: to)
      end

      it 'when media_url present' do
        media_url = 'http://goo.gl/123123'
        sms = { to: to, from: from, body: body, media_url: media_url  }
        expect(subject.client).to receive_message_chain(:api, :account, :messages, :create).with(sms)
        subject.send_message(body, to: to, media_url: media_url)
      end
    end
  end
end
