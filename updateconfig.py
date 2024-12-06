#!/usr/bin/python

import yaml

with open("config.yml") as f:
    y = yaml.safe_load(f)
    y['db']['admin']['password'] = 'new_admin_pass'
    print(yaml.dump(y, default_flow_style=False, sort_keys=False))
    