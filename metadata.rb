$:.push File.expand_path("../lib", __FILE__)
require "chef/validation/version"

name             "validation"
maintainer       "Jamie Winsor"
maintainer_email "jamie@vialstudios.com"
license          "MIT"
description      "Perform validation on your node's attributes from a Cookbook's attribute metadata definitions."
long_description "Perform validation on your node's attributes from a Cookbook's attribute metadata definitions."
version           Chef::Validation::VERSION

supports "ubuntu"
supports "centos"
