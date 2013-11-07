# Definition: rsyslog::filter
#
# This class filters syslog for a program to designated location.
#
# Parameters:
# - The $progname is the program name that you want to filter syslog
# - The $loc is location that program syslog is filtered to
# - The $error is a flag whether to filter only error message
#
# Actions:
# - Filter syslog for a program to designated location
#
# Requires:
# - rsyslog 
#
# Sample Usage:
#
# rsyslog::filter {'puppet-agent':}
#
# rsyslog::filter {'mytest':
#   progname => 'dhclient',
#   location => '/tmp/mytest.log',
# }
#
# rsyslog::filter {'mytest2':
#   progname => 'puppet-agent',
#   location => '/tmp/mytest2.log',
#   error    => true,
# }
#
# Authors:
#
# John Johann, Weigang Geng <weigang.geng@seagate.com>
#

define rsyslog::filter (
  $progname = $rsyslog::params::progname,
  $location = $rsyslog::params::location,
  $protocol = $rsyslog::params::protocol,
  $remote_server = $rsyslog::params::remote_server,
  $error    = $rsyslog::params::error,
  $port    = $rsyslog::params::port,
  $rotate    = $rsyslog::params::rotate,
  $syslogseverity = $rsyslog::params::syslogseverity
)
{

  # the $name variable contains the name/title of a decalred defined resource.
  # this is the value of the string before the colon when decaring the defined resource.

  # program name to be filtered
  if $progname == undef 
  {
    $program = $name # default program name
  } 
  else 
  {
    $program = $progname
  }

  # location/name of filtered log file
  if $location == undef 
  {
    $loc = "/var/log/${name}" # default location = /var/log/name
  } 
  # if not leading '/' add an assumed '/var/log/' prefix
  elsif $location !~ /^\//
  {  
    $loc = "/var/log/$location"
  }
  else
  {
    $loc = $location
  }

#  # whether to filter only error messages or all messages
#  $mycontent = $error ? {
#    true    => "if \$programname contains '${program}' and \$msg contains 'error' then ${loc}\n",
#    default => "if \$programname contains '${program}' then ${loc}\n",
#  }

  file {"${name}.conf":
    path    => "/etc/rsyslog.d/${name}.conf",
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => 0640,
    #content => $mycontent,
    content => template("rsyslog/filter.conf.erb"),
    #require => Package['rsyslog'],
    require => Class["rsyslog::install"],
    # rsyslog require a restart to load the config file when configuration has changed.
    #notify  => Service['rsyslog'],
    notify  => Class["rsyslog::service"],
  }

  if $rotate
  {
    file {"${name}rotate.conf":
      path    => "/etc/logrotate.d/${name}rotate.conf",
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => 0640,
      content => template("rsyslog/rotate.conf.erb"),
      require => Class["rsyslog::install"],
      # rsyslog require a restart to load the config file when configuration has changed.
      notify  => Class["rsyslog::service"],
    } 
  }

}


