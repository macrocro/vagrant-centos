data_ids = data_bag :users

data_ids.each do |id|
  u = data_bag_item :users, id

  u['username'] ||= u['id']

  # set up git config
  bash "set git config" do
    user "root"

    code <<-EOH
      sudo -u #{u['id']} git config --global user.name "#{u['git']['name']}"
      sudo -u #{u['id']} git config --global user.email #{u['git']['email']}
    EOH
  end
end
