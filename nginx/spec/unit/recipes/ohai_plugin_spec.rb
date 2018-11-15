require 'spec_helper'

describe 'nginx::ohai_plugin' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
  end

  it 'creates the nginx ohai plugin' do
    expect(chef_run).to create_ohai_plugin('nginx')
  end
end
