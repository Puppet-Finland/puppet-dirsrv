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

    # Several other modules will attempt ensure that this same directory exists
    ensure_resource('file', $output_dir, { 'ensure' => 'directory' })

    # Create the backup directory
    file { 'dirsrv-dirsrv':
        ensure  => directory,
        name    => '/var/backups/local/dirsrv',
        owner   => $::dirsrv::params::suite_spot_user_id,
        group   => $::os::params::admingroup,
        mode    => '0750',
        require => File[$output_dir],
    }

    # Put the directory manager password to a file, so that cronjobs that error 
    # out don't send it in plaintext.
    file { 'dirsrv-manager-pass':
        ensure  => present,
        name    => "${::dirsrv::params::config_dir}/manager-pass",
        content => template('dirsrv/manager-pass.erb'),
        owner   => $::dirsrv::params::suite_spot_user_id,
        group   => $::os::params::admingroup,
        mode    => '0750',
        require => Class['dirsrv::install'],
    }
}
