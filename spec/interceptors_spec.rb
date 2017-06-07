require 'spec_helper'

describe ActionMessage::Interceptor do
  context 'class methods' do
    subject { ActionMessage::Interceptor }

    describe '#register' do
      it 'raises when anything other than hash provided' do
        expect { subject.register([]) }.to raise_error(TypeError)
        expect { subject.register('') }.to raise_error(TypeError)
        expect { subject.register(nil) }.to raise_error(TypeError)
      end

      describe 'works when hash provided' do
        let(:to) { '+11231231234' }
        let(:body) { Regexp.new(/sms/) }

        before { subject.blacklist = {} }

        it 'for string values' do
          subject.register(to: to)
          expect(subject.blacklist[:to]).to include(to)
        end

        it 'for regex values' do
          subject.register(body: body)
          expect(subject.blacklist[:body]).to include(body)
        end

        describe 'for multiple values' do
          before { subject.register(to: to, body: body) }

          it 'should include to rule' do
            expect(subject.blacklist[:to]).to include(to)
          end

          it 'should include body rule' do
            expect(subject.blacklist[:body]).to include(body)
          end
        end
      end
    end

    describe '#registered_for?' do
      let(:message) do
        message = ActionMessage::Message.new
        message.body = 'This is a message body'
        message.to = '+11231231234'
        message.debug = false

        message
      end

      before do
        subject.blacklist = {}
        subject.register(to: to, body: body)
      end

      describe 'when message matches the number' do
        let(:to) { '+11231231234' }
        let(:body) { Regexp.new(/anything/) }

        it 'should return true' do
          expect(subject.registered_for?(message)).to be_truthy
        end
      end

      describe 'when message matches the body' do
        let(:to) { '+987654321' }
        let(:body) { Regexp.new(/body/) }

        it 'should return true' do
          expect(subject.registered_for?(message)).to be_truthy
        end
      end

      describe 'when message does not match anything' do
        let(:to) { '+987654321' }
        let(:body) { Regexp.new(/anything/) }

        it 'should return false' do
          expect(subject.registered_for?(message)).to be_falsey
        end
      end
    end
  end
end
