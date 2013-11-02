#
# Cookbook Name:: essential
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# install
%w{ zsh emacs }.each do |p|
  package p do
    action :install
  end
end
