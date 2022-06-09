#
# @summary install 389 Directory Server package
#
class dirsrv::install (
  # lint:ignore:parameter_documentation
  Boolean $manage_epel
  # lint:endignore
) inherits dirsrv::params {
  if $facts['os']['family'] == 'RedHat' {
    if $manage_epel {
      include epel
    }
    # This module depends on EPEL even if it does not include it
    $require = [Class['epel'], Package['rubygem-net-ldap']]
  } else {
    $require = Package['rubygem-net-ldap']
  }

  package { 'rubygem-net-ldap':
    ensure   => 'present',
    name     => 'net-ldap',
    provider => 'puppet_gem',
  }

  package { $dirsrv::params::metapackage_name:
    ensure   => installed,
    flavor   => $dirsrv::params::metapackage_flavor,
    provider => $dirsrv::params::metapackage_provider,
    require  => $require,
  }
}
