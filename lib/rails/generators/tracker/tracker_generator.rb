require 'rails/generators/active_record' if defined?(ActiveRecord)

module Rails
  module Generators
    NoOrmDetectedError = Class.new(StandardError)
    TrackerGeneratorBase = defined?(ActiveRecord) ? ActiveRecord::Generators::Base : Rails::Generators::NamedBase

    class TrackerGenerator < TrackerGeneratorBase
      source_root File.expand_path("../templates", __FILE__)

      def create_tracker_model
        template template_name, File.join("app", "models", class_path, "#{file_name}.rb")
        migration_template "migration.rb", "db/migrate/create_#{table_name}.rb" if migration_needed?
      end

      protected

        def migration_needed?
          @migration_needed ||= orm == :active_record
        end

        def orm
          @orm ||= if defined?(ActiveRecord)
            :active_record
          elsif defined?(Mongoid)
            :mongoid
          else
            raise NoOrmDetectedError, <<-ERROR.strip_heredoc
            We weren't able to discover your orm. Please make sure to include ActiveRecord
            or Mongoid as a dependency of your project and try again.
            ERROR
          end
        end

        def template_name
          @template_name ||= "#{orm}.rb"
        end
    end
  end
end
