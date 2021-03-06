class osnailyfacter::tools::tools {

  notice('MODULAR: tools/tools.pp')

  $custom_acct_file = hiera('custom_accounting_file', undef)
  $puppet = hiera('puppet')
  $deployment_mode = hiera('deployment_mode')

  class { '::osnailyfacter::atop':
    custom_acct_file => $custom_acct_file,
  }

  class { '::osnailyfacter::ssh': }

  if $::virtual != 'physical' {
    class { '::osnailyfacter::acpid': }
  }

  $tools = [
    'screen',
    'tmux',
    'htop',
    'tcpdump',
    'strace',
    'fuel-misc',
    'man-db',
  ]

  $cloud_init_services = [
    'cloud-config',
    'cloud-final',
    'cloud-init',
    'cloud-init-container',
    'cloud-init-local',
    'cloud-init-nonet',
    'cloud-log-shutdown',
  ]

  if ($::operatingsystem == 'Ubuntu') {
    service { $cloud_init_services:
      enable => false,
    }
  }

  package { $tools :
    ensure => 'present',
  }

  package { 'cloud-init':
    ensure => 'absent',
  }

  if $::osfamily == 'Debian' {
    apt::conf { 'notranslations':
      ensure        => 'present',
      content       => 'Acquire::Languages "none";',
      notify_update => false,
    }
  }

  class { '::osnailyfacter::puppet_pull':
    modules_source   => $puppet['modules'],
    manifests_source => $puppet['manifests'],
  }
}
