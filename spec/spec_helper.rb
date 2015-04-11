require 'rspec'
require 'chefspec'
require 'chef/validation'

# Get in data examples
Dir["./spec/shared/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  # Prohibit using the should syntax
  config.expect_with :rspec do |spec|
    spec.syntax = :expect
  end

  # Focus groups
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  # ChefSpec configuration
  config.log_level = :fatal
end

