# Class: passenger::params
#
# This class manages parameters for the Passenger module
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class passenger::params {
  $package_ensure         = '3.0.21'
  $passenger_version      = '3.0.21'
  $passenger_ruby         = '/usr/bin/ruby'
  $package_provider       = 'gem'
  $passenger_provider     = 'gem'
  $compile_passenger      = true
  $high_performance_mode  = true
  $max_pool_size          = 12
  $pool_idle_time         = 1500
  $stat_throttle_rate     = 120
  

  if versioncmp ($passenger_version, '4.0.0') > 0 {
    $builddir     = 'buildout'
  } else {
    $builddir     = 'ext'
  }

  case $::osfamily {
    'debian': {
      $package_name           = 'passenger'
      $passenger_package      = 'passenger'
      $gem_path               = '/var/lib/gems/1.8/gems'
      $gem_binary_path        = '/var/lib/gems/1.8/bin'
      $passenger_root         = "/var/lib/gems/1.8/gems/passenger-${passenger_version}"
      $mod_passenger_location = "/var/lib/gems/1.8/gems/passenger-${passenger_version}/${builddir}/apache2/mod_passenger.so"

      # Ubuntu does not have libopenssl-ruby - it's packaged in libruby
      if $::lsbdistid == 'Debian' and $::lsbmajdistrelease <= 5 {
        $package_dependencies   = [ 'libopenssl-ruby', 'libcurl4-openssl-dev' ]
      } else {
        $package_dependencies   = [ 'libruby', 'libcurl4-openssl-dev' ]
      }
    }
    'redhat': {
      case $::lsbmajdistrelease {
        '5'     : { $curl_package = 'curl-devel' }
        default : { $curl_package = 'libcurl-devel' }
      }
      $package_dependencies   = [ $curl_package, 'openssl-devel', 'zlib-devel' ]
      $package_name           = 'passenger'
      $passenger_package      = 'passenger'
      $gem_path               = '/usr/lib/ruby/gems/1.8/gems'
      $gem_binary_path        = '/usr/lib/ruby/gems/1.8/gems/bin'
      $passenger_root         = "/usr/lib/ruby/gems/1.8/gems/passenger-${passenger_version}"
      $mod_passenger_location = "/usr/lib/ruby/gems/1.8/gems/passenger-${passenger_version}/${builddir}/apache2/mod_passenger.so"
    }
    'darwin':{
      $package_name           = 'passenger'
      $passenger_package      = 'passenger'
      $gem_path               = '/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin'
      $gem_binary_path        = '/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin'
      $passenger_root         = "/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/passenger-${passenger_version}"
      $mod_passenger_location = "/System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/passenger-${passenger_version}/${builddir}/apache2/mod_passenger.so"
    }
    default: {
      fail("Operating system ${::operatingsystem} is not supported with the Passenger module")
    }
  }
}

class libopenssl-ruby {
  if ! defined(Package['libopenssl-devel']) {
    package {'libopenssl-devel': ensure=>installed}
  }
} 

class libcurl4-openssl-dev {
  if ! defined(Package['libcurl4-openssl-dev']) {
    package {'libcurl4-openssl-dev': ensure=>installed}
  }
} 

class libruby {
  if ! defined(Package['libruby']) {
    package {'libruby': ensure=>installed}
  }
} 
     
class libcurl-devel {
  if ! defined(Package['libcurl-devel']) {
    package {'libcurl-devel': ensure=>installed}
  }
} 

class openssl-devel {
  if ! defined(Package['openssl-devel']) {
    package {'openssl-devel': ensure=>installed}
  }
} 

class zlib-devel {
  if ! defined(Package['zlib-devel']) {
    package {'zlib-devel': ensure=>installed}
  }
} 

