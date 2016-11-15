# puppet-umd module

This module will deploy the required repositories in order to perform an UMD software
validation.

## Installation

    wget https://github.com/egi-qc/puppet-umd/archive/master.zip -O /tmp/puppet-umd-<VERSION>.tar.gz
    puppet module install --ignore-dependencies /tmp/puppet-umd-<VERSION>.tar.gz

## Usage

    class {
        "umd":
            release               => 4,
            verification_repofile => "http://admin-repo.egi.eu/sw/unverified/cmd-os-1.ifca.occi.ubuntu-trusty.amd64/0/3/2/repofiles/IFCA.occi.ubuntu-trusty.amd64.list",
            openstack_release     => "mitaka",
    }

Parameters are self-explanatory. Note that `verification_repofile` must point to a valid YUM or APT source file.

For running this module programatically, like it is being done by the 
`umd-verification` application, the best approach is to pass the `umd`
class parameters through hiera. See an example below:

    umd::release: 4
    umd::verification::repofile: http://admin-repo.egi.eu/sw/unverified/cmd-os-1.ifca.occi.ubuntu-trusty.amd64/0/3/2/repofiles/IFCA.occi.ubuntu-trusty.amd64.list
    umd::openstack_release: mitaka
