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

class rsyslog::install {
  package {'rsyslog':
    ensure => installed,
  }
}

class rsyslog::service {
  service { 'rsyslog': 
    ensure    => running,
    enable    => true,
    hasrestart => true,
    # require => Package['rsyslog'],
    require => Class["rsyslog::install"],
  }   
}
class rsyslog {
  include rsyslog::install, rsyslog::service
}

