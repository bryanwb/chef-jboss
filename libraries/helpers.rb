# helpers

def populate_datasource(params)

end

def set_defaults(datasource)
  datasource = params
  datasource['port'] ||= "5432"
  datasource['driver'] ||= 'postgresql'
  datasource
end


# app_name = node['jboss']['application']
# app_env = node['app_env']
# jboss_config_file = "#{jboss_home}/standalone/configuration/#{node['jboss']['config']}.xml"

# # get password
# bag, item = node[:passwd_data_bag].split('/')
# db = Chef::EncryptedDataBagItem.load(bag, item)
# node['jboss']['jdbc']['password'] = db[app_name][app_env]['jdbc']
