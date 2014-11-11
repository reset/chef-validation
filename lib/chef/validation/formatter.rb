module Chef::Validation
  module Formatter
    class << self
      # Formats an error hash returned by `Chef::Validation.run/2` into a human readable
      # string to be output in a Chef run.
      #
      # @param [Hash] errors
      #
      # @return [String]
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
    end
  end
end
