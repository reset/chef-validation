#
# Cookbook Name:: validation
# Definition:: attribute_validation
#
# The MIT License (MIT)
#
# Copyright (c) 2014 Jamie Winsor
#

define :attribute_validation, mode: :converge, cookbook: nil do
  if params[:mode] == :compile
    errors = if params[:cookbook].nil?
      Chef::Log.info("attribute-validation for all cookbooks (compile time)")
      Chef::Validation.validate(node)
    else
      Chef::Log.info("attribute-validation for '#{params[:cookbook]}' (compile time)")
      Chef::Validation.validate(node, params[:cookbook])
    end
    unless errors.empty?
      formatted = Chef::Validation.format_errors(errors)
      Chef::Application.fatal!(formatted)
    end
    if params[:cookbook].nil?
      Chef::Log.debug("attribute validation success for all cookbooks (compile time)")
    else
      Chef::Log.debug("attribute validation success for '#{params[:cookbook]}' (compile time)")
    end
  else
    if params[:cookbook].nil?
      ruby_block "attribute-validation for all cookbooks (convergence time)" do
        block do
          errors = Chef::Validation.validate(node)
          unless errors.empty?
            formatted = Chef::Validation.format_errors(errors)
            Chef::Application.fatal!(formatted)
          end
          Chef::Log.debug("attribute validation success for all cookbooks (convergence time)")
        end
      end
    else
      ruby_block "attribute-validation for '#{params[:cookbook]}' (convergence time)" do
        block do
          errors = Chef::Validation.validate(node, params[:cookbook])
          unless errors.empty?
            formatted = Chef::Validation.format_errors(errors)
            Chef::Application.fatal!(formatted)
          end
          Chef::Log.debug("attribute validation success for '#{params[:cookbook]}' (convergence time)")
        end
      end
    end
  end
end
