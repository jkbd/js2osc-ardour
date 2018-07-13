#!/usr/bin/env python

import subprocess
import sys

executable = sys.argv[1]
print(executable)

if len(sys.argv) == 2 and sys.argv[1] != "":
    completed_process = subprocess.run(
        sys.argv[1],
        shell=True,
        stdout=subprocess.PIPE
    )

    msg = completed_process.stdout.decode()
    if msg.strip() == "Usage: js2osc <device> <osc_url>":
        sys.exit(0)

sys.exit(1)
    
