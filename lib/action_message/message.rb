module ActionMessage
  include ActionMessage::Adapters

  class Message
    attr_accessor :action, :args, :body, :to, :debug
    attr_reader :adapter

    def initialize
      @adapter = Adapters.adapter
    end

    def debug?
      !!@debug
    end

    def deliver
      if debug?
        # TODO: add log
        return nil
      elsif Interceptor.registered_for?(self)
        # TODO: add log
        return nil   
      else
        # TODO: add logger 'Sending message from "number" to "number"'
        adapter.send_message(body, to: to)
      end
    end
  end
end
