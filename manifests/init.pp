class choco_app (

) {

  # Use an exec of powershell to download and install Chocolatey.
  exec { 'install chocolatey':
    command  => "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))",
    provider => 'powershell',
    creates  => 'C:\ProgramData\chocolatey\choco.exe',
  }

  # Stub: Manage the chocolatey configuration file
  # including sources.
  # Use a file resource, with content => template()


}
