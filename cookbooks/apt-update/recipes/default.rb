#
# Cookbook Name:: apt-update
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

apt_update 'Update the apt cache daily' do
    frequency 86_400
    action :periodic
end
