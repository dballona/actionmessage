# ActionMessage

ActionMessage is heavily-inspired on ActionMailer.
It's a gem for sending SMS/Text messages like we do for sending e-mails on ActionMailer.
Pull requests are more than welcome!

[![Gem Version](https://badge.fury.io/rb/actionmessage.svg)](https://badge.fury.io/rb/actionmessage)
[![Build Status](https://travis-ci.org/dballona/actionmessage.svg?branch=master)](https://travis-ci.org/dballona/actionmessage)
[![codecov](https://codecov.io/gh/dballona/actionmessage/branch/master/graph/badge.svg)](https://codecov.io/gh/dballona/actionmessage)
[![Code Climate](https://codeclimate.com/github/dballona/actionmessage/badges/gpa.svg)](https://codeclimate.com/github/dballona/actionmessage)

## Usage

Install it using bundler:

```ruby
# Gemfile
gem 'actionmessage'
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

In order to generate your message class, you can either place this code
under app/messages/welcome_message.rb or just use our generators by running
the following command: `rails g message Welcome send_welcome_sms`

```ruby
class WelcomeMessage < ActionMessage::Base
  def send_welcome_sms(name, phone_number_to_send_message)
    @name = name
    sms(to: phone_number_to_send_message)
  end
end
```

Define your views under your view path, such as: app/views/welcome_message/send_welcome_sms.text.erb

```html
Welcome, <%= @name %>!
```

And to send is really simple!

```rb
name = 'John Doe'
phone = '+11231231234'

# To send right away:
WelcomeMessage.send_welcome_sms(name, phone).deliver_now

# To send through a background job
WelcomeMessage.send_welcome_sms(name, phone).deliver_later
```