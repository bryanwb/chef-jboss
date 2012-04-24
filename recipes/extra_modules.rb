# load modules using maven
unless node['jboss']['extra_modules'].empty?
  node['jboss']['extra_modules'].each do |name,mod|
    module_subdir = mod['group_id'].split('.').join('/')
    maven name do                                       
      group_id mod['group_id']
      version  mod['version']
      dest     "#{node['jboss']['home']}/modules/#{module_subdir}/main"
      owner    node['jboss']['user']
    end
    # jboss needs module.xml that matches the jdbc driver
    template "#{node['jboss']['home']}/modules/#{module_subdir}/main/module.xml" do
      source "module.xml.erb"
      variables( @name => name, @mod => mod )
      owner node['jboss']['user']
    end
    
  end
  
  
  maven node['jboss']['jdbc']['driver']['name'] do
    group_id node['jboss']['jdbc']['driver']['name'] 
    version  node['jboss']['jdbc']['driver']['version']
    dest "#{node['jboss']['home']}/modules/org/#{node['jboss']['jdbc']['driver']['name']}/main"
    owner node['jboss']['user']
  end
  # jboss needs module.xml that matches the jdbc driver
  template "#{node['jboss']['home']}/modules/org/#{node['jboss']['jdbc']['driver']['name']}/main/module.xml" do
    source "#{node['jboss']['jdbc']['driver']['name']}.module.xml.erb"
    owner node['jboss']['user']
  end
