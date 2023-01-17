
import re
import os
import sys
import json
import shutil
import pathlib
import subprocess

def execute(command):
  success = True
  try:
    output = subprocess.check_output(command)
    print(output.decode())
  except:
    success = False
  return success

cwd = os.getcwd()
home = str(pathlib.Path.home())

if (len(sys.argv) <= 1):
  sys.exit(0)

build = os.path.join(cwd, ".build")
os.makedirs(build, exist_ok=True)

output = execute(sys.argv[1:])

packages = os.path.join(home, ".dub", "packages")
if not (os.path.exists(packages)):
  sys.exit(0)

selections = os.path.join(cwd, "dub.selections.json")
if not (os.path.exists(selections)):
  sys.exit(0)
descriptor = open(selections, "r")
selections = descriptor.read()
descriptor.close()
selections = json.loads(selections)
if not ("versions" in selections):
  sys.exit(0)
versions = selections["versions"]
keys = {}
for key in versions:
  version = versions[key]
  for root, folders, files in os.walk(packages):
    for folder in folders:
      if (folder == key+"-"+version):
        keys[key+"-"+version] = key
        if not (os.path.exists(os.path.join(build, folder))):
          if (os.path.exists(os.path.join(root, folder, key))):
            shutil.copytree(os.path.join(root, folder, key), os.path.join(build, folder))
        break
    break

for root, folders, files in os.walk(build):
  for folder in folders:
    os.chdir(os.path.join(root, folder))
    if (folder in keys):
      print(keys[folder])
      pattern = keys[folder].replace("-", "(-|_)").replace(".", "\\.")
      print(pattern)
      pattern = re.compile(pattern,  re.IGNORECASE)
      execute(sys.argv[1:])
      for base, _, names in os.walk(os.getcwd()):
        for name in names:
          if (("lib" in name) and not (pattern.search(name) == None)):
            path = os.path.join(base, name)
            if (os.path.exists(os.path.join(build, name))):
              continue
            shutil.copy(path, os.path.join(build, name))
    os.chdir(cwd)
  break

build = os.path.join(cwd, "build")
if (os.path.exists(build)):
  shutil.rmtree(build)
os.makedirs(build, exist_ok=True)
os.chdir(build)
execute(["cmake", "-DCMAKE_INSTALL_PREFIX=../install", ".."])
execute(["cmake", "--build", ".", "--target", "install"])
os.chdir(cwd)

