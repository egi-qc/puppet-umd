class umd::igtf_repo::yum {
    yumrepo {
        "EGI-trustanchors":
            baseurl  => 'http://repository.egi.eu/sw/production/cas/1/current/',
            descr    => "EGI-trustanchors repo",
            gpgcheck => 1,
            gpgkey   => "http://repository.egi.eu/sw/production/cas/1/GPG-KEY-EUGridPMA-RPM-3",
            enabled  => 1,
            protect  => 0,
    }
}

class umd::igtf_repo::apt {
    apt::key {
        "EUGridPMA":
            source => "https://dist.eugridpma.info/distribution/igtf/current/GPG-KEY-EUGridPMA-RPM-3", 
            id     => "D12E922822BE64D50146188BC32D99C83CDBBC71",
    }

    apt::source {
        "egi-igtf":
            location => "http://repository.egi.eu/sw/production/cas/1/current",
            release  => "egi-igtf",
            repos    => "core",
            require  => Apt::Key["EUGridPMA"]
    }
}
