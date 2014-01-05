# install every package that doesn't need configuration (or at least just a simple one)

# todo: install pflogsumm only for mailserver
# todo: load modules for lm-sensors
# todo: we currently only support gentoo on physical hosts
# todo: munin-node config
# todo: remove ferm from autostart
# todo: create ferm config
class genericsetup::packages {
	$packages_for_centos_and_debian = [	'logwatch', 
		'git', 
		'htop', 
		'nload', 
		'sysstat', 
		'iftop', 
		'nmap', 
		'screen', 
		'fail2ban', 
		'postfix', 
		'tcpdump', 
		'mtr', 
		'bash-completion', 
		'ferm', 
		'iptraf', 
		'acpid', 
		'munin-node', 
		'bsd-mailx' ]
	case $::virtual {
		'physical': { 
			# https://docs.puppetlabs.com/puppet/3/reference/experiments_future.html#concatenation-and-append
			# https://projects.puppetlabs.com/issues/3300
			$packages_for_centos_and_debian_including_physical_hosts = [ $packages_for_centos_and_debian,
				'smartmontools', 
				'ethtool', 
				'pciutils', 
				'ethtool', 
				'lm-sensors' ]
			case $::processor0 {
				/Intel/: { $packages_for_centos_and_debian_including_physical_hosts_and_their_cpu = [ $packages_for_centos_and_debian_including_physical_hosts, 'intel-microcode' ] }
				/AMD/: { $packages_for_centos_and_debian_including_physical_hosts_and_their_cpu = [ $packages_for_centos_and_debian_including_physical_hosts, 'amd-microcode' ] }
			}
		}
		'kvm': {
			$packages_for_centos_and_debian_including_physical_hosts_and_their_cpu = $packages_for_centos_and_debian
		}
	}
	case $::operatingsystem {
		'Debian': {
			$packages_debian = [ 'augeas-tools', 'uptimed', 'vim' ]
			package { [ $packages_for_centos_and_debian_including_physical_hosts_and_their_cpu, $packages_debian ]:
				ensure => present,
			}
		}
		'CentOS': {
			$packages_centos = [ 'augeas', 'vim-minimal' ]
			package { [ $packages_for_centos_and_debian_including_physical_hosts_and_their_cpu, $packages_centos ]:
				ensure => present,
			}
		}
		'Gentoo':{
			include portage
			case $::virtual {
				'physical':{
					# list of packages that we need without any special use flags
					# we cloud use normal package() ressource but we don't want to mix/fuck up wit portage::package()
					portage::package { [ 'app-admin/puppet', 'sys-process/htop' ]: }
					# everything with just a 'static' flag, because we like small and portable binaries
					portage::package{ [ 'net-misc/openssh', 'sys-process/lsof', 'app-arch/tar', 'app-crypt/gnupg', 'net-misc/rsync', 'net-misc/wget' ]:
						use => 'static',
					}
					portage::package{ [ 'sys-fs/lvm2', 'app-arch/bzip2' ]:
						use => [ 'static', 'static-libs' ],	
					}
					portage::package{ [ 'sys-apps/lm_sensors', 'sys-apps/pciutils', 'sys-libs/zlib', 'dev-libs/openssl', 'app-admin/augeas' ]:
						use => 'static-libs',
					}
					portage::package{ 'app-emulation/libvirt':
						use => [ 'lvm', 'lxc', 'nfs', 'pcap', 'python', 'virt-network', 'sasl', 'iscsi' ],
					}
					portage::package{ 'app-emulation/qemu':
						use => [ 'sasl', 'python', 'tls', 'virtfs', 'xattr', 'static-user' ],
					}
					portage::package{ 'mail-mta/postfix':
						use => 'mbox',
					}
					portage::package{ 'sys-block/parted':
						use => [ 'static-libs', 'device-mapper' ],
					}
					portage::package{ 'net-analyzer/tcpdump':
						use => 'samba',
					}
					portage::package{ 'sys-apps/smartmontools':
						use => [ 'static', 'minimal' ],
					}
					portage::package{ 'app-admin/sysstat':
						use => 'lm_sensors',
					}
					portage::package{ 'net-dns/dnsmasq':
						use => [ 'dhcp-tools', 'conntrack' ],
					}
					portage::package{ 'net-analyzer/nmap':
						use => [ 'nmap-update', 'nping', 'ncat', 'ndiff' ],
					}
				}
			}
		}
	}
	file{ 'screen-config':
		path 		=> '/root/.screenrc',
		ensure 	=> present,
		source 	=> 'puppet:///modules/genericsetup/screenrc',
	}
	file{ 'vim-config':
		path 		=> '/root/.vimrc',
		ensure 	=> present,
		source 	=> 'puppet:///modules/genericsetup/vimrc',
	}
}
