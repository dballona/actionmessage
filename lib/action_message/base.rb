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

      class_attribute :default_params
      self.default_params = {
        adapter: {
          name: :test,
          credentials: {}
        }
      }

      # Sets the defaults through app configuration:
      # config.action_message.default(from: "+11231231234")
      #
      # Aliased by ::default_options=
      #
      def default(value = nil)
        self.default_params = default_params.merge(value).freeze if value
        default_params
      end
      # Allows to set defaults through app configuration:
      # config.action_message = { charset: 'ISO-8859-1' }
      #
      alias :default_options= :default

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
    attr_accessor :template_name, :template_path

    def initialize
      super
      @_message_was_called = false
      @_message = Message.new
    end

    def sms(params = {}, &block)
      raise ArgumentError, 'You need to provide at least a receipient' if params[:to].blank?
      return message if @_message_was_called && !block

      self.template_name = params[:template_name].presence || template_name
      self.template_path = params[:template_path].presence || template_path
      
      @_message_was_called = true
      lookup_context.view_paths = (lookup_context.view_paths.to_a + self.class.base_paths).flatten.uniq

      message.to = params[:to]
      message.debug = params[:debug]
      message.body = render(full_template_path)

      message
    end

    def full_template_path
      [template_path, template_name].join('/')
    end
  end
end
