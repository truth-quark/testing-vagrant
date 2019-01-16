# vagrant-testing

## About

vagrant-testing is a [vagrant](https://www.vagrantup.com/) configuration for running the [liboqs integration tests](https://github.com/open-quantum-safe/testing) in an Ubuntu 16 (xenial) VM using VirtualBox.

Due to persistent failed build problems with Vagrant, the vagrant project thread has been discontinued (see problems below). This project is included for the sake of completeness, and to provide a reference for any future liboqs projects.

## Getting started

To launch from the command line:

```
$ cd <your-project-dir>
$ git clone https://github.com/truth-quark/testing-vagrant
$ cd testing-vagrant
$ vagrant up
```

This may take some time to download the Ubuntu boxes, and potentially over 40 minutes to run the integration test suites.

To **disable** either the SSH and/or SSL tests (to test individually, or just strtup a VM), create a flag file in the project dir:

```
$ cd <your-project-dir>/vagrant-testing
$ touch DISABLE_OPENSSH
$ touch DISABLE_OPENSSL
```


This config has been run with Vagrant 2.2.0 and 2.2.2 on MacOS High Sierra.

## Problems

The OpenSSL tests often fail to build/run clean for reasons unknown. There may be problems with the build system, or the config of the ubuntu xenial boxes. The causes are still unknown. The tests run clean on manually built VMs within VirtualBox, built from the publicly available ISOs.
