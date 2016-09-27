require 'sinatra'

module ActionMessage
  class Web < ::Sinatra::Base
    include ActionMessage::Tracker::Helpers

    set :root, File.dirname(__FILE__)
    set :views, -> { File.join(root, 'web', 'views') }

    set :static, true
    set :public_folder, -> { File.join(root, 'web', 'public') }

    before do
      Rails.application.eager_load! unless Web.production?
    end

    get '/' do
      @messages = tracker_klass.all
      erb :index
    end

    post '/' do
      content_type :json
      message = tracker_klass.track_message(params)
      message.to_json
    end
  end
end
