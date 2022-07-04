#
# @summary
#   Enable dirsrv service
#
# @param serveridentifier
#
class dirsrv::service (
  String $serveridentifier

) inherits dirsrv::params {
  $service_name = "${dirsrv::params::dir_service_name}@${serveridentifier}"

  service { 'dirsrv-dirsrv':
    name    => $service_name,
    enable  => true,
    require => Class['dirsrv::install'],
  }
}
