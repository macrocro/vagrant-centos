package "nginx" do
  action :install
end

bash "cp gitlab.conf" do
  code <<-EOH
cp /home/git/gitlab/lib/support/nginx/gitlab /etc/nginx/conf.d/gitlab.conf
EOH
end

# include /etc/nginx/conf.d/*.conf;
ruby_block "load only gitlab file" do
  block do
    file = Chef::Util::FileEdit.new("/etc/nginx/nginx.conf")
    file.search_file_replace_line(/include \/etc\/nginx\/conf\.d\/.*/, "include /etc/nginx/conf.d/gitlab.conf;")
    file.write_file
  end
end

bash "chmod 755 /home/git" do
  code <<-EOH
chmod 755 /home/git
EOH
end

# listen *:80 default_server;
ruby_block "change nginx gitlab port" do
  block do
    file = Chef::Util::FileEdit.new("/etc/nginx/conf.d/gitlab.conf")
    file.search_file_replace_line(/listen \*:80 default_server;/,"listen *:#{node['gitlab']['access_port']};")
    file.write_file
  end
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

bash "open port by ufw" do
  code <<-EOH
ufw allow #{node['gitlab']['access_port']}
EOH
end
