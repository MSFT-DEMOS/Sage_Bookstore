#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

feature_name=$1
if [[ -z $feature_name ]]; then
  echo "Missing feature name from the command line parameters."
  exit 1
fi

patch_path=${DIR}/${feature_name}.patch
echo ""
echo "Checking for patch file at ${patch_path}..."
if [[ ! -f ${patch_path} ]]; then
  echo "Patch file not found."
  exit 1
fi

patch_args="--reject --whitespace=fix --verbose"

echo ""
echo "Running check on patch file..."
git apply ${patch_path} --check ${patch_args}

# was the check successful?
if [ $? -eq 0 ]; then
  echo ""
  echo "Applying patch ${patch_path}..."
  git apply ${patch_path} ${patch_args}

  # was the patch applied successfully?
  if [ $? -eq 0 ]; then
    echo "Completed!"
    exit 0
  else
    # delete all files in all subdirs with the extension ".rej"
    find . -name "*.rej" -type f -delete
    echo "Patch failed to apply."
    exit 1
  fi
else
  echo "Patch check failed."
  exit 1
fi