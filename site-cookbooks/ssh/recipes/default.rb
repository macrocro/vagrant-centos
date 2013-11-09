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
  mode 0644
  notifies :reload, 'service[sshd]'
end

template "/etc/ssh/ssh_config" do
  source "ssh_config.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, 'service[sshd]'
end

# data_ids = data_bag :users

# data_ids.each do |id|
#   u = data_bag_item :users, id

#   u['username'] ||= u['id']

#   # Set home to location in data bag,
#   # or a reasonable default (/home/$user).
#   if u['home']
#     home_dir = u['home']
#   else
#     home_dir = "/home/#{u['username']}"
#   end

#   template "#{home_dir}/.ssh/config" do
#     not_if "#{home_dir}/.ssh/config"
#     source "config.erb"
#     user u['username']
#     group u['username']
#     mode 00700
#   end

# end
