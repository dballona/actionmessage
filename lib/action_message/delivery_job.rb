require 'active_job'

module ActionMessage
  class DeliveryJob < ActiveJob::Base
    queue_as { :messages }

    rescue_from StandardError, with: :handle_exception_with_message_class

    def perform(message, message_method, delivery_method, *args) #:nodoc:
      message.constantize.public_send(message_method, *args).send(delivery_method)
    end

    private
      def message_class
        if message = Array(@serialized_arguments).first || Array(arguments).first
          message.constantize
        end
      end

      def handle_exception_with_message_class(exception)
        if klass = message_class
          klass.handle_exception exception
        else
          raise exception
        end
      end
  end
end
