
ark 'jboss' do
  url  node['jboss']['url']
  checksum node['jboss']['checksum']
  home_dir node['jboss']['home']
  version node['jboss']['version']
  mode 0755
  owner node['jboss']['user']
  group node['jboss']['user']
end
