#
# == Class: dirsrv::service
#
# Enable dirsrv service
#
class dirsrv::service inherits dirsrv::params {

    service { 'dirsrv-dirsrv':
        name    => $::dirsrv::params::dir_service_name,
        enable  => true,
        require => Class['dirsrv::install'],
    }

    service { 'dirsrv-admin-srv':
        name    => $::dirsrv::params::admin_service_name,
        enable  => true,
        require => Class['dirsrv::install'],
    }
}
