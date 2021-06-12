name "default"
description "Default Environment"
default_attributes(
  :ntp => {
    :pools => ['uk.pool.ntp.org']
  })
