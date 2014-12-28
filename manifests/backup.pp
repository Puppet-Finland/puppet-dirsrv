#
# == Define: dirsrv::backup
#
# Dump LDAP databases to a directory using db2ldif. New dumps overwrite the old 
# ones, the idea being that a backup application (e.g. rsnapshot or bacula) 
# fetches the latest local backups at regular intervals and no local versioning 
# is thus necessary. It is recommended that these resources are created via the 
# $::dirsrv::backups hash parameter.
# 
# Note that this define depends on the 'localbackups' class as well as the 
# dirsrv::config::backup class.
#
# == Parameters
#
# [*status*]
#   Status of the backup job. Either 'present' or 'absent'. Defaults to 
#   'present'.
# [*serveridentifier*]
#   Identifier for the Directory Server instance.
# [*suffix*]
#   The suffix of the LDAP directory to backup. The value is automatically 
#   quoted and can have spaces in it. For example 'dc=domain,dc=com'.
# [*rootdn*]
#   Root DN (i.e. "Directory Manager") for the Directory Server.
# [*output_dir*]
#   The directory where to output the files. Defaults to 
#   '/var/backups/local/dirsrv'.
# [*hour*]
#   Hour(s) when dirsrv gets run. Defaults to 01.
# [*minute*]
#   Minute(s) when dirsrv gets run. Defaults to 05.
# [*weekday*]
#   Weekday(s) when dirsrv gets run. Defaults to * (all weekdays).
# [*email*]
#   Email address where notifications are sent. Defaults to top-scope variable
#   $::servermonitor.
#
# 
define dirsrv::backup
(
    $status = 'present',
    $serveridentifier,
    $suffix,
    $rootdn,
    $output_dir = '/var/backups/local/dirsrv',
    $hour = '01',
    $minute = '05',
    $weekday = '*',
    $email = $::servermonitor
)
{

    include dirsrv::params

    $cron_command = "db2ldif-online -D \"${rootdn}\" -j \"${::dirsrv::params::config_dir}/manager-pass\" -Z ${serveridentifier} -a \"${output_dir}/${serveridentifier}.ldif\" -s \"${suffix}\" > /dev/null"

    cron { "dirsrv-backup-${serveridentifier}-cron":
        ensure => $status,
        command => $cron_command,
        user => root,
        hour => $hour,
        minute => $minute,
        weekday => $weekday,
        environment => [ 'PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin', "MAILTO=${email}" ],
        require => Class['dirsrv::config::backup'],
    }
}
