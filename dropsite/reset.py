#!/usr/bin/env python3.6

import json
import os

uploads = '/uploads'

with open(os.path.join(uploads, 'last_run.json'), 'w') as fh:
    fh.write(json.dumps(list()))
