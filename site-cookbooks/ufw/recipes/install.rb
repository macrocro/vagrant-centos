#
# Cookbook Name:: ufw
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


bash "install ufw from source" do
  not_if 'which ufw' # when ufw not installed
  user "root"
  cwd "/tmp"
  code <<-EOH
yum install wget make
wget https://launchpad.net/ufw/0.33/0.33/+download/ufw-0.33.tar.gz
tar xzf ufw-0.33.tar.gz
cd ufw-0.33
python ./setup.py install
chmod -R g-w /etc/ufw /lib/ufw /etc/default/ufw /usr/sbin/ufw
EOH
end

template "/etc/init.d/ufw" do
  user "root"
  group "root"
  source "ufw.erb"
  mode 00755
end

bash "init iptable and ufw" do
  user "root"
  code <<-EOH
service iptables stop
service ufw start
chkconfig iptables off
chkconfig ufw on
EOH
end
