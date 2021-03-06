###
# stage defn

stage { 'prereqs':
	before => Stage['main'],
	}
  
stage { 'final':
  require => Stage['main'],
  }

###
# class defn
  
class dothisfirst {  
  exec { "apt-get update":
    path => "/usr/bin",
    }
  }

class packages {
  
  package { "tmux":
    ensure  => present,
    require => Exec["apt-get update"],
    }

  package { "git":
    ensure  => present,
    require => Exec["apt-get update"],
    }
	
  package { "gdb":
    ensure  => present,
    require => Exec["apt-get update"],
    }  
    
  package { "python3":
    ensure  => present,
    require => Exec["apt-get update"],
    }

  package { "python3-pip":
    ensure  => present,
    require => Exec["apt-get update"],
    }
    
  package { "python3-crypto":
    ensure  => present,
    require => Package["python3"],
    }
    
  package { "python3-gmpy2":
    ensure  => present,
    require => Package["python3"],
    }
    
  package { "python3-numpy":
    ensure  => present,
    require => Package["python3"],
    }
  
  package { "python3-matplotlib":
    ensure  => present,
    require => Package["python3"],
    }
  
  package { "python3-pandas":
    ensure  => present,
    require => Package["python3"],
    }
  
  package { "python3-pygments":
    ensure  => present,
    require => Package["python3"],
    }
  
  package { "ipython3":
    ensure  => present,
    require => Package["python3"],
    }
    
  package { "ipython3-notebook":
    ensure  => present,
    require => Package["ipython3"],
    }
    
  package { "nodejs":
    ensure  => present,
    require => Exec["apt-get update"],
    }
  
  package { "npm":
    ensure  => present,
    require => Package["nodejs"],
    }
    
  package { "ruby":
    ensure  => present,
    require => Exec["apt-get update"],
    }

  package { "ruby-dev":
    ensure  => present,
    require => Package["ruby"],
    }
  
  package { "rubygems-integration":
    ensure  => present,
    require => Package["ruby"],
    }

  package { 'jekyll':
      ensure   => 'installed',
      provider => 'gem',
      require => [Package["ruby"], Package["rubygems-integration"]],
    }
    
  package { "fish":
    ensure  => present,
    require => Exec["apt-get update"],
    }
    
  package { "erlang-base":
    ensure  => present,
    require => Exec["apt-get update"],
    }

  package { "erlang-dev":
    ensure  => present,
    require => Exec["apt-get update"],
    }
  
  package { "erlang-eunit":
    ensure  => present,
    require => Exec["apt-get update"],
    }
    
  package { "golang":
    ensure  => present,
    require => Exec["apt-get update"],
    }
    
  package { "sqlite3":
    ensure  => present,
    require => Exec["apt-get update"],
    }
  }
  
  package { "pandoc":
    ensure  => present,
    require => Package["python3"],
    }

  package { "docker.io":
    ensure  => present,
    require => Exec["apt-get update"],
    }

  # on a full-blown system i'd use xmonad, but it requires too much space
  # when all i want to do is view TensorFlow simulations  
  # thanks to https://peteris.rocks/blog/remote-desktop-and-vnc-on-ubuntu-server/
  package { "xfce4":
    ensure  => present,
    require => Exec["apt-get update"],
    }
    
  package { "tightvncserver":
    ensure  => present,
    require => Exec["apt-get update"],
    }
    
  package { "xrdp":
    ensure  => present,
    require => Exec["apt-get update"],
    }
    
class github {

  # maybe this should be cloned to a shared folder so
  # i can use something like pycharm?
  define fetch_github_repo($repo=undef) {
    vcsrepo { "/shared/${repo}":
      ensure   => latest,
      provider => git,
      require  => [ Package["git"] ],
      source   => "https://github.com/axiomiety/${repo}.git",
      revision => 'master',
      }
  }

  fetch_github_repo{'exercism-io':
    repo  => 'exercism-io',
    }
    
  fetch_github_repo{'axiomiety.github.io':
    repo  => 'axiomiety.github.io',
    }
    
  fetch_github_repo{'crashburn':
    repo  => 'crashburn',
    }
    
  fetch_github_repo{'setup':
    repo  => 'setup',
    }
  }

class dothislast {
  
	# copy the .dotfiles to where they should be
	exec {"copy_dot_files":
		command  => '/shared/setup/copy_dot_files.sh',
		path     => '/usr/local/bin/:/bin/',
    }

	# grab exercism cli
	exec {"exercism":
		command       => 'go get github.com/exercism/cli/exercism',
		path          => '/usr/local/bin/:/bin/:/usr/bin',
    environment   => ["GOPATH=/home/vagrant/go-ws"]
    }

	# make sure ownership of everything in ~ is set to the vagrant user
	# it's root otherwise...
	#exec {"chown_vagrant":
	#	command => 'chown -hR vagrant /home/vagrant/*',
	#	path    => '/usr/local/bin/:/bin/',
  #  }
  }

###
# assign stages to classes

class { 'dothisfirst':
  stage => prereqs,
  }

class { 'github':
  stage => main,
  }
  
class { 'dothislast':
  stage => final,
  }

include dothisfirst
include packages
include github
include dothislast
