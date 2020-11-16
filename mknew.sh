#!/bin/sh
# Make a new test set.
# usage:    mknew.sh NAME

if [ "X$1" = X ] ; then
  echo "$0: need a name" >&2
  exit 2
fi

if [ -d "conf_$1" ] ; then
  echo "$0: name $1 has already been used" >&2
  exit 2
fi

ln -s env_vars_BASE.sh "env_vars_$1.sh"

mkdir "conf_$1" "htdocs_$1" "log_$1"
touch "log_$1/.placeholder"

echo "Created conf_$1/ for configuration,"
echo "htdocs_$1/ for documents, and"
echo "log_$1/ for logs."
echo "After configuring, start or stop a server with: "
echo "./env_vars_$1.sh [start | stop]"

