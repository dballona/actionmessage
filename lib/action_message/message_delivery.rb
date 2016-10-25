module ActionMessage
  class MessageDelivery
    attr_reader :message_class, :action, :args

    def initialize(message_class, action, *args)
      @message_class, @action, @args = message_class, action, args
    end

    def deliver_now
      processed_sms.send(action, *args).deliver
    end

    protected
      def processed_sms
        @processed_sms ||= @message_class.new.tap do |message|
          message.template_path = @message_class.name.underscore
          message.template_name = action.to_s
        end
      end
  end
end
