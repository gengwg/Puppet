    define planfile ($user = $title, $content) {
      file {"/home/${user}/.plan":
      # file {".plan":
        path    => "/home/${user}/.plan",
        ensure  => file,
        content => $content,
        mode    => 0644,
        owner   => $user,
        require => User[$user],
      }   
    } 
