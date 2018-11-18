#
# Cookbook:: lemp_stack
# Recipe:: deploy
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe "apt"

package 'nginx' do
  action :install
end

service 'nginx' do
  action [ :enable, :start ]
end

template "/etc/nginx/sites-available/default.conf" do
  source "default.conf.erb"
  action :create
end

execute "enable-site" do
  command "sudo ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf"
end

cookbook_file "/var/www/html/index.html" do
  source "index.html"
  mode "0644"
end

# apt_update
#
# package node['lemp_stack']['package'] do
#   action :install
# end
#
# cookbook_file "#{node['lemp_stack']['docroot']}/index.html" do
#   source 'index.html'
#   action :create
# end
#
# service node['lemp_stack']['service'] do
#   action [:enable, :start]
# end

# service node['lemp_stack']['service'] do
#   supports status: true, restart: true, reload: true
#   action %i(enable start)
# end
