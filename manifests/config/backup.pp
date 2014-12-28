#
# == Class: dirsrv::config::backup
#
# Prepare for dirsrv backups
#
class dirsrv::config::backup
(
    $rootdn_pwd

) inherits dirsrv::params
{

    include os::params

    # Create the backup directory
    file { 'dirsrv-dirsrv':
        name => '/var/backups/local/dirsrv',
        ensure => directory,
        owner => "${::dirsrv::params::suite_spot_user_id}",
        group => "${::os::params::admingroup}",
        mode => 750,
        require => Class['localbackups'],
    }

    # Put the directory manager password to a file, so that cronjobs that error 
    # out don't send it in plaintext.
    file { 'dirsrv-manager-pass':
        ensure => present,
        name => "${::dirsrv::params::config_dir}/manager-pass",
        content => template('dirsrv/manager-pass.erb'),
        owner => "${::dirsrv::params::suite_spot_user_id}",
        group => "${::os::params::admingroup}",
        mode => 750,
        require => Class['dirsrv::install'],
    }
}
