# only do it for standalone right now, not for standalone-full

if node['jboss']['manage_config_file']
  config_file_action = :create
else
  config_file_action = :create_if_missing
end

template node.run_state['jboss']['config_file'] do
  source "#{node['jboss']['config']}.xml.erb"
  variables( :datasources => node['jboss']['datasources'],
             :drivers => node['jboss']['drivers'],
             :queues => node['jboss']['jms_queues']
             )
  owner node['jboss']['user']
  action config_file_action
end

