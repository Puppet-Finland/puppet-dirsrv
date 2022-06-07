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
    $dir_service_start = "systemctl start ${::dirsrv::params::dir_service_name}@${serveridentifier}"
    $dir_service_stop = "systemctl stop ${::dirsrv::params::dir_service_name}@${serveridentifier}"

    monit::fragment { "dirsrv-dirsrv-${serveridentifier}.monit":
        modulename => 'dirsrv',
        basename   => 'dirsrv',
    }

    monit::fragment { 'dirsrv-admin-srv.monit':
        modulename => 'dirsrv',
        basename   => 'admin-srv',
    }
}
