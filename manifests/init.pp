class choco_app (
  $contains_legacy_packages   = 'true',
  $execution_timeout          = '2700',
  $checksum_files             = 'true',
  $autouninstaller            = 'false',
  $allow_global_confirmation  = 'false',

  $include_chocolatey_org_src = true,
) {

  File { source_permissions => ignore, }

  # INSTALL:
  #
  # Use the powershell method from https://chocolatey.org/ to install Choco.
  exec { 'install-choco':
    command  => 'iex ((new-object net.webclient).DownloadString("https://chocolatey.org/install.ps1")) >$null 2>&1',
    provider => 'powershell',
    creates  => 'C:\ProgramData\chocolatey\choco.exe',
  }

  # CONFIGURE:
  #
  # Manage the chocolatey.config file as an assembly of concat::fragments.
  concat { 'chocolatey.config':
    ensure => present,
    path   => 'C:\ProgramData\Chocolatey\config\chocolatey.config',
    require => Exec['install-choco'],
  }
  # Throw in the parts of the chocolatey.config the go before <sources>
  concat::fragment { 'chocolatey.config top':
    ensure => present,
    target => 'chocolatey.config',
    order => '01',
    content => regsubst(template('choco_app/chocolatey.config.top.erb'), '\n', "\r\n", 'EMG'),
    require => Exec['install-choco'],
  }
  # Add a source (unless disabled) that aims at the main chocolatey.org source.
  if $include_chocolatey_org_src {
    choco_app::source { 'chocolatey':
      source_id => 'chocolatey',
      url       => 'https://chocolatey.org/api/v2/',
      disabled  => 'false',
      order     => '30',
    }
  }
  # Add parts that go in the chocolatey.config beneath the <sources> section.
  concat::fragment { 'chocolatey.config bottom':
    ensure  => present,
    target  => 'chocolatey.config',
    order   => '99',
    content => regsubst(template('choco_app/chocolatey.config.bottom.erb'), '\n', "\r\n", 'EMG'),
    require => Exec['install-choco'],
  }

}
