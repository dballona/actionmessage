module ActionMessage
  include ActionMessage::Adapters

  class Message
    attr_accessor :headers, :action, :args, :body, :to, :debug
    attr_reader :adapter

    def initialize
      @adapter = Adapters.adapter
    end

    def debug?
      !!@debug
    end

    def deliver
      puts "Sending message \"#{body}\" to number #{to}" # TODO: Switch to a decent logger
      adapter.send_message(body, to: to) # unless debug?
    end
  end
end
