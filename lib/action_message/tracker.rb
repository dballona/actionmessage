module ActionMessage
  module Tracker
    extend ActiveSupport::Concern

    included do
      class << self
        def track_message(params)
          params.symbolize_keys!
          mapped_params = params_with_adapter_mapping(params)
          message = where(adapter_id: mapped_params.delete(:adapter_id)).first_or_initialize
          message.assign_attributes(mapped_params) && message.save
          message
        end

        def adapter_klass(params)
          @@adapter_klass ||= if params[:MessageSid].present?
            ActionMessage::Adapters::Twilio
          else
            ActionMessage::Adapters::Test
          end
        end

        private

        def params_with_adapter_mapping(params)
          self.adapter_klass(params).status_callback_mapping(params)
        end
      end
    end

    module Helpers
      def tracker_klass_selector
        ->(k) { k.included_modules.include?(ActionMessage::Tracker) }
      end

      def tracker_klass
        if defined?(ActiveRecord)
          ActiveRecord::Base.descendants.select(&tracker_klass_selector).first
        elsif defined?(Mongoid)
          Object.constants.collect { |sym| Object.const_get(sym) }
          .select{ |constant| constant.class == Class && constant.include?(Mongoid::Document) }
          .select(&tracker_klass_selector)
        else
          raise <<-ERROR.strip_heredoc
          We weren't able to discover your orm. Please make sure to include ActiveRecord
          or Mongoid as a dependency of your project and try again.
          ERROR
        end
      end
    end
  end
end
