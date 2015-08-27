module Chef::Validation
  module Validator
    class << self
      # Validates that the given node object satisfies all of the attribute constraints
      # found in the given metadata.
      #
      # Returns a hash containing key/value pairs where the keys are the name of an
      # attribute which was not properly set on the node object and the values are
      # errors that were generated for that attribute.
      #
      # @param [Chef::Node] node
      # @param [Chef::Metadata] metadata
      #
      # @return [Hash]
      def run(node, metadata)
        errors = {}
        metadata.attributes.each do |attribute, rules|
          unless (err = validate(node, attribute, rules)).empty?
            errors[attribute] = err
          end
        end
        errors
      end

      # Validates that the given node object passes the given validation rules for
      # the given attribute name.
      #
      # @param [Chef::Node] node
      #   node to validate
      # @param [String] name
      #   name of the attribute to validate
      # @param [Hash] rules
      #   a hash of rules (defined by the metadata of a cookbook)
      #
      # @return [Array<String>]
      def validate(node, name, rules)
        value  = HashExt.dig(node.attributes, name, ATTR_SEPARATOR)
        errors = []

        if rules["recipes"].present?
          if rules["recipes"].select { |recipe| recipe_present?(node, recipe) }.empty?
            return errors
          end
        end

        if rules["required"].present?
          errors += validate_required(rules["required"], value)
          # Bail out early
          unless errors.empty?
            return errors
          end
        end

        # Doing type / choice checks on optiona values when they are not present is no good
        if (!rules["required"].present? or
            ['optional', 'recommended', FalseClass].include?(rules["required"])) and value.nil?
          return errors
        end

        if rules["type"].present?
          errors += validate_type(value, rules["type"], name)
        end

        if rules["choice"].present?
          errors += validate_choice(value, rules["choice"], name)
        end

        errors
      end

      private

        ATTR_SEPARATOR = "/".freeze
        STRING         = "string".freeze
        ARRAY          = "array".freeze
        HASH           = "hash".freeze
        SYMBOL         = "symbol".freeze
        BOOLEAN        = "boolean".freeze
        NUMERIC        = "numeric".freeze

        def recipe_present?(node, recipe)
          cookbook, name = recipe.split("::", 2)
          if name.blank?
            # Check for default recipe by both of it's names.
            expanded = "#{cookbook}::default"
            node.recipe?(recipe) || node.recipe?(expanded)
          else
            node.recipe?(recipe)
          end
        end

        def validate_choice(value, choices, name)
          errors = []
          unless choices.include?(value)
            errors << "Must be one of the following choices: #{choices.join(", ")}."
          end
          errors
        end

        def validate_required(required, value)
          errors = []
          return errors if value.is_a?(TrueClass) || value.is_a?(FalseClass)

          if ['optional', 'recommended'].include?(required)
            return errors
          end

          # Only required gets here
          if value.blank?
            errors << "Required attribute but was not present."
          end
          errors
        end

        def validate_type(value, type, name)
          errors = []
          state  = nil
          case type.downcase
          when STRING
            state = :error unless value.is_a?(String)
          when ARRAY
            state = :error unless value.is_a?(Array)
          when HASH
            state = :error unless value.is_a?(Hash) || value.is_a?(Mash)
          when SYMBOL
            state = :error unless value.is_a?(Symbol)
          when BOOLEAN
            state = :error unless value.is_a?(TrueClass) || value.is_a?(FalseClass)
          when NUMERIC
            state = :error unless value.is_a?(Fixnum)
          else
            nil
          end

          if state == :error
            errors << "Must be of type '#{type}' but got: #{value.class}."
          end
          errors
        end
    end
  end
end
