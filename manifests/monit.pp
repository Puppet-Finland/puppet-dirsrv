#
# == Class: dirsrv::monit
#
# Setup local monitoring for 389 Directory Servers and Admin Servers using 
# monit.
#
class dirsrv::monit
(
    String $serveridentifier,
    String $monitor_email

) inherits dirsrv::params
{
    if str2bool($::has_systemd) {
        $dir_service_start = "${::os::params::systemctl} start ${::dirsrv::params::dir_service_name}@${serveridentifier}"
        $dir_service_stop = "${::os::params::systemctl} stop ${::dirsrv::params::dir_service_name}@${serveridentifier}"
    } else {
        $dir_service_start = "${::os::params::service_cmd} ${::dirsrv::params::dir_service_name} start"
        $dir_service_stop = "${::os::params::service_cmd} ${::dirsrv::params::dir_service_name} stop"
    }

    monit::fragment { "dirsrv-dirsrv-${serveridentifier}.monit":
        modulename => 'dirsrv',
        basename   => 'dirsrv',
    }

    monit::fragment { 'dirsrv-admin-srv.monit':
        modulename => 'dirsrv',
        basename   => 'admin-srv',
    }
}
