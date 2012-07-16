include_recipe "logrotate"

logrotate_app node['jboss']['user'] do
  cookbook "logrotate"
  path     "/usr/local/#{node['jboss']['user']}/standalone/log/console.log"
  frequency "daily"
  rotate    30
  create    "664 #{node['jboss']['user']} #{node['jboss']['user']}"
end
