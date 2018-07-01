#!/usr/bin/env python3

import sysconfig
for k,v in sysconfig.get_config_vars().items():
  print('{} = {}'.format(k,v))
