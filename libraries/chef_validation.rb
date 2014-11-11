#
# Cookbook Name:: validation
# Library:: chef_validation
#
# The MIT License (MIT)
#
# Copyright (c) 2014 Jamie Winsor
#

class Chef
  module Validation
    class << self
      def cookbook_version(node)
        node.run_context.cookbook_collection["validation"].metadata.version
      end
    end
  end
end
