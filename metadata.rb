maintainer       "Bryan Berry"
maintainer_email "bryan.berry@gmail.com"
license          "Apache v2.0"
description      "Installs/Configures jboss"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.8"

%w{ java logrotate }.each do |cb|
  depends cb
end

recipe "jboss", "installs jboss from the jboss community site"

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end
