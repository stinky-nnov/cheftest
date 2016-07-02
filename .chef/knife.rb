# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "stinky"
client_key               "#{current_dir}/stinky.pem"
chef_server_url          "https://chef.gmi.ru/organizations/gmi"
cookbook_path            ["#{current_dir}/../cookbooks"]
knife[:editor]="/usr/bin/mcedit"
