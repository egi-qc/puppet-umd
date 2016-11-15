class umd (
        $release,
        $openstack_release = undef
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
                ["epel-release", "yum-priorities"]:
                    ensure => latest,
            }
        }
        
        if $::operatingsystem == "CentOS" and $::operatingsystemmajrelease == "7" {
            package {
                "${umd::params::release[$release][centos7]}":
                    ensure => installed
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
                "${umd::params::release[$release][sl6]}":
                    ensure => installed
            }
        }
        elsif $::operatingsystem == "Scientific" and $::operatingsystemmajrelease == "5" {
            package {
                "${umd::params::release[$release][sl5]}":
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
            fail("Operating system ${::operatingsystem} (release: ${::operatingsystemrelease} not supported!")
        }
}

class umd::verification {
    $verification_repofile = hiera("umd::verification::repofile")
    info("UMD verification repository defined: $verification_repofile")

    if $verification_repofile {
        umd::download {
            $verification_repofile:
                target => $umd::params::repo_sources_dir,
        }
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
