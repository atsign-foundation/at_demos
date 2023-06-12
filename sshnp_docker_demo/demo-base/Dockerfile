FROM ubuntu:22.04@sha256:dfd64a3b4296d8c9b62aa3309984f8620b98d87e47492599ee20739e8eb54fbf

ENV USER=atsign
ENV HOMEDIR=/${USER}
ENV USER_ID=1024
ENV GROUP_ID=1024 

WORKDIR /app

RUN set -eux ; \
    apt-get update ; \
    apt-get install -y openssh-server wget sudo iputils-ping iproute2 ncat \
        telnet net-tools nmap iperf3 tmux traceroute nano vim watch curl dpkg ; \
    addgroup --gid ${GROUP_ID} ${USER} ; \
    sysctl -w net.ipv4.ping_group_range="0 1024" ; \
    useradd --system --uid ${USER_ID} --gid ${GROUP_ID} --shell /bin/bash \
        --home ${HOMEDIR} ${USER} ; \
    usermod -aG sudo ${USER} ; \
    mkdir -p ${HOMEDIR}/.sshnp ${HOMEDIR}/.atsign/keys ${HOMEDIR}/.ssh /run/sshd  ; \
    touch ${HOMEDIR}/.ssh/authorized_keys ; \
    chown -R ${USER}:${USER} ${HOMEDIR} ; \
    ex +"%s/^%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g" -scwq! /etc/sudoers ; \
    sed -E -i 's|^#?(PasswordAuthentication)\s.*|\1 no|' /etc/ssh/sshd_config ; \
    sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 127.0.0.1/g' /etc/ssh/sshd_config ;

WORKDIR ${HOMEDIR}

USER ${USER}

ENTRYPOINT sudo service ssh start && bash
