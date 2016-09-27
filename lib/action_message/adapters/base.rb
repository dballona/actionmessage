module ActionMessage
  module Adapters
    class Base
      def initialize(params={})
        @params = params
      end

      def send_message(_body, _params={})
        raise ArgumentError, 'You should provide at least one phone for sending messages' if !senders.present?
        @from = pick_sender
      end

      def status_callback
        @status_callback ||= @params[:status_callback].presence || ActionMessage::Base.options[:status_callback]
      end

      def status_callback?
        status_callback.present?
      end

      def senders
        @senders ||= @params[:from].present? ? @params[:from] : ActionMessage::Base.options[:from]
      end

      private
        def pick_sender
          senders.is_a?(String) ? senders : senders.shuffle.sample
        end
    end
  end
end
