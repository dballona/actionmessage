module ActionMessage
  class Message
    attr_accessor :headers, :action, :args, :body, :to

    VIEW_PATHS = %w(app/views app/views/messages app/views/mailers app/views/application app/views/layouts)

    def initialize(params = {})
      @headers = params[:headers]
      @body = params[:body]
      @to = params[:to]
      @adapter = Adapters.adapter
    end

    def deliver
      puts "Sending message \"#{body}\" to number #{to}"
      @adapter.send_message(body, to: to)
    end

    def view_paths
      VIEW_PATHS
    end
  end
end
