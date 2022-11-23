#!/bin/bash

# Increment a version string using Semantic Versioning (SemVer) terminology, and adds it to git-tags
# - Customised from: https://github.com/fmahnke/shell-semver/blob/master/increment_version.sh)

# INSTALL: put the script in a PATH directory. 'git' will recognize automatically the new command.
# USAGE: "git tag++ -p"
#        "git tag++ -Mp"
# BEWARE: "git describe" returns the last-tag JUST for the current tree!
#         if amend a commit the SHA will change and the eventual tag will still point to the old unchanged commit
#         delete and recreate the tag, in order to fix it.

# Parse command line options.

while getopts ":Mmp" Option
do
  case $Option in
    M ) major=true;;
    m ) minor=true;;
    p ) patch=true;;
  esac
done

shift $(($OPTIND - 1))

if [ $1 -z ]
then
  version=$(git describe --abbrev=0 --tags)
else
  version=$1
fi

# Build array from version string.

a=( ${version//./ } )

# If version string is missing or has the wrong number of members, show usage message.

if [ ${#a[@]} -ne 3 ]
then
  echo "usage: $(basename $0) [-Mmp] major.minor.patch"
  exit 1
fi

# Increment version numbers as requested.

if [ ! -z $major ]
then
  ((a[0]++))
  a[1]=0
  a[2]=0
fi

if [ ! -z $minor ]
then
  ((a[1]++))
  a[2]=0
fi

if [ ! -z $patch ]
then
  ((a[2]++))
fi

git tag "${a[0]}.${a[1]}.${a[2]}"

if [ $? -eq 0 ]; then
  echo "Added new tag: ${a[0]}.${a[1]}.${a[2]} (previous was $version)"
  exit 0
else
  echo "Did you specify the target parts? (-Mmp) [ M=Major m=minor p=patch ]"
  exit 1
fi
