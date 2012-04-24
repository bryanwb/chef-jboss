# helpers

def populate_datasources(datasources)
  datasources = populate_from_data_bag(datasources) if datasources.empty?
  datasources.each {|ds| populate_datasource(ds) }
  datasources
end

def populate_from_data_bag(datasources)
  app_name = node['jboss']['application']
  db = data_bag_item("apps", app_name)[node['app_env']]
  datasources = db['datasources']
  datasources
end

def populate_datasource(datasource)
  datasource['password'] = fetch_password datasource['username']
  set_datasource_defaults(datasource)
end

def set_datasource_defaults(datasource)
  datasource['port'] ||= "5432"
  datasource['driver'] ||= 'postgresql'
  datasource['transaction_isolation'] ||= "TRANSACTION_READ_COMMITTED"
end

def fetch_password(username)
  app_name = node['jboss']['application']
  app_env = node['app_env']
  bag, item = node[:passwd_data_bag].split('/')
  db = Chef::EncryptedDataBagItem.load(bag, item)
  db[app_name][app_env]['password']
end
