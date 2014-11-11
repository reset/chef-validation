module Chef::Validation
  module ContextExt
    class << self
      # Returns a single cookbook from the given run context of the given name.
      #
      # @param [Chef::RunContext] context
      # @param [String] name
      #
      # @return [Chef::CookbookVersion]
      def cookbook(context, name)
        context.cookbook_collection[name]
      end

      # Returns all loaded cookbooks from the given run context.
      #
      # @param [Chef::RunContext] context
      #
      # @return [Array<Chef::CookbookVersion>]
      def cookbooks(context)
        context.cookbook_collection.collect { |k, v| v }
      end
    end
  end
end
