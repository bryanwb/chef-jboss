#
# Cookbook Name:: jboss
# Recipe:: standalone
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Copyright 2012, Food and Agriculture Organization of the United Nations
#
# license Apache v2.0
#

jboss_home = node['jboss']['home']
jboss_user = node['jboss']['user']

include_recipe "maven"

app_name = node['jboss']['application']
app_env = node['app_env']

# create user
user node['jboss']['user']

ark 'jboss' do
  url  node['jboss']['url']
  checksum node['jboss']['checksum']
  home_dir "/usr/local/#{jboss_user}"
  version "7.1.0"
  owner jboss_user
end

# template environment variables used by init file
template "/etc/default/#{jboss_user}" do
  source "default.erb"
  mode "0755"
end

# template init file
template "/etc/init.d/#{jboss_user}" do
  if platform? ["centos", "redhat"] 
    source "init_standalone_el.erb"
  else
    source "init_deb.erb"
  end
  mode "0755"
  owner "root"
  group "root"
end

# template startup script
template "#{jboss_home}/bin/standalone.sh" do
  source "standalone.sh.erb"
  mode "0755"
  owner jboss_user
  group jboss_user
end

template "#{jboss_home}/standalone/configuration/standalone.xml" do
  source 'standalone.xml.erb'
  owner jboss_user
end

# start service
service jboss_user do
  subscribes :restart, resources( :template => "#{jboss_home}/standalone/configuration/standalone.xml"), :immediately
  action [ :enable, :start ]
end
