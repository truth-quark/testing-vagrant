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

if [ ! -e $EMPTY_DIR ]
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

if ! grep -e "export PS1=" /home/vagrant/.bashrc
  then echo $PS1_CODE >> /home/vagrant/.bashrc
fi
