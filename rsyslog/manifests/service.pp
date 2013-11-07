
class rsyslog::service {
  service { 'rsyslog': 
    ensure    => running,
    enable    => true,
    hasstatus => true,
    hasrestart => true,
    # require => Package['rsyslog'],
    require => Class["rsyslog::install"],
  }   
}

