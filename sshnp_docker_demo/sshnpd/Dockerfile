FROM ubuntu

ENV USER=atsign
ENV HOMEDIR=/${USER}
ENV USER_ID=1024
ENV GROUP_ID=1024

RUN mkdir -p ${HOMEDIR}/.atsign/keys
RUN mkdir -p ${HOMEDIR}/.ssh
RUN touch $HOMEDIR/.ssh/authorized_keys
RUN mkdir /run/sshd

COPY keys/*.atKeys ${HOMEDIR}/.atsign/keys
COPY .startup.sh ${HOMEDIR}

RUN apt-get update && apt-get install -y openssh-server wget sudo iputils-ping iproute2 ncat telnet net-tools nmap iperf3 tmux traceroute nano vim watch

RUN addgroup --gid ${GROUP_ID} ${USER}
RUN sysctl -w net.ipv4.ping_group_range="0 1024"
RUN useradd --system --uid ${USER_ID} --gid ${GROUP_ID} --shell /bin/bash  --home ${HOMEDIR} ${USER}
RUN usermod -aG sudo ${USER}

RUN chown -R ${USER}:${USER} ${HOMEDIR}
RUN chmod 600 ${HOMEDIR}/.ssh/authorized_keys
RUN chmod 755 ${HOMEDIR}/.startup.sh

RUN mkdir -p ${HOMEDIR}
WORKDIR ${HOMEDIR}
RUN wget https://github.com/atsign-foundation/sshnoports/releases/download/v3.1.2/sshnp-linux-arm64.tgz
RUN tar -xvf sshnp-linux-arm64.tgz ; rm -rf sshnp-linux-arm64.tgz