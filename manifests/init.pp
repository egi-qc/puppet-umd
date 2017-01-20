class umd (
        $distribution          = $umd::params::distribution,
        $release               = $umd::params::release,
        $verification_repofile = $umd::params::verification_repofile,
    ) inherits umd::params {
        if $distribution == "cmd" {
            class {
                "umd::distro::cmd":
                    release           => $release,
            }
            include umd::verification::repo
        }
        elsif $distribution == "umd" {
            class {
                "umd::distro::umd":
                    release => $release,
            }
            include umd::verification::repo
        }
        else {
            fail("UMD distribution '${distribution}' not known!")
        }
}

class umd::distro::cmd (
        $release,
    ) {
        if $release == 1 {
            $openstack_release = "mitaka"
        }
        else {
            fail("CMD release '${release}' not supported!")
        }

        if $::operatingsystem == "CentOS" and $::operatingsystemmajrelease == "7" {
            package {
                "centos-release-openstack-${openstack_release}":
                    ensure => installed
            }
        } 
        elsif $::operatingsystem == "Ubuntu" and $::operatingsystemrelease == "14.04" {
            if $openstack_release {
                package {
                    "software-properties-common":
                        ensure => installed,
                }
                exec {
                    "add cloud-archive:${openstack_release} repository":
                        command => "/usr/bin/add-apt-repository -y cloud-archive:${openstack_release}",
                        creates => "${umd::params::repo_sources_dir}/cloudarchive-${openstack_release}.list",
                        require => Package["software-properties-common"]
                }
            }
        }
        else {
            fail("Operating system ($::operatingsystem, $::operatingsystemrelease) not supported!")
        }
}

class umd::distro::umd (
        $release,
    ) {
        if $::osfamily in ["RedHat"] {
            package {
                "epel-release":
                    ensure => latest,
            }
        }
  
        if $::operatingsystem == "CentOS" and $::operatingsystemmajrelease == "7" {
            if $release == "4" {
                $pkg = "${umd::params::release_map[4][centos7]}"
            }
            elsif $release == "3" {
                $pkg = "${umd::params::release_map[3][centos7]}"
            }

            package {
                "yum-plugin-priorities":
                    ensure => installed
            }
            package {
                "umd-release":
                    provider => "rpm",
                    ensure   => installed,
                    source   => $pkg,
                    require  => Package["yum-plugin-priorities"]
            }
        }
        elsif $::operatingsystem == "Scientific" and $::operatingsystemmajrelease == "6" {
            if $release == "4" {
                $pkg = "${umd::params::release_map[4][sl6]}"
            }
            elsif $release == "3" {
                $pkg = "${umd::params::release_map[3][sl6]}"
            }

            package {
                "yum-priorities":
                    ensure => installed
            }
            package {
                "umd-release":
                    provider => "rpm",
                    ensure   => installed,
                    source   => "$pkg",
                    require  => Package["yum-priorities"]
            }
        }
        elsif $::operatingsystem == "Scientific" and $::operatingsystemmajrelease == "5" {
            package {
                "yum-priorities":
                    ensure => installed
            }
            package {
                "umd-release":
                    provider => "rpm",
                    ensure   => installed,
                    source   => "${umd::params::release_map[3][sl5]}",
                    require  => Package["yum-priorities"]
            }
        }
        else {
            fail("Operating system ${::operatingsystem} (release: ${::operatingsystemrelease} not supported!")
        }
}

class umd::verification::repo {
    if $umd::verification_repofile {
        umd::download {
            $umd::verification_repofile:
                target => $umd::params::repo_sources_dir,
        }
        info("UMD verification repository retrieved: $umd::verification_repofile")
    }
    else {
        notice("UMD verification repository not defined!")
    }
}

define umd::download ($target) {
    if ! defined(Package["wget"]) {
        package {
            "wget":
                ensure => installed
        }
    }

    $fname = basename($name)

    exec {
        "Retrieve $name":
            command => "/usr/bin/wget -q ${name} -P ${target}",
            creates => "${target}/${fname}",
            require => Package["wget"]
    }
}
