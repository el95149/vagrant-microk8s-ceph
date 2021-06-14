name "default"
description "Default Environment"
default_attributes(
  :ntp => {
    :servers => ['0.pool.ntp.org', '1.pool.ntp.org']
  })
