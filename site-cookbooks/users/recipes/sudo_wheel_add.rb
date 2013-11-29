p "****************************************"
p "notice: file_replace_line in sudo wheel_add isnt worked...?"
p "****************************************"

file_replace_line "/etc/sudoers" do
  replace "# %wheel\tALL=(ALL)\tALL"
  with    "%wheel\tALL=(ALL)\tALL"
end

file_append "/etc/sudoers" do
  line    "%wheel\tALL=(ALL)\tALL"
end

if node["sudo"]["users"] != "/dev/null"
  node["sudo"]["users"].each do |user|
    group "wheel" do
      group_name "wheel"
      members user
      append true
      action :create
    end
  end
end
