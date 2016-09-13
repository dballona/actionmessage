module ActionMessage
  module Adapters
    class Test < Base
      def initialize(params={})
        super(params)
      end

      def client
        @client ||= OpenStruct.new
      end

      def send_message(body, params={})
        raise ArgumentError, 'you should include a receipient for sending messages' unless params[:to].present?

        @to = params[:to]
        puts "Sending message to #{@to}"
      end
    end
  end
end
