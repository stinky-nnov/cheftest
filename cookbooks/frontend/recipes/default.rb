#
# Cookbook Name:: frontend
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'nfs-common'
package 'nginx'

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

cookbook_file '/etc/nginx/sites-available/default' do
    source 'nginx-default'
    owner 'root'
    group 'root'
    mode '0666'
    action :create
end

cookbook_file '/etc/nginx/fastcgi_params' do
    source 'fastcgi_params'
    owner 'root'
    group 'root'
    mode '0666'
    action :create
end

service 'nginx' do
    supports :status => true
    action [:enable, :restart]
end


