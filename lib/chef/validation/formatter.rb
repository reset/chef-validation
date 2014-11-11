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
        errors.each do |cookbook, attrs|
          msg << "  # '#{cookbook}' failed validation for (#{attrs.length}) attribute(s)."
          attrs.each do |name, errs|
            msg << "    * #{name}"
            errs.each do |err|
              msg << "      - #{err}"
            end
          end
        end
        msg.join("\n")
      end
    end
  end
end
