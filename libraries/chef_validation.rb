class Chef
  module ChefValidation
    class << self
      def version(node)
        node.run_context.cookbook_collection["validation"].metadata.version
      end
    end
  end
end
