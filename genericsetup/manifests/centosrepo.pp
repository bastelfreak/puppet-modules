# install the following repos and no others:
# epel				- for many things
# puppetlabs 	- just for puppet
# elrepo			-	for kernel-lt
# todo: list all centos default repos, remove unnecessary repos
 
class genericsetup::centosrepo {
	class { 'yum':
  	extrarepo => [ 'epel' , 'puppetlabs', 'elrepo' ],
	}
}
