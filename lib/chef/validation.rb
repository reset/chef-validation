class Chef; end;
require "chef/node"
require "chef/cookbook/metadata"

module Chef::Validation
  require_relative "validation/version"
  require_relative "validation/formatter"
  require_relative "validation/ext"
  require_relative "validation/validator"

  class << self
    # Validates the given node object against all attribute rules defined in all the metadata
    # of all loaded cookbooks for the node's current run context.
    #
    # If an optional cookbook name is provided then the validations will only be run for the
    # metadata of that particular cookbook.
    #
    # An errors hash is returned where keys are populated with the names of cookbooks that are
    # failing validation and the values are an error hash returned from
    # `Chef::Validation::Validator.run/2`. That error hash is made up of keys representing
    # the name of an attribute which did not pass all rules and the values are error message
    # strings.
    #
    #   {
    #     "elixir" => {
    #       "elixir/version" => [
    #         "'elixir/version' is a required attribute but was nil."
    #       ]
    #     }
    #   }
    #
    # @param [Chef::Node] node
    # @param [String, nil] cookbook
    #
    # @return [Hash]
    def validate(node, cookbook = nil)
      cookbook.nil? ? validate_all(node) : validate_one(node, cookbook)
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
