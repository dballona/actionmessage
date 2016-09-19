require 'action_message/adapters/base'
require 'action_message/adapters/test'
require 'action_message/adapters/twilio'

module ActionMessage
  module Adapters
    class << self
      def adapter_klass
        @@adapter_klass ||= adapter_params[:name].to_s.capitalize
      end

      def adapter_params
        @@adapter_params ||= ActionMessage::Base.default_params[:adapter]
      end

      def adapter_credentials
        @@adapter_credentials ||= adapter_params[:credentials]
      end

      def adapter
        @@adapter ||= const_get(adapter_klass).new(adapter_credentials)
      end
    end
  end
end
