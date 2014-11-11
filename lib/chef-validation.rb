require "chef/cookbook/metadata"

module ChefValidation
  require_relative "chef-validation/version"
  require_relative "chef-validation/ext"
  require_relative "chef-validation/validator"

  class << self
    def validate(node, cookbook = nil)
      cookbook.nil? ? validate_all(node) : validate_one(node, cookbook)
    end

    def format_errors(errors)
      msg = []
      msg << "Attribute Validation failure report:"
      msg << ""
      errors.each do |cookbook, attr_errors|
        msg << "  # '#{cookbook}' had (#{attr_errors.length}) error(s)."
        attr_errors.each do |name, err|
          msg << "    * #{name} - #{err}"
        end
      end
      msg.join("\n")
    end

    private

      def validate_all(node)
        total_errors = {}
        ContextExt.cookbooks(node.run_context).each do |cookbook|
          unless (errors = Validator.run(node, cookbook.metadata)).empty?
            total_errors[cookbook.name] = errors
          end
        end
        total_errors
      end

      def validate_one(node, name)
        total_errors = {}
        unless cookbook = ContextExt.cookbook(node.run_context, name)
          raise "Cookbook not found: #{cookbook}"
        end
        unless (errors = Validator.run(node, cookbook.metadata)).empty?
          total_errors[cookbook.name] = errors
        end
        total_errors
      end
  end
end
