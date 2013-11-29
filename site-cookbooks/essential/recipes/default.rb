#
# Cookbook Name:: essential
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# install
%w{ zsh git unzip tig tree }.each do |p|
  package p do
    action :install
  end
end

bash "install emacs 23.3.1" do
  code <<-EOH
cd /tmp
wget ftp://ftp.ntu.edu.tw/gnu/emacs/emacs-23.3b.tar.gz
tar zxvf emacs-23.3b.tar.gz
cd emacs-23.3
./configure -without-x
make
sudo make install
EOH
end
