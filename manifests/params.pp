#
# == Class: dirsrv::params
#
# Defines some variables based on the operating system
#
class dirsrv::params {

    case $::osfamily {
        default: { fail("Unsupported operating system: ${::osfamily}") }
        'Debian': {
            $package_name = '389-ds'
            $config_dir = '/etc/dirsrv'
            $suite_spot_user_id = 'dirsrv'
            $suite_spot_group = 'dirsrv'
            $piddir = '/var/run/dirsrv'
            $dir_service_name = 'dirsrv'
            $dir_service_start = "/usr/sbin/service $dir_service_name start"
            $dir_service_stop = "/usr/sbin/service $dir_service_name stop"
            $admin_service_name = 'dirsrv-admin'
            $admin_service_start = "/usr/sbin/service $admin_service_name start"
            $admin_service_stop = "/usr/sbin/service $admin_service_name stop"
            $admin_srv_pidfile = "$piddir/admin-serv.pid"
        }
    }
}
