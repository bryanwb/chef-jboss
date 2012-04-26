
# this is so the ciserver user has rw access to make deployments
directory "#{node['jboss']['home']}/standalone/deployments" do
  mode "0775"
  group node['jboss']['user']
end
