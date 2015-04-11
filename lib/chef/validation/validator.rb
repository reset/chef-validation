module Chef::Validation
  module Validator
    class << self
      # Validates that the given node object satisfies all of the attribute constraints
      # found in the given metadata attributes.
      #
      # Returns a hash containing key/value pairs where the keys are the name of an
      # attribute which was not properly set on the node object and the values are
      # errors that were generated for that attribute.
      #
      # @param [Hash]  node
      # @param [Hash]  attributes
      # @param [Array] recipes
      #
      # @return [Hash]
      def run(node, attributes, recipes = {})
        errors = {}
        expand_attributes(node, attributes).each do |attribute, rules|
          unless (err = validate(node, attribute, rules, recipes)).empty?
            errors[attribute] = err
          end
        end
        errors
      end

      # Validates that the given node object passes the given validation rules for
      # the given attribute name.
      #
      # @param [Hash] node
      #   node attributes to validate
      # @param [String] name
      #   name of the attribute to validate
      # @param [Hash] rules
      #   a hash of rules (defined by the metadata of a cookbook)
      # @param [Array] recipes
      #   recipes to validate against
      #
      # @return [Array<String>]
      def validate(node, name, rules, recipes = {})
        value  = HashExt.dig(node, name, ATTR_SEPARATOR)
        errors = []

        if rules["recipes"].present?
          if rules["recipes"].select { |recipe| recipe_present?(recipes, recipe) }.empty?
            return errors
          end
        end

        if rules["required"].present?
          errors += validate_required(rules["required"], value, name)
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

        def recipe_present?(recipes, recipe)
          cookbook, name = recipe.split("::", 2)
          if name.blank?
            # Check for default recipe by both of it's names.
            expanded = "#{cookbook}::default"
            recipes.include?(recipe) || recipes.include?(expanded)
          else
            recipes.include?(recipe)
          end
        end

        def validate_choice(value, choices, name)
          errors = []
          if value.is_a?(Array)
            unless value.select { |v| !choices.include?(v) }.empty?
              errors << "Must be any of the following choices: #{choices.join(", ")}."
            end
          else
            unless choices.include?(value)
              errors << "Must be one of the following choices: #{choices.join(", ")}."
            end
          end
          errors
        end

        def validate_required(required, value, name)
          errors = []
          return errors if value.is_a?(TrueClass) || value.is_a?(FalseClass)

          if ['optional', 'recommended'].include?(required)
            return errors
          end

          # Only required gets here
          if value.blank?
            errors << "Attribute #{name} is required but was not present."
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

        # Attempts to expand as many of the glob rules against the passed in attributes
        def expand_attributes(node, attributes)
          data = {}
          flattened = flatten(node)
          attributes.each do |attribute, rules|
            flattened.each do |key, value|
              # If no glob then passthrough
              unless attribute.include? '*'
                data[attribute] = rules
                attributes.delete(attribute)
                next
              end

              # Do strict matching for when attribute exists in the dataset
              if File.fnmatch(attribute, key)
                data[key] = rules
                attributes.delete(attribute)
                next
              end

              # Deals with when the node tree is deeper than the ruleset specifies
              if File.fnmatch(attribute + ATTR_SEPARATOR + '*', key)
                # extract the expanded name
                count = attribute.count(ATTR_SEPARATOR) + 2  # account for the last / from above and one additional seat
                last = (key.split(ATTR_SEPARATOR, count).last.length + 2)
                data[key[0..-last]] = rules
                attributes.delete(attribute)
                next
              end
            end
          end

          # attributes now contains the ones we couldn't match against the node data
          attributes.each do |attribute, rules|
            data.keys.each do |key|
              # Make sure glob keys don't go through
              if key.include?('*')
                next
              end

              text = ''
              # Best to split on what is being replaced
              attribute.split('*').each do |segment|
                if segment[-1] == ATTR_SEPARATOR
                  segment += '*' # make sure * is added in for the replacing
                end
        
                if match = key.match("^#{segment.gsub('*', '(.*?)' + ATTR_SEPARATOR)}")
                  # Replace the * with the matched value
                  segment.gsub!("*", match.captures[0])
                end

                text += segment
              end
        
              # Slap the data together even if it overwrites, still gets the same rule set
              data[text] = rules
            end
          end
        
          data
        end

        # Turns a nested hash into a flat hash for easier matching
        def flatten(source, target = {}, separator = ATTR_SEPARATOR, namespace = nil)
          prefix = "#{namespace}#{separator}" if namespace
          case source
          when Hash
            source.each do |key, value|
              flatten(value, target, separator, "#{prefix}#{key}")
            end
          when Array
            source.each_with_index do |value, index|
              flatten(value, target, separator, "#{prefix}#{index}")
            end
          else
            target[namespace] = source
          end
          target
        end
    end
  end
end
