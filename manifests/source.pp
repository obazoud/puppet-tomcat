/*

== Class: tomcat::source

Installs tomcat 6.0.X using the compressed archive from your favorite tomcat
mirror. Files from the archive will be installed in /opt/apache-tomcat/.

Class variables:

Requires:
- java to be previously installed
- common::archive definition (from puppet camptocamp/common module)
- Package["curl"]

Tested on:
- Ubuntu Server

Usage:
  $tomcat_version = "6.0.18"
  include tomcat::source

*/
class tomcat::source inherits tomcat::base {

  include tomcat::params

  $baseurl = $tomcat::params::maj_version ? {
    "6"   => "${tomcat::params::mirror}/tomcat-6/v${tomcat::params::version}/bin",
  }
  
  $tomcaturl = "${baseurl}/apache-tomcat-${tomcat::params::version}.tar.gz"

  common::archive{ "apache-tomcat-${tomcat::params::version}":
    url         => "${tomcaturl}",
    digest_url  => "${tomcaturl}.md5",
    digest_type => "md5",
    target      => "${tomcat::params::home_basedir}",
  }

  file { "${tomcat::params::home_tomcat_basedir}":
    ensure  => directory,
    require => Common::Archive["apache-tomcat-${tomcat::params::version}"],
  }

  file {"${tomcat::params::home_tomcat_link}":
    ensure  => link,
    target  => "${tomcat::params::home_tomcat_basedir}",
    require => Common::Archive["apache-tomcat-${tomcat::params::version}"],
  }

}
