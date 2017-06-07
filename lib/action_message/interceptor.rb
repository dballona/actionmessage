module ActionMessage
  class Interceptor
    cattr_accessor :blacklist
    self.blacklist = {}

    class << self
      def register(conditions={})
        raise TypeError, 'Invalid type. Please provide a hash object' unless conditions.methods.include?(:key)

        conditions.each do |attribute, condition|
          @@blacklist[attribute.to_sym] ||= []
          @@blacklist[attribute.to_sym].push(condition)
        end
      end


      def registered_for?(message)
        @@blacklist.each do |attribute, conditions|
          value = message.send(attribute.to_sym)

          conditions.each do |condition|
            return true if value.send(match_method_for(condition), condition)
          end
        end

        return false
      end

      private
        def match_method_for(condition)
          condition.is_a?(Regexp)? :=~ : :==
        end
    end
  end
end
