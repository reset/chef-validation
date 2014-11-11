#
# Cookbook Name:: validation
# Definition:: attribute_validation
#
# The MIT License (MIT)
#
# Copyright (c) 2014 Jamie Winsor
#

define :attribute_validation, mode: :converge, cookbook: nil do
  include_recipe "validation::default"

  if params[:mode] == :compile
    errors = if params[:cookbook].nil?
      Chef::Log.info("attribute-validation for all cookbooks (compile time)")
      Chef::Validation.validate(node)
    else
      Chef::Log.info("attribute-validation for '#{params[:cookbook]}' (compile time)")
      Chef::Validation.validate(node, params[:cookbook])
    end
    unless errors.empty?
      formatted = Chef::Validation::Formatter.format_errors(errors)
      Chef::Application.fatal!(formatted)
    end
  else
    if params[:cookbook].nil?
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
      ruby_block "attribute-validation for '#{params[:cookbook]}' (convergence time)" do
        block do
          errors = Chef::Validation.validate(node, params[:cookbook])
          unless errors.empty?
            formatted = Chef::Validation::Formatter.format_errors(errors)
            Chef::Application.fatal!(formatted)
          end
        end
      end
    end
  end
end
