# pin wheezy
# update sources.list with jessie
class genericsetup::debianrepo {
	file { 'apt-conf':
		path		=> '/etc/apt/apt.conf.d/90binwheezy',
		content	=> 'APT::Default-Release "wheezy";',
		notify  => Exec['update-repo'],
	}
	file { 'source-list':
		path 		=> '/etc/apt/sources.list',
		source	=> 'puppet:///modules/genericsetup/source-list-wheezy-jessie',
		require	=> File['apt-conf'],
		notify  => Exec['update-repo'],
	}
	file { 'hetzner-shit':
		path		=> '/etc/apt/apt.conf.d/99hetzner',
		ensure	=> absent,
		notify	=> Exec['update-repo'],
	}
	exec { 'update-repo':
		command			=> 'aptitude update',
		refreshonly	=> true,
	}
}
