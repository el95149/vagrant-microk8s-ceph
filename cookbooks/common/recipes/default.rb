#
# Cookbook:: common
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
# Update the Apt repository at the start of a Chef Infra Client run
swap_file '/dev/sda1' do
  action :remove
end

apt_update 'update'
# Install commonly used tools
apt_package 'net-tools'
apt_package 'htop'
apt_package 'ntp'

# Set server timezone
timezone 'UTC'

# update /etc/hosts with "DNS" entries for all hosts, so that they can easily find each other
node['servers'].each do |server|
  hostsfile_entry server['ip'] do
    hostname server['hostname']
    action :create
  end
end

