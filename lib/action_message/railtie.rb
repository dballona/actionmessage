require "action_message"
require "rails"

module ActionMessage
  class Railtie < Rails::Railtie # :nodoc:
    config.action_message = ActiveSupport::OrderedOptions.new
    # config.eager_load_namespaces << ActionMessage

    initializer "action_message.set_configs" do |app|
      options = app.config.action_message

      ActiveSupport.on_load(:action_message) do
        options.each { |k,v| send("#{k}=", v) }
      end
    end

    config.after_initialize do |app|
      ActionMessage::Base.default_options = app.config.action_message
    end
  end
end

