#
# Cookbook Name:: validation
# Recipe:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2014 Jamie Winsor
#

if Chef::Resource::ChefGem.instance_methods(false).include?(:compile_time)
  chef_gem "chef-validation" do
    version Chef::Validation.cookbook_version(node)
    options "--ignore-dependencies"
    compile_time true
  end
else
  chef_gem "chef-validation" do
    version Chef::Validation.cookbook_version(node)
    options "--ignore-dependencies"
    action :nothing
  end.run_action(:install)
end

require "chef-validation"
