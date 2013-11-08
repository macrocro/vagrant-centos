bash "iptable init settings by ufw" do
  only_if 'which ufw'
  user "root"
  code <<-EOH
ufw reset
ufw default deny
ufw allow "#{node['ssh']['port']}"
ufw allow 80
yes | ufw enable
EOH
end
