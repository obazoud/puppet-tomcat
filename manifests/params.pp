class tomcat::params {

  $default_source_release = "6.0.26"

  $instance_basedir = $tomcat_instance_basedir ? {
    ""      => "/srv/tomcat",
    default => $tomcat_instance_basedir,
  }

  if $tomcat_mirror {
    $mirror = $tomcat_mirror
  } else {
    $mirror = "http://archive.apache.org/dist/tomcat/"
  }

  if defined(Class["Tomcat::source"]) {
    $type = "source"
    if ( ! $tomcat_version ) {
      $maj_version = "6"
      $version = $default_source_release
    } else {
      $version = $tomcat_version
      if versioncmp($tomcat_version, '6.0.0') >= 0 {
        $maj_version = "6"
      } else {
          fail "only versions >= 6.0 are supported !"
      }
    }
  } else {
    fail "only Tomcat::source is supported !"
  }

  if $tomcat_debug {
    notify{"type=${type},maj_version=${maj_version},version=${version}":}
  }

  $home_basedir = $tomcat_home_basedir ? {
    ""      => "/opt",
    default => $tomcat_home_basedir,
  }

  $home_tomcat_basedir = "${home_basedir}/apache-tomcat-${tomcat::params::version}"
  $home_tomcat_link = "${home_basedir}/apache-tomcat"

}
