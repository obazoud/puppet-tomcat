/*

== Class: tomcat::source

Installs tomcat 5.5.X or 6.0.X using the compressed archive from your favorite tomcat
mirror. Files from the archive will be installed in /opt/apache-tomcat/.

Class variables:
- *$log4j_conffile*: see tomcat

Requires:
- java to be previously installed
- common::archive definition (from puppet camptocamp/common module)
- Package["curl"]

Tested on:
- RHEL 5,6
- Debian Lenny/Squeeze
- Ubuntu Lucid

Usage:
  $tomcat_version = "6.0.18"
  include tomcat::source

*/
class tomcat::source inherits tomcat::base {

  include tomcat::params

  $tomcat_home = "/opt/apache-tomcat-${tomcat::params::version}"

  $baseurl = $tomcat::params::maj_version ? {
    "6"   => "${tomcat::params::mirror}/tomcat-6/v${tomcat::params::version}/bin",
  }
  
  $tomcaturl = "${baseurl}/apache-tomcat-${tomcat::params::version}.tar.gz"

  common::archive{ "apache-tomcat-${tomcat::params::version}":
    url         => $tomcaturl,
    digest_url  => "${tomcaturl}.md5",
    digest_type => "md5",
    target      => "/opt",
  }

  file {"/opt/apache-tomcat":
    ensure  => link,
    target  => $tomcat_home,
    require => Common::Archive["apache-tomcat-${tomcat::params::version}"],
  }

  file { $tomcat_home:
    ensure  => directory,
    require => Common::Archive["apache-tomcat-${tomcat::params::version}"],
  }

}
