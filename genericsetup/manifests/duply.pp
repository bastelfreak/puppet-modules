# todo: generate gpg key, duply config, set cron, user/password for backup
class genericsetup::duply {
	case $::operatingsystem{
		'Debian':{
			package{['duply', 'python-paramiko']:
				ensure => present,
			}
		}
		'Gentoo':{
			portage::package{['dev-python/paramiko']:}
		}
	}
	
}
