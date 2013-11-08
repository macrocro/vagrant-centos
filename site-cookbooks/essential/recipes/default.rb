#
# Cookbook Name:: essential
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# install
%w{ zsh emacs git unzip }.each do |p|
  package p do
    action :install
  end
end

bash "set git config" do
  code <<-EOH
    git config --global user.name "#{node['git']['name']}"
    git config --global user.email #{node['git']['email']}
  EOH
end
