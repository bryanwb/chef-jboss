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

include_recipe "maven"

node['jboss']['datasources'] = populate_datasources_from_env( node['jboss']['datasources'] )
node['jboss']['java_opts'] = update_java_opts_from_env( node['jboss']['java_opts'] )
jboss_config_file = "#{node['jboss']['home']}/standalone/configuration/#{node['jboss']['config']}.xml"

# create user
user node['jboss']['user']

ark 'jboss' do
  url  node['jboss']['url']
  checksum node['jboss']['checksum']
  home_dir node['jboss']['home']
  version node['jboss']['version']
  owner node['jboss']['user']
end

include_recipe "jboss::standalone_service_sysv"
include_recipe "jboss::extra_modules"

# only do it for standalone right now, not for standalone-full
if node['jboss']['manage_config_file']
  template jboss_config_file do
    source "#{node['jboss']['config']}.xml.erb"
    variables( :datasources => node['jboss']['datasources'],
               :drivers => node['jboss']['drivers']
              )
    owner node['jboss']['user']
  end
end

# this is so the ciserver user has rw access to make deployments
directory "#{node['jboss']['home']}/standalone/deployments" do
  mode "0755"
end

# start service
service jboss_user do
  subscribes :restart, resources( :template => jboss_config_file), :immediately if node['jboss']['manage_config_file']
  action [ :enable, :start ]
end
