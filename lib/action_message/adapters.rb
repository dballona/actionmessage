require 'action_message/adapters/base'
require 'action_message/adapters/test'
require 'action_message/adapters/twilio'

module ActionMessage
	module Adapters
		class << self
			def adapter
				adapter_params = ActionMessage::Base.default_params[:adapter]
				const_get(adapter_params[:name].to_s.capitalize).new(adapter_params[:credentials])
			end
		end
	end
end
