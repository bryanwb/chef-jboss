# helpers


def jboss_options
  [
   {:regex => /-Xmx/, :default => "-Xmx512m"},
   {:regex => /-Xms/, :default => "-Xms128m"},
   {:regex => /-XX:MaxPermSize/, :default => "-XX:MaxPermSize=256m"}
  ]
end
  
def populate_datasources_from_env(datasources)
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

def update_java_opts_from_env(java_opts)
  java_opts ||= []
  app_name = node['jboss']['application']
  db = data_bag_item("apps", app_name)[node['app_env']]
  jboss_options.each do |option|
    new_option = db['java_opts'].find {|o| o =~ option[:regex] }
    existing_option = java_opts.find {|o| o =~  option[:regex] }
    if new_option
      java_opts.delete existing_option
      java_opts.push new_option
    end
  end
  set_java_missing_defaults(java_opts)
  java_opts
end

def set_java_missing_defaults(java_opts)
  jboss_options.each do |option|
    found = java_opts.find{ |opt| opt =~ option[:regex] }
    if found.nil?
      java_opts.push option[:default]
    end
  end
end
