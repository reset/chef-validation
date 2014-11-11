#
# Cookbook Name:: validation
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2014 Jamie Winsor
#

chef_gem "chef-validation" do
  version Chef::ChefValidation.version(node)
  options "--ignore-dependencies"
  action :nothing
end.run_action(:install)

require "chef-validation"

attribute_validation "global-attribute-validation" do
  mode node[:validation][:mode]
end
