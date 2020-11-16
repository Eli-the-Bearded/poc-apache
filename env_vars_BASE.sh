#!/bin/sh
# usage env_vars_(NAME).sh [ stop | start | graceful | cleanstart ]
#
# start/stop apache with some custom test conf
#
# The "stop", "start", and "graceful" options are just passed to
# apache2ctl; "cleanstart" will truncate log files and then run
# "start". (Truncate instead of deletion for a better "tail -f"
# experience.)
#
# each env_vars_(NAME).sh has it's own files, but all use
# same hostname / port
# 		-> so only run one at once
#
# It is expected that you do not need to modify this file for any
# particular example config.
#
# Original version circa 2016.


# for $0: /home/username/source/poc-apache/env_vars_BAZ.sh
#    fullname = env_vars_BAZ.sh
#       sname =          BAZ.sh
#        name =          BAZ
fullname=${0##*/}
sname=${fullname##*_}
name=${sname%%.*}

# readlink -f to find canonicalized location of $0
fullprogram=`readlink -f $0`
# then get the directory it is in
fulldir=${fullprogram%/*}

echo "For conf $name action $1"

export       ADMIN_ROOT="$fulldir"
export       ADMIN_BASE="$ADMIN_ROOT/"

# It is expected that apache.on-a.pizza resolves to 127.0.0.1, aka localhost
export  APACHE_HOSTNAME=apache.on-a.pizza
export      APACHE_PORT=8000

export   APACHE_CONFDIR="$ADMIN_BASE"
export APACHE_EXTRA_DIR="$ADMIN_BASE/conf_$name"
export  APACHE_PID_FILE="$ADMIN_BASE/pid/env_vars_$name.pid"
export   APACHE_RUN_DIR="$ADMIN_BASE/.run"
export  APACHE_LOCK_DIR="$ADMIN_BASE/.lock"
export   APACHE_LOG_DIR="$ADMIN_ROOT/log_$name"
export   APACHE_DOCROOT="$ADMIN_ROOT/htdocs_$name"
export APACHE_ARGUMENTS="-f $ADMIN_BASE/apache-admin.conf"
 
if [ "$1" != stop ] ; then
  echo "Doc root is $APACHE_DOCROOT"
  echo "Logs are in $APACHE_LOG_DIR"
  echo "Site URL is http://$APACHE_HOSTNAME:$APACHE_PORT/"
fi

mkdir -p $APACHE_CONFDIR/pid $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR $APACHE_DOCROOT $APACHE_EXTRA_DIR

# If set and exists will be sourced by apache2ctl.
# If not set, will default to $APACHE_CONFDIR/envvars
# Set here to force the envvars to be in the instance dir.
export APACHE_ENVVARS="$APACHE_EXTRA_DIR/envvars"

if [ "$1" = cleanstart ] ; then
  shift; set start
  for log in `ls -A $APACHE_LOG_DIR` ; do
    : > "$APACHE_LOG_DIR/$log" 2> /dev/null
  done
fi

exec /usr/sbin/apache2ctl $@
