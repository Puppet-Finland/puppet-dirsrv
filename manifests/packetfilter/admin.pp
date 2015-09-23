#
# == Class: dirsrv::packetfilter::admin
#
# Limits access to dirsrv Admin UI based on IP-address/range. Access to the 
# Directory Server is limited by the more general-purpose ldap::packetfilter 
# class.
#
class dirsrv::packetfilter::admin
(
    $allow_ipv4_address,
    $allow_ipv6_address,
    $port

) inherits dirsrv::params
{

    $source_v4 = $allow_ipv4_address ? {
        'any'   => undef,
        default => $allow_ipv4_address,
    }

    $source_v6 = $allow_ipv6_address ? {
        'any'   => undef,
        default => $allow_ipv6_address,
    }

    # IPv4 rules
    firewall { '013 ipv4 accept dirsrv admin port':
        provider => 'iptables',
        chain    => 'INPUT',
        proto    => 'tcp',
        dport    => $port,
        source   => $source_v4,
        action   => 'accept'
    }

    # IPv6 rules
    firewall { '013 ipv6 accept dirsrv admin port':
        provider => 'ip6tables',
        chain    => 'INPUT',
        proto    => 'tcp',
        dport    => $port,
        source   => $source_v6,
        action   => 'accept',
    }
}
