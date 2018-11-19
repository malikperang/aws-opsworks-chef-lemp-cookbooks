#
# Cookbook:: apt
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#
execute "apt-get update" do
  command "apt-get update"
end
