
exec { "apt-get update":
	path => "/usr/bin",
  }

package { "tmux":
  ensure  => present,
  require => Exec["apt-get update"],
  }

package { "git":
  ensure  => present,
  require => Exec["apt-get update"],
  }  
  
package { "python3":
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
  
package { "ruby":
  ensure  => present,
  require => Exec["apt-get update"],
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

# download & install exercism (http://exercism.io)
#curl -O https://raw.githubusercontent.com/exercism/cli-www/master/public/install
#chmod +x install
#DIR=/path/to/bin ./install
  
# maybe this should be cloned to a shared folder so
# i can use something like pycharm?
define fetch_github_repo($repo=undef) {
  vcsrepo { "/home/vagrant/${repo}":
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

# copy the .dotfiles to where they should be
