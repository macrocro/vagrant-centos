# -*- coding: utf-8 -*-
#
# Cookbook Name:: gitlab
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# bash "yum update" do
#   code "yum -y update"
# end

if node['gitlab']['domain_name'].nil?
  domain_name = 'localhost'
end

bash "group install" do
  code "yum -y groupinstall \'Development Tools\'"
end

%w{ readline readline-devel ncurses-devel gdbm-devel glibc-devel tcl-devel openssl-devel curl-devel expat-devel db4-devel byacc sqlite-devel gcc-c++ libyaml libyaml-devel libffi libffi-devel libxml2 libxml2-devel libxslt libxslt-devel libicu libicu-devel system-config-firewall-tui python-devel redis sudo wget crontabs logwatch logrotate perl-Time-HiRes git mysql-devel }.each do |obj|
  package obj do
    action :install
  end
end

service "redis" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

package "postfix" do
  action :install
end

service "postfix" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

bash "gem install bundler" do
  code "gem install bundler --no-ri --no-rdoc"
end

bash "yum remove ruby and install ruby" do
  not_if "ruby --version | grep '2.0.0'"
  code <<-EOH
yum remove ruby
mkdir /tmp/ruby && cd /tmp/ruby
curl --progress ftp://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p353.tar.gz | tar xz
cd ruby-2.0.0-p353
./configure --disable-install-rdoc
make
sudo make install
rm /usr/bin/ruby
cp ruby /usr/bin
EOH
end

bash "Create user for Git" do
  not_if "cat /etc/group | grep git"
  code "adduser --system --shell /bin/bash --comment 'GitLab' --create-home --home-dir /home/git/ git"
end

bash "Forwarding all emails" do
  not_if { File.exists?("/root/.forward") }
  code <<-EOH
echo adminlogs@example.com > /root/.forward
chown root /root/.forward
chmod 600 /root/.forward
restorecon /root/.forward

echo adminlogs@example.com > /home/git/.forward
chown git /home/git/.forward
chmod 600 /home/git/.forward
restorecon /home/git/.forward
EOH
end

bash "Gitlab shell" do
  not_if { File.exists?("/home/git/gitlab-shell")}
  user "git"
  cwd "/home/git"
  code <<-EOH
su - git
git clone https://github.com/gitlabhq/gitlab-shell.git
cd gitlab-shell
git checkout -b v1.7.9
cp config.yml.example config.yml
./bin/install
EOH
end

# %w{ mysql-server mysql-devel }.each do |obj|
#   package obj do
#     action :install
#   end
# end

#mysql -uユーザ名 -pパスワード DB名 -e'show tables;''
bash "gitlab install" do
  code <<-EOH
mysql -uroot -p#{node['mysql']['root_password']} -e'CREATE USER 'gitlab'@'localhost' IDENTIFIED BY "#{node['gitlab']['mysql_password']}";'
mysql -uroot -p#{node['mysql']['root_password']} -e'CREATE DATABASE IF NOT EXISTS `gitlabhq_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`';
mysql -uroot -p#{node['mysql']['root_password']} -e'GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON `gitlabhq_production`.* TO 'gitlab'@'localhost'';
EOH
end

bash "Clone th Source" do
  cwd "/home/git"
  user "git"
  code <<-EOH
# Clone GitLab repository
git clone https://github.com/gitlabhq/gitlabhq.git gitlab

# Go to gitlab dir
cd /home/git/gitlab

# Checkout to stable release
git checkout 6-3-stable

# Copy the example GitLab config
cp config/gitlab.yml.example config/gitlab.yml

# Replace your_domain_name with the fully-qualified domain name of your host serving GitLab
sed -i 's|localhost|#{domain_name}|g' config/gitlab.yml

# Make sure GitLab can write to the log/ and tmp/ directories
chown -R git log/
chown -R git tmp/
chmod -R u+rwX  log/
chmod -R u+rwX  tmp/

EOH
end

bash "gitlab install 2" do
  cwd "/home/git/gitlab"
  code <<-EOH

# Create directory for satellites
# mkdir /home/git/gitlab-satellites

# Create directories for sockets/pids and make sure GitLab can write to them
sudo -u git -H mkdir tmp/pids/
sudo -u git -H mkdir tmp/sockets/
chmod -R u+rwX  tmp/pids/
chmod -R u+rwX  tmp/sockets/

# Create public/uploads directory otherwise backup will fail
sudo -u git -H mkdir public/uploads
chmod -R u+rwX  public/uploads

# Copy the example Unicorn config
sudo -u git -H cp config/unicorn.rb.example config/unicorn.rb

# Enable cluster mode if you expect to have a high load instance
# E.g. change amount of workers to 3 for 2GB RAM server
# editor config/unicorn.rb

# Configure Git global settings for git user, useful when editing via web
# Edit user.email according to what is set in gitlab.yml
sudo -u git -H git config --global user.name "GitLab"
sudo -u git -H git config --global user.email "gitlab@#{domain_name}"
sudo -u git -H git config --global core.autocrlf input
EOH
end

# bash "Configure Gitlab DB Settings" do
#   cwd "/home/git/gitlab"
#   code <<-EOH
# sudo -u git cp config/database.yml.mysql config/database.yml
# sudo -u git -H chmod o-rwx config/database.yml
# EOH
# end

template "/home/git/gitlab/config/database.yml" do
  source "database.yml.erb"
  owner "git"
  group "git"
  mode 0640
end

ruby_block "insert_line" do
  block do
    file = Chef::Util::FileEdit.new("/etc/resolv.conf")
    file.insert_line_if_no_match(/options single-request-reopen/, "options single-request-reopen")
    file.write_file
  end
end

bash "Install Gems" do
  user "git"
  cwd "/home/git/gitlab"
  code <<-EOH
bundle install --deployment --without development test postgres aws
yes yes | bundle exec rake gitlab:setup RAILS_ENV=production
EOH
end

bash "Initial init script" do
  cwd "/home/git/gitlab"
  code <<-EOH
cp lib/support/init.d/gitlab /etc/init.d/gitlab
chmod +x /etc/inir.d/gitlab
chkconfig --add gitlab
chkconfig gitlab on
service gitlab start
EOH
end

# bash "mod_rpaf install" do
#   cwd "/tmp"
#   code <<-EOH
# wget http://stderr.net/apache/rpaf/download/mod_rpaf-0.6.tar.gz
# tar xvzf mod_rpaf-0.6.tar.gz
# cd mod_rpaf-0.6
# EOH
# end

ruby_block "insert_line" do
  block do
    file = Chef::Util::FileEdit.new("/home/git/gitlab-shell/config.yml")
    if node['gitlab']['access_port'].nil?
      file.insert_line_if_no_match(/gitlab_url: "http:\/\/localhost\/"/, "gitlab_url: \"http://#{domain_name}\/\"")
    else
      file.insert_line_if_no_match(/gitlab_url: "http:\/\/localhost\/"/, "gitlab_url: \"http://#{domain_name}:#{node['gitlab']['access_port']}\/\"")
    end
    file.write_file
  end
end

# gitlab_url: "http://localhost/""
