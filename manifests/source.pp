# This defined type allows for the addition of custom sources
# to the chocolatey.config.

define choco_app::source (
  $id = $name,
  $url,
  disabled = 'false',
) inherits choco_app {

  # This defined type simply wraps a concat fragment that will be
  # added to the middle of the chocolatey.config file, between
  # the <source> tags.
  concat::fragment { "chocolatey source ${id}":
    ensure => present,
    target => 'chocolatey.config',
    order => '50',
    content => template('choco_app/chocolatey.config.source.erb'),
  }

}
