#
# Cookbook Name:: database
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#apt_update 'Update the apt cache daily' do
#    frequency 86_400
#    action :periodic
#end

case node['hostname']
when 'sql1'
    id_of_server = 1
when 'sql2'
    id_of_server = 2

    cookbook_file '/tmp/replicate.sh' do
	source 'replicate.sh'
	owner 'root'
	group 'root'
	mode '0777'
	action :create
    end
end

rootpassword='123123'

# Configure the MySQL client.
mysql_client 'default' do
  action :create
end

# Configure the MySQL service.
mysql_service 'default' do
  initial_root_password rootpassword
  action [:create, :start]
end

mysql_config 'default' do
#    instance 'default'
    source 'replication.cnf.erb'
    variables ({
      :serverid => id_of_server,
      :binlogdb => 'example'
    })
    action :create
    notifies :restart, 'mysql_service[default]'
end

execute 'allow root from any host' do
  command "/usr/bin/mysql -h 127.0.0.1  -u root -p#{rootpassword} -e \"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '#{rootpassword}' WITH GRANT OPTION; FLUSH PRIVILEGES;\" "
end

if node['hostname'] == 'sql2'
    execute 'set replication' do
	command "/tmp/replicate.sh sql1 #{node['ipaddress']} #{rootpassword}"
    end
end
