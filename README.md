# ActionMessage

ActionMessage is heavily-inspired on ActionMailer.
It's a gem for sending SMS/Text messages like we do for sending e-mails on ActionMailer.
Pull requests are more than welcome!

[![Gem Version](https://badge.fury.io/rb/actionmessage.svg)](https://badge.fury.io/rb/actionmessage)
[![Build Status](https://travis-ci.org/dballona/actionmessage.svg?branch=master)](https://travis-ci.org/dballona/actionmessage)
[![codecov](https://codecov.io/gh/dballona/actionmessage/branch/master/graph/badge.svg)](https://codecov.io/gh/dballona/actionmessage)
[![Code Climate](https://codeclimate.com/github/dballona/actionmessage/badges/gpa.svg)](https://codeclimate.com/github/dballona/actionmessage)

## Setup

Install it using bundler:

```ruby
# Gemfile
gem 'actionmessage'
```

If you're using Rails, place this on your environment file or application.rb

```ruby
require 'action_message/railtie'

config.action_message = {
  # sender in international format you can also pass an array and it will
  # shuffle and randomly pick one number.
  from: "+11231231234",

  # adapter information. Right now we only support Twilio.
  adapter: { 
    name: :twilio,
    credentials: {
      account_sid: 'MY TWILIO ACCOUNT SID'.freeze,
      auth_token: 'MY AUTH TOKEN'.freeze
    }
  }
}
```

## Usage

In order to generate your message class, you can either place this code
under app/messages/welcome_message.rb or just use our generators by running
the following command: `rails g message Welcome send_welcome_sms`

```ruby
class WelcomeMessage < ActionMessage::Base
  def send_welcome_sms(name, phone_number_to_send_message)
    @name = name
    sms(to: phone_number_to_send_message)
  end

  # Inline body example, body parameter has preference compared
  # to a text.erb template.
  def welcome_with_inline_body(name, phone_number_to_send_message)
    @name = name
    sms(to: phone_number_to_send_message, body: 'Inline body!')
  end

  # While on development environment, you can use debug: true to
  # prevent sending SMS and spending funds on your Twilio account.
  def welcome_with_debug_mode(name, phone_number_to_send_message)
    @name = name
    sms(to: phone_number_to_send_message, debug: true)
  end
end
```

Define your views under your view path, such as: `app/views/welcome_message/send_welcome_sms.text.erb`

```html
Welcome, <%= @name %>!
```

And to send is really simple!

```ruby
name = 'John Doe'
phone = '+11231231234'

# To send right away:
WelcomeMessage.send_welcome_sms(name, phone).deliver_now

# To send through a background job
WelcomeMessage.send_welcome_sms(name, phone).deliver_later

```

## Interceptors

In order to prevent sending messages to a specific number or containing any specific text on it's body you can use Interceptors:

```ruby
# You can use strings (exact comparison)
ActionMessage::Interceptor.register(to: 'number I want to prevent sending messages')

# Regular expressions
ActionMessage::Interceptor.register(body: /something innapropriate/i)

# Pass Multiple arguments on the same call
ActionMessage::Interceptor.register(to: '+11231231234', body: /anything/i)
```