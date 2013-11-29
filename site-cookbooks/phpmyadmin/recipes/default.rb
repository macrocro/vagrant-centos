#
# Cookbook Name:: phpmyadmin
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "phpmyadmin" do
  action :install
end

service "httpd" do
end

template "/etc/httpd/conf.d/phpMyAdmin.conf" do
  source "phpMyAdmin.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, 'service[httpd]'
end
