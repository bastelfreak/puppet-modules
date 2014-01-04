class portage::install {

  include portage

  if $portage::portage_ensure {
    portage::package { 'sys-apps/portage':
      ensure   => $portage::portage_ensure,
      keywords => $portage::portage_keywords,
      use      => $portage::portage_use,
      target   => 'portage',
    }
  }

  if $portage::eix_ensure {
    portage::package { 'app-portage/eix':
      ensure   => $portage::eix_ensure,
      keywords => $portage::eix_keywords,
      use      => $portage::eix_use,
      target   => 'portage',
    }
  }

  if ! $portage::layman_ensure or $portage::layman_ensure == 'absent' {
    $layman_makeconf_ensure = 'absent'
  } else {
    $layman_makeconf_ensure = 'present'

    portage::package { 'app-portage/layman':
      ensure   => $portage::layman_ensure,
      keywords => $portage::layman_keywords,
      use      => $portage::layman_use,
      target   => 'portage',
      notify   => Portage::Makeconf["source ${portage::layman_make_conf}"],
    }
  }

  portage::makeconf { "source ${portage::layman_make_conf}":
    ensure => $layman_makeconf_ensure
  }

  if $portage::webapp_config_ensure {
    portage::package { 'app-admin/webapp-config':
      ensure   => $portage::webapp_config_ensure,
      keywords => $portage::webapp_config_keywords,
      use      => $portage::webapp_config_use,
      target   => 'portage',
    }
  }

  if $portage::eselect_ensure {
    portage::package { 'app-admin/eselect':
      ensure   => $portage::eselect_ensure,
      keywords => $portage::eselect_keywords,
      use      => $portage::eselect_use,
      target   => 'portage',
    }
  }

}
