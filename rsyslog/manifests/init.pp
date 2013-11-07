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
  include rsyslog::params, rsyslog::install, rsyslog::service
  # don't need to include rsyslog::filter, because calling it implies inclusion.
}

