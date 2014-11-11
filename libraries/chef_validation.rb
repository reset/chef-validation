module Chef
  module ChefValidation
    class << self
      def format_errors(errors)
        msg = "Attribute Validation failure report:"
        msg = ""
        errors.each do |cookbook, attr_errors|
          msg << "  * #{cookbook} had (#{attr_errors.length}) error(s)."
          attr_errors.each do |name, err|
            msg << "    # #{name} - #{err}"
          end
        end
        msg
      end

      def version(node)
        node.run_context.cookbook_collection["validation"].metadata.version
      end
    end
  end
end
