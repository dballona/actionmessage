require 'abstract_controller'

require 'action_message/adapters'
require 'action_message/base'
require 'action_message/delivery_job'
require 'action_message/message'
require 'action_message/message_delivery'
require 'action_message/version'

require 'active_support/rails'

module ActionMessage; end

autoload :Mime, 'action_dispatch/http/mime_type'

ActiveSupport.on_load(:action_view) do
  ActionView::Base.default_formats ||= Mime::SET.symbols
  ActionView::Template::Types.delegate_to Mime
end
