# setup epel/elrepo before class packages
class genericsetup {
	case $::operatingsystem{
		'centOS': { include genericsetup::centosrepo }
		'Debian': { include genericsetup::debianrepo }
	}
	include genericsetup::basesystem
	include genericsetup::facts
	include genericsetup::packages
	include genericsetup::ssh
	include genericsetup::duply
	include genericsetup::zeyple
	class { '::ntp':
  	servers  => [ 'ntp1.hetzner.de', 'ntp2.hetzner.com', 'ntp3.hetzner.net' ],
  	restrict => ['127.0.0.1', '::1'],
	}
}
