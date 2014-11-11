define :attribute_validation, mode: :converge do
  if params[:mode] == :compile
    Chef::Log.info("attribute-validateion: compile time")
    errors = ::ChefValidation.validate(node)
    unless errors.empty?
      formatted = ::ChefValidation.format_errors(errors)
      Chef::Application.fatal!(formatted)
    end
    Chef::Log.info("attribute validation success.")
  else
    ruby_block "attribute-validation: convergence time" do
      block do
        errors = ::ChefValidation.validate(node)
        unless errors.empty?
          formatted = ::ChefValidation.format_errors(errors)
          Chef::Application.fatal!(formatted)
        end
        Chef::Log.info("attribute validation success.")
      end
    end
  end
end
