#
# == Class: dirsrv::service
#
# Enable dirsrv service
#
class dirsrv::service
(
    String $serveridentifier

) inherits dirsrv::params {

    if $::systemd {
        $service_name = "${::dirsrv::params::dir_service_name}@${serveridentifier}"
    } else {
        $service_name = $::dirsrv::params::dir_service_name
    }

    service { 'dirsrv-dirsrv':
        name    => $service_name,
        enable  => true,
        require => Class['dirsrv::install'],
    }

    service { 'dirsrv-admin-srv':
        name    => $::dirsrv::params::admin_service_name,
        enable  => true,
        require => Class['dirsrv::install'],
    }
}
