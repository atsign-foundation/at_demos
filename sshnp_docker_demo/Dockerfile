FROM ubuntu

ENV USER=atsign
ENV HOMEDIR=/${USER}
ENV USER_ID=1024
ENV GROUP_ID=1024

WORKDIR ${HOMEDIR}

RUN mkdir -p ${HOMEDIR}/.atsign/keys ${HOMEDIR}/.ssh /run/sshd 

COPY keys/*.atKeys ${HOMEDIR}/.atsign/keys
COPY .startup.sh ${HOMEDIR}

RUN apt-get update && apt-get install -y openssh-server wget sudo iputils-ping iproute2 ncat telnet net-tools nmap iperf3 tmux traceroute nano vim watch curl ; \ 
    set -eux; \
    case "$(dpkg --print-architecture)" in \
    amd64) \
    ARCH="x64";; \
    armhf) \
    ARCH="arm";; \
    arm64) \
    ARCH="arm64";; \
    riscv64) \
    ARCH="riscv64";; \
    esac; \
    VERSION=$(curl --silent "https://api.github.com/repos/atsign-foundation/sshnoports/releases/latest" | grep -Po '"tag_name": "v\K.*?(?=")') ; \
    wget https://github.com/atsign-foundation/sshnoports/releases/download/v${VERSION}/sshnp-linux-${ARCH}.tgz ; \
    tar -xvf sshnp-linux-${ARCH}.tgz ; \
    rm sshnp-linux-${ARCH}.tgz; \
    touch ${HOMEDIR}/.ssh/authorized_keys ; \
    addgroup --gid ${GROUP_ID} ${USER} ; \
    sysctl -w net.ipv4.ping_group_range="0 1024" ; \
    useradd --system --uid ${USER_ID} --gid ${GROUP_ID} --shell /bin/bash --home ${HOMEDIR} ${USER} ; \
    usermod -aG sudo ${USER} ; \
    chown -R ${USER}:${USER} ${HOMEDIR}
# chmod 600 ${HOMEDIR}/.ssh/authorized_keys ; \
# chmod 755 ${HOMEDIR}/.startup.sh

# ENTRYPOINT [ "sh", "/atsign/.startup.sh" ]