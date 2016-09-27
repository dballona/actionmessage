module ActionMessage
  module Adapters
    class Test < Base
      def initialize(params={})
        super(params)
      end

      def send_message(body, params={})
        super(body, params)
        puts "Sending message to #{params[:to]}"
      end

      class << self
        def status_callback_mapping(params)
          params
        end
      end
    end
  end
end
