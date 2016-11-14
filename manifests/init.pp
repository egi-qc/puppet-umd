class umd::repo::verification {
    $verification_repofile = hiera("umd::repo::verification::repofile")

    if $verification_repofile {
        info("UMD verification repository defined: $verification_repofile")

        if $::osfamily in ["Debian"] {
            $repo_sources_dir = "/etc/apt/sources.list.d/"
            apt::key {
                "wtf":
                    id => "FD7011F31EBF9470B82FAFCDE2E992EB352D3E14",
                    source => "http://repository.egi.eu/sw/production/umd/UMD-DEB-PGP-KEY",
            }
        }
        elsif $::osfamily in ["RedHat", "CentOS"] {
            $repo_sources_dir = "/etc/yum.repos.d/"
        }
        info("Repository source directory: $repo_sources_dir")

        umd::repo::download {
            $verification_repofile:
                target => $repo_sources_dir,
        }
    }
    else {
        notice("UMD verification repository not defined!")
    }
}

define umd::repo::download ($target) {
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
