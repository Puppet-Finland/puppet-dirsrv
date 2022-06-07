#
# == Class: dirsrv::config::backup
#
# Prepare for dirsrv backups
#
class dirsrv::config::backup
(
    String $rootdn_pwd,
    String $output_dir = '/var/backups/local'

) inherits dirsrv::params
{

    # Ensure that backup directory is present
    include ::localbackups

    # Create the backup directory
    file { 'dirsrv-dirsrv':
        ensure  => directory,
        name    => '/var/backups/local/dirsrv',
        owner   => $::dirsrv::params::suite_spot_user_id,
        group   => 'root',
        mode    => '0750',
        seluser => $::dirsrv::params::backup_dir_seluser,
        selrole => $::dirsrv::params::backup_dir_selrole,
        seltype => $::dirsrv::params::backup_dir_seltype,
        require => Exec['dirsrv-setup-ds-admin'],
    }

    # Put the directory manager password to a file, so that cronjobs that error 
    # out don't send it in plaintext.
    file { 'dirsrv-manager-pass':
        ensure  => present,
        name    => "${::dirsrv::params::config_dir}/manager-pass",
        content => template('dirsrv/manager-pass.erb'),
        owner   => $::dirsrv::params::suite_spot_user_id,
        group   => 'root',
        mode    => '0750',
        require => Class['dirsrv::install'],
    }
}
