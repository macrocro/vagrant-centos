bash "iptable init settings by ufw" do
  only_if 'which ufw'
  user "root"
  code <<-EOH
service iptables start
iptables -F
ufw reset
ufw default deny
ufw allow "#{node['ssh']['port']}"
ufw allow 80/tcp
yes | ufw enable
EOH
end
