#!/usr/bin/env python

import os.path, sys
from glob import glob

path = sys.argv[1]

path = os.path.abspath(path)
while not os.path.ismount(path):
  path = os.path.dirname(path)
if path != '/':
  # We are not on the root file system, this should be ok
  sys.exit(0)
aufs = glob('/sys/fs/aufs/*/br0')
if not aufs:
  # There is no aufs running?, This is unusual but probably no problem
  sys.exit(0)
with open(aufs[0]) as fp:
  branch = fp.read().strip()
if 'memory' in branch:
  # We are on a temporary memory-based branch, this is dangerous
  sys.exit(1)
else:
  # Branch is backed by permanent storage
  sys.exit(0)

