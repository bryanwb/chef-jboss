#
# Cookbook Name:: jboss
# Recipe:: standalone_jdbc
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Copyright 2012, Food and Agriculture Organization of the United Nations
#
# license Apache v2.0
#

jboss_home = node['jboss']['home']
jboss_user = node['jboss']['user']

include_recipe "java::oracle"
include_recipe "maven"

app_name = node['jboss']['application']
app_env = node['app_env']

# get password
bag, item = node[:passwd_data_bag].split('/')
db = Chef::EncryptedDataBagItem.load(bag, item)
node['jboss']['jdbc']['password'] = db[app_name][app_env]['jdbc']

ruby_block "set jdbc parameters" do
  block do
    app_name = node['jboss']['application']

    db = data_bag_item("apps", app_name)[node['app_env']]
    Chef::Log.debug("application name is #{app_name} and env is #{node['app_env']}")
    Chef::Log.debug("databag contents are #{db.inspect}")
    node['jboss']['java_opts'] = db['java_opts']
    node['jboss']['jdbc']['schema'] = db['jdbc']['schema']
    node['jboss']['jdbc']['user'] = db['jdbc']['user']
    node['jboss']['jdbc']['host'] = db['jdbc']['host']
  end
end

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

# put the jdbc driver in place
if node['jboss']['jdbc']['driver']['name'] != 'h2'
  maven node['jboss']['jdbc']['driver']['name'] do
    groupId node['jboss']['jdbc']['driver']['name'] 
    version  node['jboss']['jdbc']['driver']['version']
    dest "#{node['jboss']['home']}/modules/org/#{node['jboss']['jdbc']['driver']['name']}/main"
    owner node['jboss']['user']
  end
  # jboss needs module.xml that matches the jdbc driver
  template "#{node['jboss']['home']}/modules/org/#{node['jboss']['jdbc']['driver']['name']}/main/module.xml" do
    source "#{node['jboss']['jdbc']['driver']['name']}.module.xml.erb"
    owner node['jboss']['user']
  end
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
