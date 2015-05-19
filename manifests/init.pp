class choco_app (
  $contains_legacy_packages  = 'true',
  $execution_timeout         = '2700',

  $checksum_files            = 'true',
  $autouninstaller           = 'false',
  $allow_global_confirmation = 'false',

) {

  # Use an exec of powershell to download and install Chocolatey.
  exec { 'install chocolatey':
    command  => 'iex ((new-object net.webclient).DownloadString("https://chocolatey.org/install.ps1")) >$null 2>&1',
    provider => 'powershell',
    creates  => 'C:\ProgramData\chocolatey\choco.exe',
  }

  # Manage the chocolatey.config file by assembling from concat
  # fragments.  This makes it possible to include additional
  # sources, by declaring choco_app::source resources.
  concat { 'chocolatey.config':
    ensure => present,
  }

  concat::fragment { 'chocolatey.config top':
    ensure => present,
    target => 'chocolatey.config',
    order => '01',
    content => template('choco_app/chocolatey.config.top.erb'),
  }

  choco_app::source { 'chocolatey':
    source_id => 'chocolatey',
    url       => 'https://chocolatey.org/api/v2/',
    disabled  => 'false',
  }

  concat::fragment { 'chocolatey.config.bottom':
    ensure  => present,
    target  => 'chocolatey.config',
    order   => '99',
    content => template('choco_app/chocolatey.config.bottom.erb')
  }

}
