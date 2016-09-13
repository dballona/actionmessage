require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/anonymous'

module ActionMessage
  class Base < AbstractController::Base

    abstract!

    include AbstractController::Rendering
    include AbstractController::Logger
    include AbstractController::Callbacks
    include AbstractController::Caching

    include ActionView::Layouts

    class << self

      class_attribute :default_params
      self.default_params = {
        adapter: {
          name: :test,
          credentials: {}
        },
        mime_version: "1.0",
        charset:      "UTF-8"
      }

      # Sets the defaults through app configuration:
      #
      #     config.action_message.default(from: "+11231231234")
      #
      # Aliased by ::default_options=
      def default(value = nil)
        self.default_params = default_params.merge(value).freeze if value
        default_params
      end
      # Allows to set defaults through app configuration:
      #
      #    config.action_mailer.default_options = { from: "no-reply@example.org" }
      alias :default_options= :default

      def mailer_name
        @mailer_name ||= anonymous? ? 'anonymous' : name.underscore
      end
      # Allows to set the name of current mailer.
      attr_writer :mailer_name
      alias :controller_path :mailer_name

      protected
        def method_missing(method_name, *args) # :nodoc:
          if action_methods.include?(method_name.to_s)
            MessageDelivery.new(self, method_name, *args)
          else
            super
          end
        end
    end

    attr_internal :message
    attr_accessor :template_name

    def initialize
      super()
      @_message_was_called = false
      @_message = Message.new
    end

    def sms(params = {}, &block)
      return message if @_message_was_called && params[:to].blank? && !block
      @_message_was_called = true

      lookup_context.view_paths = message.view_paths

      message.headers = self.class.default_params.slice(:charset, :mime_version)
      message.to = params[:to]
      message.body = render(template_name)

      message
    end
  end
end
