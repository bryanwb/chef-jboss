#
# Cookbook Name:: jboss
# Recipe:: standalone_jdbc
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Copyright 2012, Food and Agriculture Organization of the United Nations
#
# license Apache v2.0
#

include_recipe "maven"

node['jboss']['datasources'] = populate_datasources_from_env( node['jboss']['datasources'] )
node.run_state['jboss'] = {}
node.run_state['jboss']['java_opts'] = update_java_opts_from_env( node['jboss']['java_opts'] )
node.run_state['jboss']['config_file'] = "#{node['jboss']['home']}/standalone/configuration/#{node['jboss']['config']}.xml"

# create user
user node['jboss']['user']

include_recipe "jboss::ark"
include_recipe "jboss::standalone_service_sysv"
include_recipe "jboss::extra_modules"
include_recipe "jboss::manage_config_file"

# this is so the ciserver user has rw access to make deployments
directory "#{node['jboss']['home']}/standalone/deployments" do
  mode "0775"
end

# start service
service node['jboss']['user'] do
  subscribes :restart, resources( :template => node['jboss']['config_file'] ), :immediately if node['jboss']['manage_config_file']
  action [ :enable, :start ]
end
