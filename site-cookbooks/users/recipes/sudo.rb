#
# Cookbook Name:: users
# Recipe:: sudo
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

template "/etc/sudoers" do
  source "sudoers.erb"
  owner "root"
  group "root"
  mode 0440
end

if node["sudo"]["users"] != "/dev/null"
  node["sudo"]["users"].each do |user|
    group "wheel" do
      group_name "wheel"
      members user
      append true
      action :create
    end
  end
end

# ruby_block "change wheel to sudo group in sudoers" do
#   block do
#     sudoers = Chef::Util::FileEdit.new("/etc/sudoers")
#     sudoers.search_file_replace_line(/# %wheel        ALL=(ALL)       ALL/,"%wheel        ALL=(ALL)       ALL")
#     sudoers.write_file
#   end
# end

