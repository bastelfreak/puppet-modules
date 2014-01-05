# todo: place ssh keys from aibo and bastelfreak on every host
class genericsetup::ssh {
	notify {'we are currently above the if statement': }
	if $::fqdn == 'mysql02.bastelfreak.org'{
	notify {'we have passd the statement': }
	exec { 'create-rsa-host-key':
		onlyif 	=> $::rsa_host_key_size != 8192,
		command => '/usr/bin/ssh-keygen -b 8192 -t rsa -f /etc/ssh/ssh_host_rsa_key -N ""',
	}
	augeas { 'sshd_config':
  	context => '/files/etc/ssh/sshd_config',
  	changes => [
	   	'set PermitRootLogin yes',
			'set HostKey /etc/ssh/ssh_host_rsa_key',
			'set ServerKeyBits 8192',
			'set AllowAgentForwarding no',
			'set X11Forwarding no',
			'set Protocol 2',
			'set PermitEmptyPasswords no',
			'set StrictModes yes',
			'set Ciphers aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr',
			'set MACs umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,hmac-ripemd160',
			'set KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1',
  	],
		onlyif => $::rsa_host_key_size == 8192,
		notify => Service['ssh'],
	}
	case $::operatingsystem {
		/(CentOS|Gentoo)/: { $service = 'sshd' }
		'Debian': { $service = 'ssh' }
	}
	service { 'ssh':
		name		=> $service,
		ensure	=> running,
#		enable	=> true,
	}
}else{
	notify{'your hostname is not allowed for ssh handling': }
}
}
