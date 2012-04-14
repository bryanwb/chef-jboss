#
# Cookbook Name:: jboss
# Recipe:: esb
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Copyright 2012, Food and Agriculture Organization of the United Nations
#
# license Apache v2.0
#

jboss_home = node['jboss']['home']
jboss_user = node['jboss']['user']

include_recipe "maven"
include_recipe "jboss::_jdbc_password"
include_recipe "jboss::_load_params"

# create user
user node['jboss']['user']
group node['jboss']['user']

ark 'jboss' do
  url node['jboss']['url']
  checksum node['jboss']['checksum']
  home_dir jboss_home
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

# put the jdbc driver in place
include_recipe "jboss::_jdbc_driver"

template "#{jboss_home}/standalone/configuration/standalone.xml" do
  source 'standalone.xml.erb'
  owner jboss_user
end

# start service
service jboss_user do
  subscribes :restart, resources( :template => "#{jboss_home}/standalone/configuration/standalone.xml"), :immediately
  action [ :enable, :start ]
end
