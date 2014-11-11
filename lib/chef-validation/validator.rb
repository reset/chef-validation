module ChefValidation
  module Validator
    class << self
      def run(node, metadata)
        errors = {}
        metadata.attributes.each do |attribute, options|
          errors[attribute] = validate(node, attribute, options)
        end
        errors
      end

      def validate(node, name, options)
        value  = HashExt.dig(node.attributes, name, ATTR_SEPARATOR)
        errors = []

        if (options[:required] == "required" || options[:required] == true)
          errors = validate_required(value, name, errors)
        end
        unless options[:type].nil?
          errors = validate_type(value, options[:type], name, errors)
        end
        unless options[:choice].nil? || options[:choice].empty?
          errors = validate_choice(value, options[:choice], name, errors)
        end

        errors
      end

      def has_key?(node, parts)
        HashExt.dig(node, name, ATTR_SEPARATOR)
      end

      private

        ATTR_SEPARATOR = "/".freeze
        STRING         = "string".freeze
        ARRAY          = "array".freeze
        HASH           = "hash".freeze
        SYMBOL         = "symbol".freeze
        BOOLEAN        = "boolean".freeze
        NUMERIC        = "numeric".freeze

        def validate_choice(value, choices, name, errors)
          unless choices.include?(value)
            errors << "#{name} must be one of the following choices: #{choices.join(", ")}. Got: #{value}"
          end
          errors
        end

        def validate_required(value, name, errors)
          errors << "#{name} is a required attribute but was nil." if value.nil?
          errors
        end

        def validate_type(value, type, name, errors)
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
            errors << "#{name} is supposed to be of type '#{type}' but got: #{value.class}"
          end
          errors
        end
    end
  end
end
