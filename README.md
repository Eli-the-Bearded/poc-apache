Proof-of-Concept Apache
=======================

This is a set of files and directories structured to make very small
proof-of-concept Apache configs to test things with minimal conflicting
configuration and no special permissions. 

These files have been tested with, and have hardcoded path entries for,
Apache 2.4.x series web servers on Ubuntu systems.

As designed, only a single PoC instance can run at a time. Each
instance has its own set of htdocs, conf files, and logs however.
Use the `mknew.sh` script to create a new instance, then fill
out the conf and htdocs directories for that instance with your
file. Any one of the instances can be started using the appropriate
symlink to `env_vars_BASE.sh`. Eg: the sample CGI 404 handler:

```
$ ./env_vars_404.sh start
For conf 404 action start
Doc root is /home/username/git/poc-apache/htdocs_404
Logs are in /home/username/git/poc-apache/log_404
Site URL is http://apache.on-a.pizza:8000/
$ curl -I http://apache.on-a.pizza:8000/
HTTP/1.1 404 Not Found
Date: Mon, 16 Nov 2020 00:44:05 GMT
Server: Apache/2.4.29 (Ubuntu)
Content-Type: text/plain; charset="utf-8"

$ curl http://apache.on-a.pizza:8000/   
Debug info
----------

REDIRECT_REQUEST_METHOD = 'GET'

REDIRECT_STATUS = '404'

REDIRECT_URL = '/'

$ curl -I http://apache.on-a.pizza:8000/ddg
HTTP/1.1 302 Found
Date: Mon, 16 Nov 2020 00:48:03 GMT
Server: Apache/2.4.29 (Ubuntu)
Location: https://www.duckduckgo.com/

$ ./env_vars_404.sh stop
For conf 404 action stop
$
```

Note that `apache.on-a.pizza` resolves to 127.0.0.1

## Layout

* `apache-admin.conf`
  A basic conf file loading very few modules and with very little
  global configuration. It is expected that you won't need to edit
  this.
* `env_vars_BASE.sh`
  A wrapper script for `apache2ctl` which sets a number of environment
  variables. Symbolic links to this script are used for controlling
  different PoC instances.
  * `env_vars_`*instance*`.sh`
    Run the *instance* script to use a specific configuration.
* pid
  A common directory for the process ID files.
* `conf_`*instance*
  A directory for holding instance specific configuration.
  * `conf_`*instance*`/envvars`
    Will be sourced by `apache2ctl`, intended for adding additional
    variables to the server environment.
  * `conf_`*instance*`/`*foo*`.conf`
    Configuration files to be loaded into the server context.
  * `conf_`*instance*`/`*foo*`.vhconf`
    Configuration files to be loaded into the virtualhost context.
* `htdocs_`*instance*
  The document root directory for the instance.
* `log_`*instance*
  The logging directory for the instance.
* `mknew.sh`
  Helper script for creating a new instance.

## Provided instances

* *BASE*

  Minimal instance that just shows how this works.

* *404*

  An example of using a cgi script for an error page handler. In this
  case, the error handler provides a simplistic URL shortener service
  a la tinyurl.com

* keepalive

  An example of disabling the keepalive feature for a subset of URLs.
  You'll really see this in action if you make your request with a
  tool like `telnet`.

* mostlypasswd

  This example has the main index.html unprotected, but everything
  else password protected.

* redir

  A redirect http to https config. This doesn't provide the https
  server, and you probably don't have one configured, so it will
  not be very effective.

* ssi

  An example of a x-bit hack server side include config.

## Authorship

These files are by Eli the Bearded, 2016 to 2018.

## License

Released under the same license as the Apache 2.4.x web servers.

