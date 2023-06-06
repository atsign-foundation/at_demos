FROM atsigncompany/sshnp_docker_demo_base:latest

ENV USER=atsign
ENV HOMEDIR=/${USER}

COPY --chown=${USER}:${USER} keys/*.atKeys ${HOMEDIR}/.atsign/keys
COPY --chown=${USER}:${USER} .startup.sh ${HOMEDIR}/.startup.sh

# ENTRYPOINT [ "sh", "/atsign/.startup.sh" ]
