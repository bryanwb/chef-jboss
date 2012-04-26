
# start service
service node['jboss']['user'] do
  subscribes :restart, resources( :template => node['jboss']['config_file'] ), :immediately if node['jboss']['manage_config_file']
  action [ :enable, :start ]
end
