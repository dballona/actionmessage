require 'action_message'

class MerchantMessage < ActionMessage::Base
	def send_welcome_sms(name)
		@name = name
		sms(to: "+5531982726767")
	end
end
