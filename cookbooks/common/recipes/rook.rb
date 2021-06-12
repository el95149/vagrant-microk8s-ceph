#
# Cookbook:: common
# Recipe:: rook
# 
# git clone --single-branch --branch v1.6.4 https://github.com/rook/rook.git
# TODO Remove directory hard-coding
# microk8s kubectl get nodes -oname | wc -l
# TODO remove hard-coded nodes number
file "lockfile-rook" do
  action :create_if_missing
  notifies :sync, "git[checkoutRook]", :immediately
  notifies :run, "bash[installRookOperator]", :immediately
  notifies :run, "execute[waitForRookOperator]", :immediately
  notifies :run, "bash[createRookCephCluster]", :immediately
  notifies :run, "execute[waitForRookCephCluster]", :immediately
  notifies :run, "bash[installRookToolbox]", :immediately
  only_if "microk8s kubectl get nodes -oname | wc -l | grep 3"
end

git 'checkoutRook' do
  repository 'https://github.com/rook/rook.git'
  revision 'v1.6.5'
  action :nothing
  destination '/home/vagrant/rook'
end

bash 'installRookOperator' do
  cwd '/home/vagrant/rook/cluster/examples/kubernetes/ceph'
  action :nothing
  code <<-EOH
    microk8s kubectl create -f crds.yaml -f common.yaml -f operator.yaml
  EOH
end

execute "waitForRookOperator" do
  command "microk8s kubectl get pods -n rook-ceph | grep Running | wc -l | grep 1"
  action :nothing
  retries 120
  retry_delay 10
  timeout 10
end

bash 'createRookCephCluster' do
  cwd '/home/vagrant/rook/cluster/examples/kubernetes/ceph'
  action :nothing
  code <<-EOH
    microk8s kubectl create -f cluster.yaml
  EOH
end

execute "waitForRookCephCluster" do
  command "microk8s kubectl get pods -n rook-ceph | grep rook-ceph-osd-prepare | grep Completed | wc -l | grep 3"
  action :nothing
  retries 120
  retry_delay 10
  timeout 10
end

bash 'installRookToolbox' do
  cwd '/home/vagrant/rook/cluster/examples/kubernetes/ceph'
  action :nothing
  code <<-EOH
    microk8s kubectl create -f toolbox.yaml
  EOH
end


