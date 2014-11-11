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
      # @param [Hash] hash
      # @param [String] path
      # @param [String] separator
      #
      # @return [Object, nil]
      def dig(hash, path, separator = "/")
        return nil unless !path.nil? && !path.empty?
        return nil unless hash.respond_to?(:has_key?)
        return hash unless hash.respond_to?(:[])

        key, rest = path.split(separator, 2)
        match     = hash[key.to_s].nil? ? hash[key.to_sym] : hash[key.to_s]
        if rest.nil? or match.nil?
          match
        else
          dig(match, rest, separator)
        end
      end
    end
  end
end
