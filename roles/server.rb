name 'server'
description 'Role to configure a Kubernetes master'
run_list [
           'recipe[common::default]', 'recipe[ntp::default]', 'recipe[git::default]',
           'recipe[common::microk8s]', 'recipe[common::microk8s-master]',
           'recipe[common::rook]'
         ]
