#
# Cookbook Name:: jboss
# Attributes:: default
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Copyright 2011, UN Food and Agriculture Organization
#
# license Apache v2.0
#


default['jboss']['home'] = "/usr/local/jboss"
default['jboss']['version'] = "7.1.0"
default['jboss']['url'] = "http://download.jboss.org/jbossas/7.1/jboss-as-7.1.0.Final/jboss-as-7.1.0.Final.tar.gz"
default['jboss']['checksum'] = "3a8ee8e3ab10003a5330e27d87e5ba38b90fbf8d6132055af4dd9a288d459bb7"
default['jboss']['user'] = "jboss"
default['jboss']['application'] = 'jboss'

default['jboss']['jdbc']['user'] = 'sa'
default['jboss']['jdbc']['passwd'] = ''
default['jboss']['jdbc']['schema'] = ''
default['jboss']['jdbc']['host'] = 'localhost'
default['jboss']['jdbc']['transaction_isolation'] = nil
default['jboss']['jdbc']['driver']['name'] = 'h2'
default['jboss']['jdbc']['driver']['module'] = 'com.h2database.h2'
default['jboss']['jdbc']['driver']['version'] = ''
default['jboss']['jdbc']['driver']['class'] = 'org.h2.jdbcx.JdbcDataSource'
