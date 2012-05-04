# load modules using maven

extra_modules = node['jboss']['extra_modules'].to_hash

unless extra_modules.empty?
  extra_modules.each do |name,mod|
    module_subdir = mod['package'].split('.').join('/')
    maven name do                                       
      group_id mod['group_id']
      version  mod['version']
      dest     "#{node['jboss']['home']}/modules/#{module_subdir}/main"
      owner    node['jboss']['user']
    end
    # jboss needs module.xml that matches the jdbc driver
    template "#{node['jboss']['home']}/modules/#{module_subdir}/main/module.xml" do
      source "module.xml.erb"
      variables( :name => name, :mod => mod )
      owner node['jboss']['user']
    end
  end
end
