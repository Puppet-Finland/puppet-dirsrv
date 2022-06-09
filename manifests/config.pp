#
# == Class: dirsrv::config
#
# Manage base configuration of dirsrv. Currently post-install configuration 
# support is very limited/non-existent.
#
class dirsrv::config
(
    String  $full_machine_name,
    String  $serveridentifier,
    Integer $ldap_port,
    String  $suffix,
    String  $rootdn,
    String  $rootdn_pwd,
    String  $config_directory_ldap_url,
    String  $config_directory_admin_id,
    String  $config_directory_admin_pwd,
    Enum['on','off','rootdse'] $allow_anonymous_access,
    Boolean $self_sign_cert,
    Integer $self_sign_cert_valid_months,

) inherits dirsrv::params
{
    $silent_install_inf = "${::dirsrv::params::config_dir}/silent-install.inf"

    $self_sign_cert_str = $self_sign_cert ? {
      true    => 'True',
      false   => 'False',
    }

    $silent_install_inf_params = {'full_machine_name'           => $full_machine_name,
                                  'serveridentifier'            => $serveridentifier,
                                  'ldap_port'                   => $ldap_port,
                                  'rootdn_pwd'                  => $rootdn_pwd,
                                  'self_sign_cert'              => $self_sign_cert_str,
                                  'self_sign_cert_valid_months' => $self_sign_cert_valid_months, }

    # Copy over the inf file that drives silent installs
    file { 'dirsrv-silent-install.inf':
        ensure  => present,
        name    => $silent_install_inf,
        content => epp('dirsrv/silent-install.inf.epp', $silent_install_inf_params),
        owner   => 'root',
        group   => 'root',
        mode    => '0600',
        require => Class['dirsrv::install'],
    }

    # Run the silent install
    exec { 'dirsrv-dscreate':
        command => "${::dirsrv::params::dscreate} from-file ${silent_install_inf}",
        creates => "${::dirsrv::params::config_dir}/slapd-${serveridentifier}",
        path    => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        require => File['dirsrv-silent-install.inf'],
    }

    # This variable is defined here to avoid complaints from puppet-lint
    $attributes = { nsslapd-allow-anonymous-access => $allow_anonymous_access }

    # Configure anonymous access
    ldap_entry { 'cn=config':
        ensure     => present,
        host       => 'localhost',
        port       => $ldap_port,
        username   => $rootdn,
        password   => $rootdn_pwd,
        ssl        => false,
        attributes => $attributes,
        require    => Exec['dirsrv-dscreate'],
        notify     => Class['dirsrv::service'],
    }

    class { '::dirsrv::config::backup':
        rootdn_pwd => $rootdn_pwd,
    }
}
