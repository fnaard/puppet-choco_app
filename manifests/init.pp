class choco_app (
  $contains_legacy_packages   = 'true',
  $execution_timeout          = '2700',
  $checksum_files             = 'true',
  $autouninstaller            = 'false',
  $allow_global_confirmation  = 'false',

  $include_chocolatey_org_src = true,
) {

  # Use an exec of powershell to download and install Chocolatey.
  # This is exactly how the website  main page tells people to do it.
  exec { 'install-choco':
    command  => 'iex ((new-object net.webclient).DownloadString("https://chocolatey.org/install.ps1")) >$null 2>&1',
    provider => 'powershell',
    creates  => 'C:\ProgramData\chocolatey\choco.exe',
  }

  # Manage the chocolatey.config file by assembling from concat
  # fragments.  This makes it possible to include additional
  # sources, by declaring choco_app::source resources when desired.
  concat { 'chocolatey.config':
    ensure => present,
    path   => 'C:\ProgramData\Chocolatey\config\chocolatey.config',
    require => Exec['install-choco'],
  }

  concat::fragment { 'chocolatey.config top':
    ensure => present,
    target => 'chocolatey.config',
    order => '01',
    content => template('choco_app/chocolatey.config.top.erb'),
    require => Exec['install-choco'],
  }

  if $include_chocolatey_org_src {
    choco_app::source { 'chocolatey':
      source_id => 'chocolatey',
      url       => 'https://chocolatey.org/api/v2/',
      disabled  => 'false',
      order     => '30',
    }
  }

  concat::fragment { 'chocolatey.config.bottom':
    ensure  => present,
    target  => 'chocolatey.config',
    order   => '99',
    content => template('choco_app/chocolatey.config.bottom.erb'),
    require => Exec['install-choco'],
  }

}
