jboss_user = node['jboss']['user']

if node['jboss']['config'] =~ /standalone-full/
  config_file_name = "standalone-full.xml"
else
  config_file_name = "#{node['jboss']['config']}.xml"
end
  

# template environment variables used by init file
template "/etc/default/#{jboss_user}" do
  source "default.erb"
  mode "0755"
  variables( :config_file_name => config_file_name )
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

# template startup script
template "#{node['jboss']['home']}/bin/standalone.sh" do
  source "standalone.sh.erb"
  mode "0755"
  owner jboss_user
  group jboss_user
end
