#
# Cookbook Name:: ssh
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

service "sshd" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/etc/ssh/sshd_config" do
  source "sshd_config.erb"
  owner "root"
  group "root"
  mode 0600
  notifies :reload, 'service[sshd]'
end
