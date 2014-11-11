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

        if (rules["required"] == "required" || rules["required"] == true)
          errors += validate_required(value, name)
        end
        unless rules["type"].nil?
          errors += validate_type(value, rules["type"], name)
        end
        unless rules["choice"].nil? || rules["choice"].empty?
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

        def validate_choice(value, choices, name, errors = [])
          unless choices.include?(value)
            errors << "Must be one of the following choices: #{choices.join(", ")}."
          end
          errors
        end

        def validate_required(value, name, errors = [])
          if value.empty? || value.nil?
            errors << "Required attribute but was not present."
          end
          errors
        end

        def validate_type(value, type, name, errors = [])
          state = nil
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
            state = :error unless value.is_a?(Boolean)
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
