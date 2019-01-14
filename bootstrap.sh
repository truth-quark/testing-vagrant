# Configuration to bootstrap Ubuntu Xenial VM for liboqs integration testing

set -e

# setup timezone for timestamps
sudo rm /etc/localtime && sudo ln -s /usr/share/zoneinfo/America/Toronto /etc/localtime

# updates
alias apt="apt-get -y"  # if 'apt' used by accident...
sudo apt-get -y update
sudo apt-get -y install gcc build-essential autotools-dev autoconf automake git libssl-dev libtool xsltproc zlib1g-dev zip

# config for openssh-portable
# create required empty dir
EMPTY_DIR=/var/empty

if [ ! -d $EMPTY_DIR ]
  then sudo mkdir -p -m 0755 $EMPTY_DIR
fi

# privsep user
if ! grep -e "^sshd:" /etc/group
  then sudo groupadd sshd
fi

if ! getent passwd | grep -e "^sshd:"
  then sudo useradd -g sshd -c 'sshd privsep' -d $EMPTY_DIR -s /bin/false sshd
fi

# UI tweaks: make host bold red in prompt/visual aid to indicate VM prompt
PS1_CODE='export PS1="\u@\[\033[1;31m\]\h\033[0m\]:\w $ "'

if ! grep -e "export PS1=" $HOME/.bashrc
  then echo $PS1_CODE >> $HOME/.bashrc
fi

if [ ! -e /vagrant/.inputrc ]
then
  # tweak inputrc for home, end keys etc
  ln -s /vagrant/.inputrc
fi

# work in /vagrant so logs can be accessed on host and VM
INTEGRATION_DIR=/vagrant/testing

# TODO: add .git to dir name?
if [ ! -d $INTEGRATION_DIR ]
then
    cd /vagrant
    git clone https://github.com/open-quantum-safe/testing.git
fi

# run openssh tests
# TODO: does set -e work here for fail fast?
DISABLE_OPENSSH_TESTS=/vagrant/DISABLE_OPENSSH_TESTS

if [ ! -e $DISABLE_OPENSSH_TESTS ]
  then
    cd $INTEGRATION_DIR/integration/oqs_openssh
    time ./run.sh | tee `date "+%Y%m%d-%Hh%Mm%Ss-openssh.log.txt"`
  else
    echo "Skipping OpenSSH test script"
fi

# run openssl tests
DISABLE_OPENSSL_TESTS=/vagrant/DISABLE_OPENSSL_TESTS

if [ ! -e $DISABLE_OPENSSL_TESTS ]
  then
    cd $INTEGRATION_DIR/integration/oqs_openssl
    set +e  # prevent future "which clang" call from breaking run???
    time ./run.sh | tee `date "+%Y%m%d-%Hh%Mm%Ss-openssl.log.txt"`
  else
    echo "Skipping OpenSSL test script"
fi
