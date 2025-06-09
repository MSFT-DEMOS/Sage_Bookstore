#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function help() {
  echo $1
  echo ""
  echo "create_patch_set.sh <branch> <directory> <name>"
  echo ""
  exit 1
}

branch_name=$1
if [[ -z $branch_name ]]; then
  help "Missing 'branch' parameter"
fi

outdir=$2
if [[ -z $outdir ]]; then
  help "Missing 'directory' (output) parameter"
else
  if [[ -d $outdir ]]; then
    echo "Using '${outdir}' as the output dir"
  else
    help "Specified output directory '${outdir}' is not a valid directory"
  fi
fi

feature_name=$3
if [[ -z $feature_name ]]; then
  echo "Using ${branch_name} as the feature name"
  feature_name=$branch_name
fi

echo ""
echo "Building patch set from branch: ${branch_name}"
echo "----------------------------------------------------"
echo ""

current_branch=`git rev-parse --abbrev-ref HEAD`
echo "Current Branch: $current_branch"
git checkout ${branch_name}
git format-patch ${current_branch} -U1 --stdout > ${outdir}/${feature_name}.patch
git checkout ${current_branch}

echo "Remember to copy the patch file into the repo and commit it!"
echo "done."