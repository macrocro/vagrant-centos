p "#################"
p `ssh-add -l`
p "#################"

if !File.exists?("/var/www/html/his-gakusei")
  bash "change permission /var/www/html" do
    code <<-EOH
    chmod 775 /var/www/html
    chown root:users /var/www/html
  EOH
  end

  bash "git clone" do
    not_if { File.exists?("/var/www/html/his-gakusei") }
    code <<-EOH
    cd /var/www/html
    git clone git@github.com:bsoo/his-gakusei
    chmod -R 755 his-gakusei
    chown -R kuroda:users his-gakusei
  EOH
  end

  bash "restore permission /var/www/html" do
    code <<-EOH
    chmod 755 /var/www/html
    chown root:users /var/www/html
    EOH
  end
end
