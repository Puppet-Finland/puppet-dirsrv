#
# @summary defines some variables based on the operating system
#
class dirsrv::params {

    case $::osfamily {
        'RedHat': {
            $backup_dir_seluser   = 'unconfined_u'
            $backup_dir_selrole   = 'object_r'
            $backup_dir_seltype   = 'dirsrv_var_lib_t'
            $dscreate             = '/usr/sbin/dscreate'
            $metapackage_name     = '389-directory-server:stable'
            $metapackage_flavor   = 'default'
            $metapackage_provider = 'dnfmodule'
            $piddir               = '/run/dirsrv'
        }
        default: { fail("Unsupported operating system: ${::osfamily}") }
    }

    $config_dir = '/etc/dirsrv'
    $suite_spot_user_id = 'dirsrv'
    $suite_spot_group = 'dirsrv'

    $dir_service_name = 'dirsrv'
}
