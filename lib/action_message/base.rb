require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/anonymous'

module ActionMessage
  class Base < AbstractController::Base

    abstract!

    include AbstractController::Rendering
    include AbstractController::Logger
    include AbstractController::Callbacks

    include ActionView::Layouts

    class << self

      class_attribute :options
      self.options = {
        adapter: {
          name: :test,
          credentials: {}
        }
      }

      def default_options=(params = {})
        self.options = options.merge(params).freeze
        options
      end

      def base_paths
        %w(
          app/views 
          app/views/messages 
          app/views/mailers 
          app/views/application 
          app/views/layouts
        ).freeze
      end

      protected
        def method_missing(method_name, *args) # :nodoc:
          MessageDelivery.new(self, method_name, *args) rescue super
        end
    end

    attr_internal :message
    attr_accessor :template_name

    def initialize
      super
      @_message_was_called = false
      @_message = Message.new
    end

    def sms(params = {}, &block)
      raise ArgumentError, 'You need to provide at least a receipient' if params[:to].blank?
      return message if @_message_was_called && !block
      
      @_message_was_called = true

      lookup_context.view_paths = (lookup_context.view_paths.to_a + self.class.base_paths).uniq

      message.to = params[:to]
      message.debug = params[:debug]
      message.body = render(template_name)

      message
    end
  end
end
