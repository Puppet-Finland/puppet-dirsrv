#
# == Class: dirsrv::monit
#
# Setup local monitoring for 389 Directory Servers and Admin Servers using 
# monit.
#
class dirsrv::monit
(
    $serveridentifier,
    $monitor_email

) inherits dirsrv::params
{
    monit::fragment { "dirsrv-dirsrv-${serveridentifier}.monit":
        modulename => 'dirsrv',
        basename => 'dirsrv',
    }

    monit::fragment { 'dirsrv-admin-srv.monit':
        modulename => 'dirsrv',
        basename => 'admin-srv',
    }
}
