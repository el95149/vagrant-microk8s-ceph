#
# Cookbook:: common
# Recipe:: microk8s-worker
# 
file "lockfile-microk8s-worker" do
  action :create_if_missing
  notifies :run, "execute[microk8sAddonsWorker]", :immediately
end

execute "microk8sAddonsWorker" do
  command "microk8s join " + node['masterNodeIP'] + ":25000/12345678901234567890123456789012"
  action :nothing
end
