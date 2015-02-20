#
# == Class: dirsrv::install
#
# Install 389 Directory Server
#
class dirsrv::install inherits dirsrv::params {

    package { 'dirsrv-389-ds':
        name => "${::dirsrv::params::package_name}",
        ensure => installed,
        require => Class['dirsrv::prequisites'],
    }
}
