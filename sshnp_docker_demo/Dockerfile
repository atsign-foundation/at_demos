FROM debian:stable-20230522-slim@sha256:d828cca5497a2519da9c6d42372066895fa28a69f1e8a46a38ce8f750bd2adf0 AS buildimage

WORKDIR /app

RUN set -eux ; \
    apt-get update ; \
    apt-get install -y openssh-server wget sudo iputils-ping iproute2 ncat \
    telnet net-tools nmap iperf3 tmux traceroute nano vim watch curl dpkg ; \
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
    URL="https://api.github.com/repos/atsign-foundation/sshnoports/releases/latest" ; \
    VERSION=$(curl --silent ${URL} | grep -Po '"tag_name": "v\K.*?(?=")') ; \
    URLP="https://github.com/atsign-foundation/sshnoports/releases/download" ; \
    wget "${URLP}/v${VERSION}/sshnp-linux-${ARCH}.tgz" ; \
    tar -xvf sshnp-linux-${ARCH}.tgz ; \
    rm sshnp-linux-${ARCH}.tgz ;

FROM ubuntu:22.04@sha256:dfd64a3b4296d8c9b62aa3309984f8620b98d87e47492599ee20739e8eb54fbf

ENV USER=atsign
ENV HOMEDIR=/${USER}
ENV USER_ID=1024
ENV GROUP_ID=1024

WORKDIR ${HOMEDIR}

RUN set -eux ; \
    apt-get update ; \
    apt-get install -y openssh-server wget sudo iputils-ping iproute2 ncat \
        telnet net-tools nmap iperf3 tmux traceroute nano vim watch curl dpkg ; \
    addgroup --gid ${GROUP_ID} ${USER} ; \
    sysctl -w net.ipv4.ping_group_range="0 1024" ; \
    useradd --system --uid ${USER_ID} --gid ${GROUP_ID} --shell /bin/bash \
        --home ${HOMEDIR} ${USER} ; \
    usermod -aG sudo ${USER} ; \
    mkdir -p ${HOMEDIR}/.atsign/keys ${HOMEDIR}/.ssh /run/sshd ${HOMEDIR}/sshnp ; \
    touch ${HOMEDIR}/.ssh/authorized_keys ; \
    # chmod 600 ${HOMEDIR}/.ssh/authorized_keys ; \
    chown -R ${USER}:${USER} ${HOMEDIR} ;

COPY --chown=${USER}:${USER} --from=buildimage /app/sshnp ${HOMEDIR}/sshnp
COPY keys/*.atKeys ${HOMEDIR}/.atsign/keys
COPY --chmod=755 .startup.sh ${HOMEDIR}

# ENTRYPOINT [ "sh", "/atsign/.startup.sh" ]