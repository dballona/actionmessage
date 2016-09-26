module Rails
  module Generators
    class MessageGenerator < NamedBase
      source_root File.expand_path("../templates", __FILE__)

      argument :actions, type: :array, default: [], banner: "method method"

      check_class_collision suffix: "Message"

      def create_message_file
        template "message.rb", File.join("app/messages", class_path, "#{file_name}_message.rb")
      end

      protected
        def file_name
          @_file_name ||= super.gsub(/_messag/i, '')
        end
    end
  end
end
