# Vagrant/Chef based MicroK8s + Ceph cluster #

A **WIP** three node sandbox/playground.

## Dependencies
- vagrant-omnibus plugin

## Procedure

Bring the cluster up:

```shell
$ vagrant up
```

Go grab a cup of Java (pun intended!) and wait for provisioning to end.

Verify that the cluster's up and running.

```shell
$ vagrant ssh kube01
$ microk8s kubectl get nodes
```

You should get an output similar to:
```shell
NAME     STATUS   ROLES    AGE     VERSION
kube03   Ready    <none>   5m25s   v1.21.1-3+1f02fea99e2268
kube02   Ready    <none>   9m34s   v1.21.1-3+1f02fea99e2268
kube01   Ready    <none>   15m     v1.21.1-3+1f02fea99e2268 
```

Re-provision the first node to deploy Ceph (inlc. toolbox):

```shell
$ vagrant provision kube01
```

Go grab a 2nd cup of Joe.

Check Ceph status:

```shell
$ vagrant ssh kube01
$ microk8s kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash
$ ceph status
```

You should get something like this:

```shell
 cluster:
    id:     f509a99e-9be7-4de9-8849-3a0301620a87
    health: HEALTH_OK
 
  services:
    mon: 3 daemons, quorum a,b,c (age 8m)
    mgr: a(active, since 9m)
    osd: 3 osds: 3 up (since 8m), 3 in (since 12h)
 
  data:
    pools:   1 pools, 1 pgs
    objects: 3 objects, 0 B
    usage:   3.0 GiB used, 27 GiB / 30 GiB avail
    pgs:     1 active+clean
```

**TIP:** Notice how the extra disks we attached to the VMs in the beginning of the process were automatically claimed by Ceph, because they werent partitioned/mounted! 

## Post install *(Optional)* 

Below are a few things you can try out, after finishing the installation & provisioning.

### Access the Microk8s dashboard

```shell
$ vagrant ssh kube01
$ microk8s kubectl -n kube-system describe secret $(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1) | grep token: | sed 's/^[ \t]*//;s/[ \t]*$//'
$ microk8s kubectl describe -n kube-system service kubernetes-dashboard | grep IP: | sed 's/^[ \t]*//;s/[ \t]*$//'
$ exit
```
Copy the long token and the IP address,  you'll need them to log into the dashboard.

Back on the host, start an SSH tunnel into the dashboard service on kube01:
```shell
$ ssh -p 2222 -N -L 127.0.0.1:10443:<IP copied in previous step>:443 vagrant@127.0.0.1
```
(The password for the above ^^ is 'vagrant')


### Check Ceph status

```shell
$ vagrant ssh kube01
$ microk8s kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash
$ ceph status
$ ceph osd status
$ ceph df
$ rados df
```
