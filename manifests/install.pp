class passenger::install {

  package { 'passenger':
    ensure   => $passenger::package_ensure,
    name     => $passenger::package_name,
    provider => $passenger::package_provider,
  }

  if $passenger::package_dependencies {
    include $passenger::package_dependencies
  }

}
