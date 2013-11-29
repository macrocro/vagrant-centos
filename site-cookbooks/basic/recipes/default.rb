#
# Cookbook Name:: basic
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node["basic"].each do |obj|
  if File.exists?(obj["path"]) # directory exist?

    if File.exists?(obj["path"]+"/.htpasswd") # .htpasswd already exist
      execute "remove htpasswd #{obj["path"]}" do
        user "root"
        cwd obj["path"]
        command "rm .htpasswd"
      end
    end

    execute "create htpasswd #{obj["path"]}" do
      user "root"
      cwd obj["path"]
      command "htpasswd -cb .htpasswd #{obj["user"]} #{obj["password"]}"
    end

    if File.exists?(obj["path"]+"/.htaccess")
      raise ".htaccess exist. path : " + obj["path"]
    else
      template "#{obj["path"]}"+"/.htaccess" do
        user "root"
        source "htaccess.html.erb"
        variables({
                    :path => obj["path"]
                  })
      end
    end

  end
end

