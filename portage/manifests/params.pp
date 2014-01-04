# = Class: portage::params
#
# Contains default values for portage.
#
# == Example
#
# This class does not need to be directly included.
#
class portage::params {
  $make_conf              = '/etc/portage/make.conf'
  $portage_ensure         = undef
  $portage_keywords       = undef
  $portage_use            = undef
  $eix_ensure             = undef
  $eix_keywords           = undef
  $eix_use                = undef
  $layman_ensure          = undef
  $layman_keywords        = undef
  $layman_use             = undef
  $layman_make_conf       = '/var/lib/layman/make.conf'
  $webapp_config_ensure   = undef
  $webapp_config_keywords = undef
  $webapp_config_use      = undef
  $eselect_ensure         = undef
  $eselect_keywords       = undef
  $eselect_use            = undef
}
