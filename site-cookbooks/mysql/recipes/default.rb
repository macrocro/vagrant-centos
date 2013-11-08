# -*- coding: utf-8 -*-
#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "mysql-server" do
  action :install
end

service "mysqld" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
  notifies :run, "execute[change-mysql-root-password]", :delayed
end

template "/etc/my.cnf" do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, 'service[mysqld]'
end

# :delayedの指定により一番最後に実行する
execute "change-mysql-root-password" do
  user "root"
  command "mysql -u root -e\"SET PASSWORD FOR root@localhost=PASSWORD(\'#{node['mysql']['root_password']}\')\""
  action :nothing
end
