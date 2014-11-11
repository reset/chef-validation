module ChefValidation
  module ContextExt
    class << self
      def cookbook(context, name)
        context.cookbook_collection[name]
      end

      def cookbooks(context)
        context.cookbook_collection.collect { |k, v| v }
      end
    end
  end
end
