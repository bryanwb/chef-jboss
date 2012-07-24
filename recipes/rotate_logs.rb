include_recipe "logrotate"

logrotate_app node['jboss']['user'] do
  cookbook "logrotate"
  path     "/usr/local/#{node['jboss']['user']}/standalone/log/console.log"
  frequency "daily"
  rotate    30
  create    "664 #{node['jboss']['user']} #{node['jboss']['user']}"
end

cron "compress rotated server.log" do
  minute "0"
  hour   "0"
  command  "find /usr/local/#{node['jboss']['user']}/standalone/log -name 'server.log*.gz' -mtime +60 \
-exec rm -f '{}' \\; ; \
find /usr/local/#{node['jboss']['user']}/standalone/log -name 'server.log.20*'  -a ! -name '*.gz' -exec gzip '{}' \\;"
end

