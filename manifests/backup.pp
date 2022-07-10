#
# @summary
#   Back up all 389 Directory Server databases using "dsconf backup create".
#
# @param ensure
#   Status of the backup job. Either 'present' or 'absent'.
# @param ldap_url
#   LDAP URL to connect to. 
# @param bind_dn
#   LDAP user to authenticate as.
# @param instance
#   The systemd service instance. For example in case of systemd service
#   dirsrv@example this parameter should be set to 'example'.
# @param bind_password
#   Password for the LDAP user
# @param hour
#   Hour(s) when dirsrv gets run.
# @param minute
#   Minute(s) when dirsrv gets run.
# @param weekday
#   Weekday(s) when dirsrv gets run.
# @param email
#   Email address where notifications from cron are sent.
#
define dirsrv::backup (
  String                                                              $instance,
  String                                                              $bind_password,
  String                                                              $ldap_url = 'ldap://localhost',
  Enum['present','absent']                                            $ensure = 'present',
  String                                                              $email = 'root@localhost',
  String                                                              $bind_dn = 'cn=Directory Manager',
  Variant[Array[String], Array[Integer[0-23]], String, Integer[0-23]] $hour = 1,
  Variant[Array[String], Array[Integer[0-59]], String, Integer[0-59]] $minute = 5,
  Variant[Array[String], Array[Integer[0-7]],  String, Integer[0-7]]  $weekday = '*',
) {
  include dirsrv::params

  $backup_script = "/etc/dirsrv/slapd-${instance}/backup.sh"

  file { "/etc/dirsrv/slapd-${instance}/backup-bind-pw":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => "${bind_password}\n",
  }

  $epp_params = { 'instance' => $instance,
    'ldap_url' => $ldap_url,
  'bind_dn'  => $bind_dn, }

  file { $backup_script:
    ensure  => 'file',
    content => epp('dirsrv/dirsrv-backup.sh.epp', $epp_params),
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
  }

  $cron_command = $backup_script

  cron { 'dirsrv-backup-cron':
    ensure      => $ensure,
    command     => $cron_command,
    user        => 'root',
    hour        => $hour,
    minute      => $minute,
    weekday     => $weekday,
    environment => ['PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin', "MAILTO=${email}"],
  }
}
