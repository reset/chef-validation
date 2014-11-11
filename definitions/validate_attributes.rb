#
# Cookbook Name:: validation
# Definition:: validate_attributes
#
# The MIT License (MIT)
#
# Copyright (c) 2014 Jamie Winsor
#

define :validate_attributes, mode: :converge, cookbook: nil do
  cookbook = params[:cookbook].nil? ? params[:name] : params[:cookbook]
  cookbook = nil if cookbook == "all"

  include_recipe "validation::default"

  if params[:mode] == :compile
    errors = if cookbook.nil?
      Chef::Log.info("attribute-validation for all cookbooks (compile time)")
      Chef::Validation.validate(node)
    else
      Chef::Log.info("attribute-validation for '#{cookbook}' (compile time)")
      Chef::Validation.validate(node, cookbook)
    end
    unless errors.empty?
      formatted = Chef::Validation::Formatter.format_errors(errors)
      Chef::Application.fatal!(formatted)
    end
  else
    if cookbook.nil?
      ruby_block "attribute-validation for all cookbooks (convergence time)" do
        block do
          errors = Chef::Validation.validate(node)
          unless errors.empty?
            formatted = Chef::Validation::Formatter.format_errors(errors)
            Chef::Application.fatal!(formatted)
          end
        end
      end
    else
      ruby_block "attribute-validation for '#{cookbook}' (convergence time)" do
        block do
          errors = Chef::Validation.validate(node, cookbook)
          unless errors.empty?
            formatted = Chef::Validation::Formatter.format_errors(errors)
            Chef::Application.fatal!(formatted)
          end
        end
      end
    end
  end
end
