# Class: rsyslog 
#
# This class installs Rsyslog 
#
# Parameters:
#
# Actions:
#   - Install Rsyslog 
#   - Start Rsyslog service
#
# Requires:
#
# Sample Usage:
#

class rsyslog {
  package {'rsyslog':
    ensure => installed,
  }

  service { 'rsyslog': 
    ensure    => running,
    enable    => true,
    hasrestart => true,
    require => Package['rsyslog'],
  }   
}
