#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

feature_name=$1
if [[ -z $feature_name ]]; then
  echo "Missing feature name from the command line parameters."
  exit 1
fi

if [[ -z $2 ]]; then
  feature_branch_name="feature-${feature_name}"
else
  feature_branch_name="$2"
fi

current_branch=`git rev-parse --abbrev-ref HEAD`
echo "Current Branch: $current_branch"

feature_branch_result=`git branch --list ${feature_branch_name}`
if  [[ -z $feature_branch_exists ]]; then
  echo "Creating new feature branch: ${feature_branch_name}"
  git checkout -b ${feature_branch_name}
else
  echo "Feature branch '${feature_branch_name}' already exists, please delete it before trying again..."
  exit 2
fi

$DIR/apply_patch.sh $feature_name

if [ $? -ne 0 ]; then
  echo ""
  echo "Failed to apply patch."
  echo ""
  echo "This is probably because you modified the code the patch was looking for."
  echo ""
  echo "You can try to revert changes to the code by HARD resetting the branch."
  echo "This will revert all changes to the code, so be careful!"
  echo "To do so, run the following command:"
  echo "  git reset --hard HEAD"
  echo ""
fi