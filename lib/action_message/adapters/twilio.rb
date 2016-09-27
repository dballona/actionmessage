require 'twilio-ruby'

module ActionMessage
  module Adapters
    class Twilio < Base
      def initialize(params={})
        raise ArgumentError, 'account_sid is a mandatory setting for sending messages through Twilio' unless params[:account_sid].present?
        raise ArgumentError, 'auth_token is a mandatory setting for sending messages through Twilio' unless params[:auth_token].present?

        @account_sid = params[:account_sid]
        @auth_token = params[:auth_token]

        super(params)
      end

      def client
        @client = ::Twilio::REST::Client.new(@account_sid, @auth_token, @account_sid, :faraday)
        @client.http_client.adapter = :faraday
        @client
      end

      def send_message(body, params={})
        super(body, params)

        sms = {
          to: params[:to],
          from: @from,
          body: body
        }
        
        sms.merge!(media_url: params[:media_url]) if params[:media_url].present?

        client.account.messages.create(sms)
      end
    end
  end
end
