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
      unless debug?
        # TODO: add logger 'Sendimg message from "number" to "number"'
        adapter.send_message(body, to: to)
      end
    end
  end
end
