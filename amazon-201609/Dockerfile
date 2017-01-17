FROM amazonlinux:2016.09

MAINTAINER Alexander Kukhar <kyxap@kyxap.pro>

# ensure we have the en_US.UTF-8 locale available
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# install common dependencies
RUN yum check-update -y && yum install -y \
    passwd \
    wget \
    curl \
    lsb-release \
    openssh-server \
    net-tools \
    sudo

# generate new host key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''

# setup the vagrant user
RUN if ! getent passwd vagrant; then useradd -d /home/vagrant -m -s /bin/bash vagrant; fi \
    && echo vagrant:vagrant | chpasswd \
    && echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && mkdir -p /etc/sudoers.d \
    && echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/vagrant \
    && chmod 0440 /etc/sudoers.d/vagrant

# add the vagrant insecure public key
RUN mkdir -p /home/vagrant/.ssh \
    && chmod 0700 /home/vagrant/.ssh \
    && wget --no-check-certificate \
      https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
      -O /home/vagrant/.ssh/authorized_keys \
    && chmod 0600 /home/vagrant/.ssh/authorized_keys \
    && chown -R vagrant /home/vagrant/.ssh

# run sshd in the foreground
CMD /usr/sbin/sshd -D \
    -o UseDNS=no\
    -o PasswordAuthentication=yes\
    -o UsePrivilegeSeparation=no\
    -o PidFile=/tmp/sshd.pid

