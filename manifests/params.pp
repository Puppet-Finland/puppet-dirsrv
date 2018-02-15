#
# == Class: dirsrv::params
#
# Defines some variables based on the operating system
#
class dirsrv::params {

    include ::os::params

    case $::osfamily {
        'Debian': {
            $package_name = '389-ds'
            $config_dir = '/etc/dirsrv'
            $suite_spot_user_id = 'dirsrv'
            $suite_spot_group = 'dirsrv'
            $piddir = '/var/run/dirsrv'
            $dir_service_name = 'dirsrv'
            $admin_service_name = 'dirsrv-admin'
            $admin_srv_pidfile = "${piddir}/admin-serv.pid"
        }
        'RedHat': {
            $package_name = '389-ds-base'
            $config_dir = '/etc/dirsrv'
            $suite_spot_user_id = 'dirsrv'
            $suite_spot_group = 'dirsrv'
            $piddir = '/var/run/dirsrv'
            $dir_service_name = 'dirsrv'
            $admin_service_name = 'dirsrv-admin'
            $admin_srv_pidfile = "${piddir}/admin-serv.pid"
        }
        default: { fail("Unsupported operating system: ${::osfamily}") }

    }

    # Parameters for the directory server (dirsrv) are managed in service.pp and 
    # monit.pp because on systemd distros there can be several dirsrv instances 
    # running, and it is therefore impossible to define a static string for the 
    # service commands.
    if str2bool($::has_systemd) {
        $admin_service_start = "${::os::params::systemctl} start ${admin_service_name}"
        $admin_service_stop = "${::os::params::systemctl} stop ${admin_service_name}"
    } else {
        $admin_service_start = "${::os::params::service_cmd} ${admin_service_name} start"
        $admin_service_stop = "${::os::params::service_cmd} ${admin_service_name} stop"
    }
}
