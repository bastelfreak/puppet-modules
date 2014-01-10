# set $service
# create host key
# create root key
# sshd hardening
# check that ssh is running and on autostart
# remove dsa key

# todo: place ssh keys from aibo, debauer and bastelfreak on every host
class genericsetup::ssh {
	case $::operatingsystem {
		/(CentOS|Gentoo)/: { $service = 'sshd' }
		'Debian': { $service = 'ssh' }
	}
	exec { 'create-rsa-host-key':
		onlyif 	=> '/usr/bin/ssh-keygen -lf /etc/ssh/ssh_host_rsa_key | grep --quiet --invert-match "^8192"',
		command => 'rm /etc/ssh/ssh_host_rsa_key; /usr/bin/ssh-keygen -b 8192 -t rsa -f /etc/ssh/ssh_host_rsa_key -q -N ""',
	}
	exec { 'create-root-key':
		command	=> '/usr/bin/ssh-keygen -b 8192 -t rsa -f /root/.ssh/id_rsa -q -N ""',
		creates	=> '/root/.ssh/id_rsa',
	}
	augeas { 'sshd_config':
  	context => '/files/etc/ssh/sshd_config',
  	changes => [
			'set /files/etc/ssh/sshd_config/Port 22',
			'set /files/etc/ssh/sshd_config/RSAAuthentication yes',
			'set /files/etc/ssh/sshd_config/PasswordAuthentication yes',
	   	'set /files/etc/ssh/sshd_config/PermitRootLogin yes',
			'set /files/etc/ssh/sshd_config/HostKey /etc/ssh/ssh_host_rsa_key',
			'set /files/etc/ssh/sshd_config/AllowAgentForwarding no',
			'set /files/etc/ssh/sshd_config/X11Forwarding no',
			'set /files/etc/ssh/sshd_config/Protocol 2',
			'set /files/etc/ssh/sshd_config/PermitEmptyPasswords no',
			'set /files/etc/ssh/sshd_config/StrictModes yes',
			# something from this ciperlist is not supported on Debian Wheezy
			'set /files/etc/ssh/sshd_config/Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr',
			# augeas is currently failing here
			# 'set /files/etc/ssh/sshd_config/MACs umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160',
			# curve25519-sha256@libssh.org not supported on Debian Wheezy/Jessie
			# 'set /files/etc/ssh/sshd_config/KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1',
			'set /files/etc/ssh/sshd_config/KexAlgorithms diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1',
			'set /files/etc/ssh/sshd_config/HostKey /etc/ssh/ssh_host_rsa_key',
			# this will also remove the above line
			# 'rm /files/etc/ssh/sshd_config/HostKey /etc/ssh/ssh_host_dsa_key',
  	],
		#onlyif => '/usr/bin/ssh-keygen -lf /etc/ssh/ssh_host_rsa_key | grep --quiet --invert-match "^8192"',
		notify => Service['ssh'],
	}
	service { 'ssh':
		name		=> $service,
		ensure	=> running,
		enable	=> true,
	}
	file { 'dsa-pub-key':
		path 		=> '/etc/ssh/ssh_host_dsa_key.pub',
		ensure	=> absent,
		require	=> Augeas['sshd_config'],
		notify 	=> Service['ssh'],
	}
	file { 'dsa-priv-key':
		path 		=> '/etc/ssh/ssh_host_dsa_key',
		ensure 	=> absent,
		require => Augeas['sshd_config'],
		notify 	=> Service['ssh'],
	}
}
