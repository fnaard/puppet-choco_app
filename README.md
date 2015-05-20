# choco_app

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup - The Basics](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - Parameters and Types](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module will install and configure the Chocolatey package manager and
its sources.

## Module Description

The main class uses the Powershell method from https://chocolatey.org/ to
install the software.  That places the binaries in the default location of
C:\ProgramData\chocolatey\bin, and updates the system's command path to include
that directory.

A defined type allows the addition of custom sources to the Chocolatey config.

## Setup

To simply install Chocolatey with all configuration defaults, and only the
main chocolatey.org source defined, just include the class.  This results in
the same set-up as if you'd gone to the chocolatey.org site and copied and
pasted the powershell snippet from there into a command prompt on the target
system.

```puppet
include choco_app
```

## Usage

To install Chocolatey and add extra sources to the list, simply include the
main class, and use a choco_app::source resource to add the extra source.
For instance:

```puppet
include choco_app
choco_app::source { 'extras':
  url => 'http://artifactory.here.local:8081/artifactory/api/nuget/extras',
}
```

If you would like to omit the main chocolatey.org source entirely from your
configuration -- perhaps local policy requires that you aim at an internal
mirror instead -- you might declare the class and sources like this:

```puppet
class { 'choco_app':
  include_chocolatey_org_src => false,
}
choco_app::source { 'mirror':
  url => 'http://artifactory.here.local:8081/artifactory/api/nuget/mirror',
}
choco_app::source { 'extras':
  url => 'http://artifactory.here.local:8081/artifactory/api/nuget/extras',
}
```

Multiple extra sources are allowed.  See the Reference section below if you
need to explicitly order the sources in the chocolatey.config file.

## Reference

### Class

choco_app: Installs and configures Chocolatey.

####`contains_legacy_packages`

The content of the <containsLegacyPackageInstalls> setting in the
chocolatey.config file.  Valid options: true or false.  Default: 'true'.

####`execution_timeout`

The content of the <commandExecutionTimeoutSeconds> setting in the
chocolatey.config file.  Valid options: integer.  Default: '2700'.

####`checksum_files`

The content of the <checksumFiles> setting in the chocolatey.config file.
Valid options: true or false.  Default: 'true'.

####`autouninstaller`

The content of the <autoUninstaller> setting in the chocolatey.config file.
Valid options: true or false.  Default: 'false'.

####`allow_global_confirmation`

The content of the <allowGlobalConfirmation> setting in the chocolatey.config
file.  Valid options: true or false.  Default: 'false'.

####`include_chocolatey_org_src`

Whether or not to include the main chocolatey.org source when building the
chocolatey.config file.  Useful if you're behind a firewall, or if local
policy does not allow the use of sources on the Internet.  Valid options:
true or false.  Default: 'true'.

### Types

* choco_app::source: Inserts an additional <source /> in the chocolatey.config
file to make Chocolatey search additional repositories for packages.  See
also the class parameter `include_chocolatey_org_src` if you wish to omit the
main chocolatey.org repository itself from the config file.

####`source_id`

The string to supply as the "id" for this source in the chocolatey.config.
Valid options: string.  Default value: the resource $name.  (namevar)

####`url`

The string to supply as the "value" for this source in the chocolatey.config.
Valid options: string.  Default value: none.  (Required)

####`disabled`

The string to supply for the "disabled" attribute of this source.  Valid
options: true or false.  Default: 'false'

####`order`

This parameter controls the relative order in which this source will be
inserted in the chocolatey.config file.  The main chocolatey.org source
is set to an order of '30'.  Valid options: 02 - 99.  Default value: 50.

## Limitations

Chocolatey is only available for Windows systems.  Thus, this module is only
relevant on Windows.

## Development

This module has been designed to provide the bare minimum functionality to
install and configure Chocolatey.  The options that you can control in the
chocolatey.config file are just the ones that a default installation has.
There is nothing fancy here.

Fancy pull requests are heartily welcomed.

## Release Notes

* 0.1.0: Initial release.
