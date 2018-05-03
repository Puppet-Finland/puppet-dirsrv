# dirsrv

A Puppet module for managing 389 Directory Server. Includes support for monit and
iptables/ip6tables configuration.

# Module usage

The simplest possible way to use this module is this:

    class { '::dirsrv':
      suffix                       => 'dc=example,dc=org',
      rootdn_pwd                   => 'secret',
      server_admin_pwd             => 'secret',
      config_directory_admin_pwd   => 'secret',
    }

See [dirsrv.pp](vagrant/dirsrv.pp) used by Vagrant for a more complete example. 
For further details have a look at the class documentation:

* [Class: dirsrv](manifests/init.pp)
* [Define: dirsrv::backup](manifests/backup.pp)
