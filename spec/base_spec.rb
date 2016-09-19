require 'spec_helper'

describe ActionMessage::Base do
  it 'inherits from AbstractController::Base' do
    expect(subject.class.superclass).to eq(AbstractController::Base)
  end

  context 'included modules' do
    %w(
      AbstractController::Rendering 
      AbstractController::Logger 
      AbstractController::Callbacks 
      ActionView::Layouts
    ).each do |module_name|
      it "includes #{module_name}" do
        expect(subject.class.included_modules).to include(module_name.constantize)
      end
    end
  end

  context 'class methods' do
    it '.default_params' do
      expect(subject.class.default_params).to eq({
        adapter: {
          name: :test,
          credentials: {}
        }
      })
    end

    describe '.default' do
      it 'should merge values passed to .default_params' do
        expect(subject.class.default_params[:adapter]).to eq({name: :test, credentials: {}})
        subject.class.default(adapter: { name: :twilio, credentials: {a: :b} })
        expect(subject.class.default_params[:adapter]).to eq({name: :twilio, credentials: {a: :b}})
      end

      it 'should be aliased with .default_options=' do
        expect(subject.class.method(:default)).to eq(subject.class.method(:default_options=))
      end
    end

    it '.base_paths' do
      base_paths = %w(
        app/views 
        app/views/messages 
        app/views/mailers 
        app/views/application 
        app/views/layouts
      )
      
      expect(subject.class.base_paths).to eq(base_paths)
    end

    describe '.method_missing' do
      it 'should instantiate MessageDelivery when .action_methods include the method' do
        message_delivery = subject.class.an_action_method('argument1', 'argument2')
        expect(message_delivery).to be_an(ActionMessage::MessageDelivery)
        expect(message_delivery.action).to eq(:an_action_method)
        expect(message_delivery.args).to eq(['argument1', 'argument2'])
      end
    end
  end

  context 'instance methods' do
    it '#initialize' do
      expect(subject.instance_variable_get(:@_message_was_called)).to be_falsey
      expect(subject.instance_variable_get(:@_message)).to be_an(ActionMessage::Message)
    end

    describe '#sms' do
      let(:to) { '+11231231234' }

      before do
        allow(subject).to receive(:render).and_return('Just an unit test')
      end

      it 'should raise an error if no receipient was passed' do
        expect { subject.sms }.to raise_error(ArgumentError)
      end

      it 'should change internal attribute @_message_was_called to true' do
        subject.sms(to: to)
        expect(subject.instance_variable_get(:@_message_was_called)).to be_truthy
      end

      it 'should set message headers' do
        subject.sms(to: to)
        expect(subject.instance_variable_get(:@_message_was_called)).to be_truthy
      end

      it 'should pass .base_paths to LookupContext' do
        expect(subject.class).to receive(:base_paths).and_call_original
        expect_any_instance_of(ActionView::LookupContext).to receive(:view_paths=).twice.and_call_original
        subject.sms(to: to)
      end

      it 'sets message #to' do
        expect(subject.sms(to: to).to).to eq(to)
      end

      it 'sets message #debug' do
        expect(subject.sms(to: to, debug: false).debug).to be_falsey
      end

      it 'sets message #body' do
        expect(subject).to receive(:render).and_return('Message body')
        expect(subject.sms(to: to).body).to eq('Message body')
      end
    end
  end
end
