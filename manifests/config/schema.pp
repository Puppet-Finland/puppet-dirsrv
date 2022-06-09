#
# == Define: dirsrv::config::schema
#
# Configure a schema for dirsrv
#
# [*modulename*]
#   Name of the module containing the monit template
# [*basename*]
#   Basename of the monit template file. Defaults to $modulename.
#
define dirsrv::config::schema (
  String $modulename,
  String $basename=$modulename
) {
  include dirsrv::params

  file { "${modulename}-${basename}.ldif":
    ensure  => file,
    name    => "${facts['dirsrv::params::config_dir']}/slapd-${facts['dirsrv::config::serveridentifier']}/schema/${basename}.ldif",
    content => template("${modulename}/${basename}.ldif.erb"),
    owner   => $dirsrv::params::suite_spot_user_id,
    group   => $dirsrv::params::suite_spot_group,
    mode    => '0600',
    require => Class['dirsrv::config'],
    notify  => Class['dirsrv::service'],
  }
}
