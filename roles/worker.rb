name 'server'
description 'Role to configure a Kubernetes worker'
run_list [
           'recipe[common::default]', 'recipe[ntp::default]', 'recipe[git::default]',
           'recipe[common::microk8s]', 'recipe[common::microk8s-worker]'
         ]
