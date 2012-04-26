#
# Cookbook Name:: jboss
# Recipe:: sdmx
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Copyright 2012, Food and Agriculture Organization of the United Nations
#
# license Apache v2.0
#

include_recipe "maven"
node.run_state['jboss'] = {}
node.run_state['jboss']['java_opts'] = update_java_opts_from_env( node['jboss']['java_opts'] )
node.run_state['jboss']['config_file'] = "#{node['jboss']['home']}/standalone/configuration/#{node['jboss']['config']}.xml"

# create user
user node['jboss']['user']

include_recipe "jboss::ark"
include_recipe "jboss::standalone_service_sysv"
include_recipe "jboss::extra_modules"
include_recipe "jboss::manage_config_file"
include_recipe "jboss::ci_access"
include_recipe "jboss::start_service"
