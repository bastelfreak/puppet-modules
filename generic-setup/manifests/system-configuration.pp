# this class should build gentoos make.conf
class generic-setup::system-configuration {
	case $::operatingsystem{
		'gentoo':{
			include portage
			portage::makeconf{'CFLAGS':
				content => '-march=bdver1 -O2 -pipe',
				ensure => present,
			}
			portage::makeconf{'CXXFLAGS':
				content => '${CFLAGS}',
				ensure => present,
			}
			portage::makeconf{'CHOST':
				content => 'x86_64-pc-linux-gnu',
				ensure => present,
			}
			portage::makeconf{'USE':
				content => ['bindist', 'mmx', 'sse', 'sse2', 'ipv6', 'linguas_de', 'idn', 'vim-syntax', 'bash-completion'],
				ensure => present,
			}
			$makeopts = $::processorcount + 1
			portage::makeconf{'MAKEOPTS':
				content => $makeopts,
				ensure => present,
			}
			portage::makeconf{'SYNC':
				content => 'rsync://rsync12.de.gentoo.org/gentoo-portage',
				ensure => present,
			}
			portage::makeconf{'PORTDIR':
				content => '/usr/portage',
				ensure => present,
			}
		}
	}
}
