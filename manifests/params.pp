#
# == Class: dirsrv::params
#
# Defines some variables based on the operating system
#
class dirsrv::params {

    case $::osfamily {
        'Debian': {
            $dscreate = '/usr/sbin/dscreate'
            $backup_dir_seluser = undef
            $backup_dir_selrole = undef
            $backup_dir_seltype = undef
        }
        'RedHat': {
            $dscreate = '/usr/sbin/dscreate'
            $backup_dir_seluser = 'unconfined_u'
            $backup_dir_selrole = 'object_r'
            $backup_dir_seltype = 'dirsrv_var_lib_t'
        }
        default: { fail("Unsupported operating system: ${::osfamily}") }
    }

    $metapackage_name = '389-directory-server:stable'
    $config_dir = '/etc/dirsrv'
    $suite_spot_user_id = 'dirsrv'
    $suite_spot_group = 'dirsrv'
    $piddir = '/var/run/dirsrv'
    $dir_service_name = 'dirsrv'
    $admin_service_name = 'dirsrv-admin'
    $admin_srv_pidfile = "${piddir}/admin-serv.pid"

    # Parameters for the directory server (dirsrv) are managed in service.pp and 
    # monit.pp because on systemd distros there can be several dirsrv instances 
    # running, and it is therefore impossible to define a static string for the 
    # service commands.
    $admin_service_start = "systemctl start ${admin_service_name}"
    $admin_service_stop = "systemctl stop ${admin_service_name}"
}
