#
# Cookbook Name:: webdicom
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

git "/var/www/html" do
  user node["run_user"]
  repository "git@github.com:macrocro/webDICOM.git"
  reference "master"
  action :checkout
end

bash "git submodule" do
  user node["run_user"]
  cwd "/var/www/html/webDICOM"
  code <<-EOH
  git submodule init
  git submodule update
  EOH
end
