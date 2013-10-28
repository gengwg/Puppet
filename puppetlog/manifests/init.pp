class puppetlog {

    package {'rsyslog':
        ensure => installed,
    }   

    file {'puppetlog.conf':
      path    => '/etc/rsyslog.d/puppetlog.conf',
      ensure  => present,
      mode    => 0640,
      # content => "if $programname == 'puppet-agent' then /tmp/puppet-agent.log",
      require => Package['rsyslog'],
      #source  => "/etc/puppet/modules/puppetlog/files/puppetlog.conf",
      #source  => "puppet:///modules/puppetlog/puppetlog.conf",
      content => template("puppetlog/puppetlog.conf.erb"),
    }   

    service { 'rsyslog':
      ensure    => running,
      enable    => true,
      subscribe => File['puppetlog.conf'],
    }   

}
