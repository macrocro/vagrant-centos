#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

data_ids = data_bag :users

data_ids.each do |id|
  u = data_bag_item :users, id

  u['username'] ||= u['id']

  # Set home to location in data bag,
  # or a reasonable default (/home/$user).
  if u['home']
    home_dir = u['home']
  else
    home_dir = "/home/#{u['username']}"
  end

  # create Users Object
  user u['username'] do
    shell u['shell']
    comment u['comment']

    password u['password'] if u['password']
    if home_dir == "/dev/null"
      supports :manage_home => false
    else
      supports :manage_home => true
    end
    home home_dir
    action u['action'] if u['action']
  end

  # create Groups
  u['groups'].each do |group_name|
    group group_name do
      group_name group_name
      members u['username']
      append true
      action :create
    end
  end

  # make SSH Key
  if home_dir != "/dev/null"
    directory "#{home_dir}/.ssh" do
      owner u['username']
      group u['gid'] || u['username']
      mode "0700"
    end

    if u['ssh_keys']
      template "#{home_dir}/.ssh/authorized_keys" do
        source "authorized_keys.erb"
        owner u['username']
        group u['gid'] || u['username']
        mode "0600"
        variables :ssh_keys => u['ssh_keys']
      end
    end

    if u['ssh_private_key']
      key_type = u['ssh_private_key'].include?("BEGIN RSA PRIVATE KEY") ? "rsa" : "dsa"
      template "#{home_dir}/.ssh/id_#{key_type}" do
        source "private_key.erb"
        owner u['id']
        group u['gid'] || u['id']
        mode "0400"
        variables :private_key => u['ssh_private_key']
      end
    end

    if u['ssh_public_key']
      key_type = u['ssh_public_key'].include?("ssh-rsa") ? "rsa" : "dsa"
      template "#{home_dir}/.ssh/id_#{key_type}.pub" do
        source "public_key.pub.erb"
        owner u['id']
        group u['gid'] || u['id']
        mode "0400"
        variables :public_key => u['ssh_public_key']
      end
    end
  end
end
