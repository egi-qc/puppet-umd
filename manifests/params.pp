class umd::params {
    $release_map = {
        4 => {
            centos7 => "http://repository.egi.eu/sw/production/umd/4/centos7/x86_64/updates/umd-release-4.1.2-1.el7.centos.noarch.rpm",
            sl6     => "http://repository.egi.eu/sw/production/umd/4/sl6/x86_64/updates/umd-release-4.0.0-1.el6.noarch.rpm"},
        3 => {
            sl5     => "http://repository.egi.eu/sw/production/umd/3/sl5/x86_64/updates/umd-release-3.0.1-1.el5.noarch.rpm",
            sl6     => "http://repository.egi.eu/sw/production/umd/3/sl6/x86_64/updates/umd-release-3.0.1-1.el6.noarch.rpm"},
    }

    if $::osfamily in ["Debian"] {
        $repo_sources_dir = "/etc/apt/sources.list.d/"
    }
    elsif $::osfamily in ["RedHat", "CentOS"] {
        $repo_sources_dir = "/etc/yum.repos.d/"
    }

    $release               = hiera("umd::release", 4)
    $verification_repofile = hiera("umd::verification_repofile", undef)
    $openstack_release     = hiera("umd::openstack_release", undef)
}
