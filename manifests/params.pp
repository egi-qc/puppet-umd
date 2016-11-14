class umd::params {
    if $::osfamily in ["Debian"] {
        $repo_sources_dir = "/etc/apt/sources.list.d/"
    }
    elsif $::osfamily in ["RedHat", "CentOS"] {
        $repo_sources_dir = "/etc/yum.repos.d/"
    }
}
