#
# == Class: dirsrv::install
#
# Install 389 Directory Server
#
class dirsrv::install inherits dirsrv::params {

    package { 'dirsrv-389-ds':
        ensure  => installed,
        name    => $::dirsrv::params::package_name,
        require => Class['dirsrv::prequisites'],
    }
}
