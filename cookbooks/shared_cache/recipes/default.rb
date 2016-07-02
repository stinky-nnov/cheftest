#
# Cookbook Name:: shared
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install NFS packages
package 'memcached'

execute "memcached config" do
    command "mv -f /etc/memcached.conf /etc/memcached.conf.bak; cat /etc/memcached.conf.bak | sed -r 's/^(-l 127.0.0.1)/#\1/' > /etc/memcached.conf "
    action :run
end

# Start memcached
service "memcached" do
    action [:enable,:start,:restart]
end
