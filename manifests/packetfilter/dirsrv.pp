#
# == Class: dirsrv::packetfilter::dirsrv
#
# Limits access to ldap based on IP-address/range
#
class dirsrv::packetfilter::dirsrv
(
    $allow_ipv4_address,
    $allow_ipv6_address,
    $allow_ports

) inherits dirsrv::params
{

    $source_v4 = $allow_ipv4_address ? {
        'any' => undef,
        default => $allow_ipv4_address,
    }

    $source_v6 = $allow_ipv6_address ? {
        'any' => undef,
        default => $allow_ipv6_address,
    }

    # IPv4 rules
    @firewall { '013 ipv4 accept ldap port':
        provider => 'iptables',
        chain    => 'INPUT',
        proto    => 'tcp',
        source   => $source_v4,
        dport    => $allow_ports,
        action   => 'accept',
        tag      => 'default',
    }

    # IPv6 rules
    @firewall { '013 ipv6 accept ldap port':
        provider => 'ip6tables',
        chain    => 'INPUT',
        proto    => 'tcp',
        dport    => $allow_ports,
        source   => $source_v6,
        action   => 'accept',
        tag      => 'default',
    }
}
