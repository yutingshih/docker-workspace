FROM ubuntu:22.04

ARG UID=1000
ARG GID=1000
ARG USERNAME="user"

ENV TZ="Asia/Taipei"
ENV USER ${USERNAME}
ENV TERM xterm-256color
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE DontWarn

RUN apt update && apt install -y --no-install-recommends \
    sudo tzdata

# add non-root user account
RUN groupadd -o -g ${GID} ${USERNAME} && \
    useradd -l -u ${UID} -g ${GID} -s /bin/bash -m ${USERNAME} && \
    echo ${USERNAME} ALL=\(ALL\) NOPASSWD: ALL > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    # disable the user's passward
    passwd -d ${USERNAME}

# add scripts and setup permissions
COPY --chown=${UID}:${GID} --chmod=755 ./scripts/*.sh /usr/local/bin/

USER ${USERNAME}

WORKDIR /home/${USERNAME}

CMD [ "/bin/bash" ]
