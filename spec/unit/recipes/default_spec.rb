require 'spec_helper'

describe 'validation::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'installs the chef gem' do
    expect(chef_run).to install_chef_gem('chef-validation')
      .with(version: Chef::Validation::VERSION)
  end
end
