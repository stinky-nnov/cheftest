#
# Cookbook Name:: shared
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install NFS packages
package ['nfs-common', 'nfs-kernel-server']

directory '/share' do
    mode "0777"
    action :create
end

# Create the exports file and refresh the NFS exports
template "/etc/exports" do
    source "exports.erb"
    owner "root"
    group "root"
    mode "0644"
end


# Start the NFS server
service "nfs-kernel-server" do
    action [:enable,:start,:restart]
end

execute "exportfs" do
    command "exportfs -a"
    action :run
end

directory '/share/html' do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
    action :create
end

cookbook_file '/share/html/index.php' do
    source 'index.php'
    owner 'root'
    group 'root'
    mode '0666'
    action :create
end

cookbook_file '/share/html/chef-logo.jpg' do
    source 'chef-logo.jpg'
    owner 'root'
    group 'root'
    mode '0666'
    action :create
end
