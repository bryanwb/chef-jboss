
# this is so the ciserver user has rw access to make deployments
directory "#{node['jboss']['home']}/standalone/deployments" do
  mode "0775"
  owner node['jboss']['user']
  group node['jboss']['user']
end

ruby_block "set all files inside deployments to 0775" do
  block do
    require 'fileutils'
    FileUtils.chmod_R 0775, "#{node['jboss']['home']}/standalone/deployments"
  end
end
