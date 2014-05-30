FROM ubuntu:precise

RUN	apt-get -y update && apt-get -y install git ssh
RUN ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
RUN mkdir -p /var/run/sshd
RUN git clone https://github.com/sstephenson/bats.git && cd bats && ./install.sh /usr/local
RUN git config --global user.email "robot@example.com"
RUN git config --global user.name "Robot"

ADD . /tmp
RUN mv /tmp/gitreceive /usr/local/bin/gitreceive
CMD /tmp/init