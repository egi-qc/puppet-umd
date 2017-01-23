class umd::igtf_repo::yum {
    yumrepo {
        "EGI-trustanchors":
            baseurl  => 'http://repository.egi.eu/sw/production/cas/1/current/',
            descr    => "EGI-trustanchors repo",
            gpgcheck => 0,
            enabled  => 1,
            protect  => 0,
    }
}

class umd::igtf_repo::apt {
    apt::source {
        "egi-igtf":
            location => "http://repository.egi.eu/sw/production/cas/1/current",
            release  => "egi-igtf",
            repos    => "core",
    }
}
