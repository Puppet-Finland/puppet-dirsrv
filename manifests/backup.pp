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
# [*ensure*]
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
# [*protocol*]
#   Protocol with which to connect to the Directory Server. Valid values are 
#   'STARTTLS', 'LDAPS', 'LDAPI', and 'LDAP'. Defaults to 'LDAP'.
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
    String                                                              $serveridentifier,
    String                                                              $suffix,
    String                                                              $rootdn,
    Enum['present','absent']                                            $ensure = 'present',
    String                                                              $output_dir = '/var/backups/local/dirsrv',
    Enum['STARTTLS','LDAPS','LDAPI','LDAP']                             $protocol = 'LDAP',
    Variant[Array[String], Array[Integer[0-23]], String, Integer[0-23]] $hour = '01',
    Variant[Array[String], Array[Integer[0-59]], String, Integer[0-59]] $minute = '05',
    Variant[Array[String], Array[Integer[0-7]],  String, Integer[0-7]]  $weekday = '*',
    String                                                              $email = $::servermonitor
)
{

    include ::dirsrv::params

    $cron_command = "db2ldif.pl -D \"${rootdn}\" -j \"${::dirsrv::params::config_dir}/manager-pass\" -P ${protocol} -Z ${serveridentifier} -n userRoot -a \"${output_dir}/${serveridentifier}.ldif\" > /dev/null" # lint:ignore:140chars

    cron { "dirsrv-backup-${serveridentifier}-cron":
        ensure      => $ensure,
        command     => $cron_command,
        user        => $::os::params::adminuser,
        hour        => $hour,
        minute      => $minute,
        weekday     => $weekday,
        environment => [ 'PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin', "MAILTO=${email}" ],
        require     => Class['dirsrv::config::backup'],
    }
}
