# this class simply creates the directories needed for external facts and copy every fact-script that we have
class genericsetup::facts {
	# create dir for external facts
  file { "/etc/facter":
    ensure => "directory",
    group  => "root",
    owner  => "root",
  }
  file { "/etc/facter/facts.d":
    ensure => "directory",
    group  => "root",
    owner  => "root",
  }
	file { "/etc/facter/facts.d/get_rsa_hostkey_size":
    source  => "puppet:///modules/genericsetup/get_rsa_hostkey_size",
    group   => "root",
    owner   => "root",
  }
}
