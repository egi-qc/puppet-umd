# puppet-umd

This Puppet module deploys [EGI](https://www.egi.eu/)'s UMD and/or CMD software
distribution repositories, residing at http://repository.egi.eu.

## Installation
### From [PuppetForge](https://forge.puppet.com/)

    puppet module install egiqc/umd

### With [librarian-puppet](http://librarian-puppet.com/) tool
An example of Puppetfile:

    cat <<EOF >>Puppetfile
    #!/usr/bin/env ruby
    forge "https://forgeapi.puppetlabs.com"
    mod "egiqc/umd"

or using the repository directly:

    cat <<EOF >>Puppetfile
    #!/usr/bin/env ruby
    forge "https://forgeapi.puppetlabs.com"
    mod "egi-qc/umd", :git => "git://github.com/egi-qc/puppet-umd.git"

Once in the Puppetfile's root path, run:

    librarian-puppet install --clean

## Usage
Simplest-case scenario would be to provide the `distribution` parameter and
leave anything else as defaults. This one-liner does the job:

    puppet apply -e 'class {"umd": distribution => "umd"}'

Supported distributions are:
  - `umd` for the UMD repository
  - `cmd-os` for the OpenStack CMD repository

The module will take by default the latest production release version for the
selected distribution. Otherwise, the release version could be passed with the
`release` variable:

    class {
        "umd":
            distribution => "umd",
            release => 4,
    }

### Available repositories
The repositories enabled by default are:
  - base
  - updates

The rest of available repositories are:
  - testing
  - untested

which can be enabled with `enable_testing_repo`and `enable_untested_repo`,
respectively.

### Extra repositories (verification)
[EGI Software Provisioning process](https://wiki.egi.eu/wiki/Software_Provisioning_Process)
uses this module for the software product's verification. Consequently, there
is the possibility of providing extra repositories with `verification_repofile`
parameter, as happen to be the verification one. Note that
`verification_repofile` must point to a valid YUM or APT source file:

    class {
        "umd":
            distribution => "umd",
            release => 4,
            verification_repofile => "http://admin-repo.egi.eu/sw/unverified/cmd-os-1.ifca.occi.ubuntu-trusty.amd64/0/3/2/repofiles/IFCA.occi.ubuntu-trusty.amd64.list"
    }
### EGI IGTF
This module is also able to deploy the [EGI IGTF release](https://wiki.egi.eu/wiki/EGI_IGTF_Release),
containing the trusted set of certification authorities in the EGI
infrastructure. By default, the EGI IGTF repository is deployed and the trusted
CAs are installed. To disable this feature:

    class {
        "umd":
            distribution => "umd",
            igtf_repo => false,
    }

