module Chef::Validation
  module HashExt
    class << self
      # Return the value of the nested hash key from the given dotted path
      #
      # @example
      #
      #   nested_hash = {
      #     "deep" => {
      #       "nested" => {
      #         "hash" => :my_value
      #       }
      #     }
      #   }
      #
      #   HashExt.dig(hash, "deep/nested/hash") => :my_value
      #
      # Accessing array elements by the integer key
      #
      # @example
      #   nested_hash = {
      #     "deep" => [
      #       {
      #         "nested" => {
      #           "hash" => :my_value
      #         }
      #       }
      #     ]
      #   }
      #
      #   HashExt.dig(hash, "deep/1/nested/hash") => :my_value
      #
      # @param [Hash] hash
      # @param [String] path
      # @param [String] separator
      #
      # @return [Object, nil]
      def dig(hash, path, separator = "/")
        return nil unless !path.nil? && !path.empty?

        key, rest = path.split(separator, 2)
        if hash.is_a?(Hash)
          match = hash[key.to_s].nil? ? hash[key.to_sym] : hash[key.to_s]
        elsif hash.is_a?(Array)
          match = hash[key.to_i]
        end

        if rest.nil? or match.nil?
          match
        else
          dig(match, rest, separator)
        end
      end
    end
  end
end
