class umd (
        $release               = $umd::params::release,
        $verification_repofile = $umd::params::verification_repofile,
        $openstack_release     = $umd::params::openstack_release,
    ) inherits umd::params {
        class {
            "umd::release":
                release => $release,
                openstack_release => $openstack_release,
        }
        include umd::verification
}

class umd::release (
        $release,
        $openstack_release = undef
    ) {
        if ! ($openstack_release in ["mitaka"]) {
            fail("OpenStack release ${openstack_release} not supported!")
        }

        if $::osfamily in ["RedHat"] {
            package {
                "epel-release":
                    ensure => latest,
            }
        }
        
        if $::operatingsystem == "CentOS" and $::operatingsystemmajrelease == "7" {
            package {
                "yum-plugin-priorities":
                    ensure => installed
            }
            package {
                "umd-release":
                    provider => "rpm",
                    ensure   => installed,
                    source   => "${umd::params::release_map[$release][centos7]}",
                    require  => Package["yum-plugin-priorities"]
            }
            if $openstack_release {
                package {
                    "centos-release-openstack-${openstack_release}":
                        ensure => installed
                }
            }
        }
        elsif $::operatingsystem == "Scientific" and $::operatingsystemmajrelease == "6" {
            package {
                "yum-priorities":
                    ensure => installed
            }
            package {
                "umd-release":
                    provider => "rpm",
                    ensure   => installed,
                    source   => "${umd::params::release_map[$release][sl6]}",
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
                    source   => "${umd::params::release_map[$release][sl5]}",
                    require  => Package["yum-priorities"]
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
            fail("Operating system ${::operatingsystem} (release: ${::operatingsystemrelease} not supported!")
        }
}

class umd::verification {
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
    package {
        "wget":
            ensure => installed
    }

    $fname = basename($name)

    exec {
        "Retrieve $name":
            command => "/usr/bin/wget -q ${name} -P ${target}",
            creates => "${target}/${fname}",
            require => Package["wget"]
    }
}
