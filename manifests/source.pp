# This defined type allows for the addition of custom sources
# to the chocolatey.config.

define choco_app::source (
  $source_id = $name,
  $url,
  $disabled  = 'false',
) {

  # This defined type simply wraps a concat fragment that will be
  # added to the middle of the chocolatey.config file, between
  # the <source> tags.
  concat::fragment { "chocolatey source ${source_id}":
    ensure => present,
    target => 'chocolatey.config',
    order => '50',
    content => template('choco_app/chocolatey.config.source.erb'),
    require => Exec['install-choco'],
  }

}
