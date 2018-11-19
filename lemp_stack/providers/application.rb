#
# action :setup_server do
#   # Setup Nginx
#   template "/sites-enabled/localhost.conf" do
#     source server_config_template
#     action :create
#   end
#
#   # Reload Nginx & fpm
#   service 'nginx' do
#     action :reload
#   end
#   # service 'php7.0-fpm' do
#   #   action :reload
#   # end
# end
