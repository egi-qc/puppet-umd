class umd inherits umd::params {
    include umd::release
    include umd::verification
}

class umd::release {
    if $::operatingsystem in ["RedHat"] {
        package {
            ["epel-release", "yum-priorities"]:
                ensure => latest,
    }

}

class umd::verification {
    $verification_repofile = hiera("umd::verification::repofile")
    info("UMD verification repository defined: $verification_repofile")

    if $verification_repofile {
        umd::download {
            $verification_repofile:
                target => $repo_sources_dir,
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
