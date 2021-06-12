#
# Cookbook:: common
# Recipe:: microk8s-master
# 
file "lockfile-microk8s-master" do
  action :create_if_missing
  notifies :run, "execute[microk8sAddons]", :immediately
  notifies :run, "execute[microk8sAddonsMaster]", :immediately
end

execute "microk8sAddons" do
  command "microk8s enable dns rbac dashboard"
  action :nothing
end

execute "microk8sAddonsMaster" do
  command "microk8s add-node --token-ttl 3600 --token 12345678901234567890123456789012"
  action :nothing
end
