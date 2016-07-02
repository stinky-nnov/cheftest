#
# Cookbook Name:: backend
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package ['php5-fpm', 'php5-mysql', 'nfs-common', 'php5-memcache', 'php5-memcached']

directory '/var/www' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
end

mount '/var/www' do
  device 'shared:/share'
  fstype 'nfs'
  options 'rw'
  action [:mount, :enable]
end

cookbook_file '/etc/php5/fpm/pool.d/www.conf' do
    source 'www.conf'
    owner 'root'
    group 'root'
    mode '0666'
    action :create
end

cookbook_file '/etc/php5/fpm/php.ini' do
    source 'php.ini'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end

service 'php5-fpm' do
    supports :status => true
    action [:enable, :restart]
end
