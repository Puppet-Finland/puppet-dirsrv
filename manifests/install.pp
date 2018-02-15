#
# == Class: dirsrv::install
#
# Install 389 Directory Server
#
class dirsrv::install inherits dirsrv::params {

    package { [ $::dirsrv::params::base_package_name, $::dirsrv::params::admin_package_name ]:
        ensure  => installed,
        require => Class['dirsrv::prequisites'],
    }
}
