
ark 'jboss' do
  url  node['jboss']['url']
  checksum node['jboss']['checksum']
  home_dir node['jboss']['home']
  version node['jboss']['version']
  owner node['jboss']['user']
end
