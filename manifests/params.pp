class umd::params {
    $distribution          = hiera("umd::distribution", undef)
    $release               = hiera("umd::release", undef)
    $verification_repofile = hiera("umd::verification_repofile", undef)
    $igtf_repo             = hiera("umd::igtf_repo", true)
    $enable_testing_repo   = hiera("umd::enable_testing_repo", false)
    $enable_untested_repo  = hiera("umd::enable_untested_repo", false)

    $release_map = {
        umd => {
            4 => {
                centos7 => "http://repository.egi.eu/sw/production/umd/4/centos7/x86_64/updates/umd-release-4.1.3-1.el7.centos.noarch.rpm",
                centos6 => "http://repository.egi.eu/sw/production/umd/4/sl6/x86_64/updates/umd-release-4.1.3-1.el6.noarch.rpm",
                sl6     => "http://repository.egi.eu/sw/production/umd/4/sl6/x86_64/updates/umd-release-4.1.3-1.el6.noarch.rpm"},
            3 => {
                centos6 => "http://repository.egi.eu/sw/production/umd/3/sl6/x86_64/updates/umd-release-3.14.4-1.el6.noarch.rpm",
                sl6     => "http://repository.egi.eu/sw/production/umd/3/sl6/x86_64/updates/umd-release-3.14.4-1.el6.noarch.rpm",
                sl5     => "http://repository.egi.eu/sw/production/umd/3/sl5/x86_64/updates/umd-release-3.0.1-1.el5.noarch.rpm"},
            current => "4",
        },
        cmd-os => {
            1 => {
                centos7  => "http://repository.egi.eu/sw/production/cmd-os/1/centos7/x86_64/base/cmd-os-release-1.0.1-1.el7.centos.noarch.rpm",
                ubuntu16 => "http://repository.egi.eu/sw/production/cmd-os/1/ubuntu/dists/xenial-updates/main/binary-amd64/cmd-os-release_1.0.0-1_all.deb",
                ubuntu14 => "http://repository.egi.eu/sw/production/cmd-os/1/ubuntu/dists/trusty/main/binary-amd64/cmd-os-release-1.0.0_all.deb"},
            current => "1",
        },
        cmd-one => {
            1 => {
                centos7  => "http://repository.egi.eu/sw/production/cmd-one/1/centos7/x86_64/base/cmd-one-release-1.0.0-1.el7.centos.noarch.rpm",},
            current => "1",
        }
    }

    if $::osfamily in ["Debian"] {
        $repo_sources_dir = "/etc/apt/sources.list.d/"
    }
    elsif $::osfamily in ["RedHat", "CentOS"] {
        $repo_sources_dir = "/etc/yum.repos.d/"
    }
}
