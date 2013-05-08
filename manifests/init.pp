# Public: Install and configure git from homebrew.
#
# Examples
#
#   include git
class git {
  include homebrew
  include git::config

  homebrew::formula { 'git':
    before => Package['boxen/brews/git'],
  }

  package { 'boxen/brews/git':
    ensure => $git::config::version
  }

  file { $git::config::configdir:
    ensure => directory
  }

  file { $git::config::credentialhelper:
    ensure => file
  }

  file { $git::config::global_credentialhelper:
    ensure  => link,
    target  => $git::config::credentialhelper,
    before  => Package['boxen/brews/git'],
    require => File[$git::config::credentialhelper]
  }

  git::config::global{ 'credential.helper':
    value => $git::config::global_credentialhelper
  }

  if $::gname {
    git::config::global{ 'user.name':
      value => $::gname
    }
  }

  if $::gemail {
    git::config::global{ 'user.email':
      value => $::gemail
    }
  }
}
