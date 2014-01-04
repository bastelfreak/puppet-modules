# = Class: portage
#
# Configure the Portage package management system
#
# == Parameters
#
# [*make_conf*]
#
# The path to make.conf.
#
# As of 2012-09-09 new systems will use /etc/portage/make.conf, but on older
# systems this can be /etc/make.conf.
#
# == Example
#
#     class { 'portage':
#       $make_conf = '/etc/portage/make.conf',
#     }
#
# == See Also
#
#  * emerge(1) http://dev.gentoo.org/~zmedico/portage/doc/man/emerge.1.html
#  * make.conf(5) http://dev.gentoo.org/~zmedico/portage/doc/man/make.conf.5.html

class portage (
  $make_conf              = $portage::params::make_conf,
  $portage_ensure         = $portage::params::portage_ensure,
  $portage_keywords       = $portage::params::portage_keywords,
  $portage_use            = $portage::params::portage_use,
  $portage_utils_ensure   = $portage::params::portage_utils_ensure,
  $portage_utils_keywords = $portage::params::portage_utils_keywords,
  $portage_utils_use      = $portage::params::portage_utils_use,
  $gentoolkit_ensure      = $portage::params::gentoolkit_ensure,
  $gentoolkit_keywords    = $portage::params::gentoolkit_keywords,
  $gentoolkit_use         = $portage::params::gentoolkit_use,
  $eix_ensure             = $portage::params::eix_ensure,
  $eix_keywords           = $portage::params::eix_keywords,
  $eix_use                = $portage::params::eix_use,
  $layman_ensure          = $portage::params::layman_ensure,
  $layman_keywords        = $portage::params::layman_keywords,
  $layman_use             = $portage::params::layman_use,
  $layman_make_conf       = $portage::params::layman_make_conf,
  $webapp_config_ensure   = $portage::params::webapp_config_ensure,
  $webapp_config_keywords = $portage::params::webapp_config_keywords,
  $webapp_config_use      = $portage::params::webapp_config_use,
  $eselect_ensure         = $portage::params::eselect_ensure,
  $eselect_keywords       = $portage::params::eselect_keywords,
  $eselect_use            = $portage::params::eselect_use,
) inherits portage::params {

  include concat::setup
  include portage::install

  file { [
    '/etc/portage/package.keywords',
    '/etc/portage/package.mask',
    '/etc/portage/package.unmask',
    '/etc/portage/package.use',
    '/etc/portage/postsync.d',
  ]:
    ensure => directory;
  }

  exec { 'changed_makeconf_use':
    command     => '/usr/bin/emerge --changed-use @world',
    refreshonly => true,
    timeout     => 43200,
  }

  concat { $make_conf:
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Exec['changed_makeconf_use'],
  }

  concat::fragment { 'makeconf_header':
    target  => $make_conf,
    content => template('portage/makeconf.header.conf.erb'),
    order   => 00,
  }

}
