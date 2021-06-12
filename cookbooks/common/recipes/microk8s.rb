#
# Cookbook:: common
# Recipe:: microk8s
# 
apt_package 'snapd'

# TODO update chef client to min 16.2.44, to solve this issue:
# https://docs.chef.io/release_notes_client/#snap_package-1
# sudo snap install microk8s --classic --channel=latest/edge
# snap_package 'microk8s' do
#   channel "stable"
#   options "--classic"
#   version "1.21"
# end
# 

execute "snap install microk8s --classic --channel=1.21/stable"

group "microk8s" do
  action :manage
  members ['vagrant']
end
