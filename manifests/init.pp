# @summary this class installs and configures 389 Directory Server.
#
# @param manage
#   Whether to manage Directory Server with Puppet or not. Valid values are 
#   true (default) and false.
# @param manage_config
#   Whether or not to manage Directory Server _configuration_ with Puppet. Valid 
#   values are true and false (default).
# @param manage_epel
#   Manage EPEL using this module. Valid values are true (default) and false.
# @param full_machine_name
#   Fully-qualified name for this host, or for the load balancer in front of
#   this host.
# @param serveridentifier
#   Identifier for the Directory Server instance. Defaults to $::hostname. Note 
#   that the identifier "can contain only alphanumeric characters and the 
#   following: #%:@_-"
# @param ldap_port
#   Directory Server (LDAP) port. Defaults to 389.
# @param suffix
#   Directory tree suffix. For example "dc=domain,dc=com". No default value.
# @param rootdn
#   Root DN (i.e. "Directory Manager") for the Directory Server. Defaults to 
#   'cn=Directory Manager'.
# @param rootdn_pwd
#   Password for the Root DN user.
# @param allow_anonymous_access
#   Level of anonymous access to allow. Valid values 'on', 'off' and 'rootdse'. 
#   Defaults to 'rootdse'.
# @param self_sign_cert
#   Whether to create a self-signed cert for the directory server
# @param self_sign_cert_valid_months
#   Validity of the self-signed cert (if any)
# @param create_suffix_entry
#   Whether to create a generic root node entry fot the default suffix in the
#   database.
# @param sample_entries
#   Whether to add sample entries to the database. Mainly for use with Vagrant.
# @param monitor_email
#   Where (backup) cronjobs should send email
#
class dirsrv (
  String                  $suffix,
  String                  $rootdn_pwd,
  String                  $full_machine_name = $facts['networking']['fqdn'],
  Boolean                 $manage = true,
  Boolean                 $manage_config = false,
  Boolean                 $manage_epel = true,
  String                  $serveridentifier = $facts['networking']['hostname'],
  Boolean                 $self_sign_cert = false,
  Integer                 $self_sign_cert_valid_months = 24,
  Boolean                 $create_suffix_entry = false,
  Boolean                 $sample_entries = false,
  Integer[1,65535]        $ldap_port = 389,
  String                  $rootdn = 'cn=Directory Manager',
  String                  $allow_anonymous_access = 'rootdse',
  Optional[String]        $monitor_email = undef,

) inherits dirsrv::params {
  if $manage {
    class { 'dirsrv::install':
      manage_epel => $manage_epel,
    }

    if $manage_config {
      class { 'dirsrv::config':
        full_machine_name           => $full_machine_name,
        serveridentifier            => $serveridentifier,
        ldap_port                   => $ldap_port,
        suffix                      => $suffix,
        rootdn                      => $rootdn,
        rootdn_pwd                  => $rootdn_pwd,
        allow_anonymous_access      => $allow_anonymous_access,
        self_sign_cert              => $self_sign_cert,
        self_sign_cert_valid_months => $self_sign_cert_valid_months,
        create_suffix_entry         => $create_suffix_entry,
        sample_entries              => $sample_entries,
      }
    }

    class { 'dirsrv::service':
      serveridentifier => $serveridentifier,
    }
  }
}
