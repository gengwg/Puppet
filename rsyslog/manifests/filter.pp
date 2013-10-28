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

define rsyslog::filter (
  $progname = undef,
  $location = undef,
  $error    = false,
)
{

  if $progname == undef 
  {
    $program = $name
  } 
  else 
  {
    $program = $progname
  }

  if $location == undef 
  {
    $loc = "/var/log/${name}"
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

  # whether to filter only error messages or all messages
  $mycontent = $error ? {
    true    => "if \$programname contains '${program}' and \$msg contains 'error' then ${loc}\n",
    default => "if \$programname contains '${program}' then ${loc}\n",
  }

  file {"${name}.conf":
    path    => "/etc/rsyslog.d/${name}.conf",
    ensure  => present,
    mode    => 0640,
    require => Package['rsyslog'],
    content => $mycontent,
    # rsyslog require a restart to load the config file when configuration has changed.
    notify  => Service['rsyslog'],
  }

}


