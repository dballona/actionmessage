# ActionMessage

This is a pet project – an ActionMailer heavily-inspired gem for working with SMS/Text messages.
Pull requests are more than welcome!

[![Build Status](https://travis-ci.org/dballona/actionmessage.svg?branch=master)](https://travis-ci.org/dballona/actionmessage)
[![codecov](https://codecov.io/gh/dballona/actionmessage/branch/master/graph/badge.svg)](https://codecov.io/gh/dballona/actionmessage)


## Usage

Install it using bundler

```sh
# Gemfile
gem 'actionmessage'
```

or just require it:
```sh
gem install actionmessage
require 'action_message'
```

If you're using Rails, place this on your environment file or application.rb
```ruby
require 'action_message/railtie'

config.action_message = {
	from: "number to send from in international format, e.g.: +11231231234", 
	adapter: { 
		name: :twilio,
		credentials: {
			account_sid: 'MY TWILIO ACCOUNT SID'.freeze,
			auth_token: 'MY AUTH TOKEN'.freeze
		}
	}
}
```

Put this for example, under app/messages/merchant_message.rb
```ruby
class MerchantMessage < ActionMessage::Base
	def send_welcome_sms(name)
		@name = name
		sms(to: "+5531982726767")
	end
end
```

Define your views under your view path, such as: app/views/merchant_message/send_welcome_sms.text.erb
```html
Welcome, <%= @name %>!!!
```

TODO:

- Add tests to what we've got already;
- Add background processing (deliver_later);
- Log instrumentation with ActiveSupport;
- Add generators;
- Add delivery methods;
- Add test helpers; 
- Add more adapters;
