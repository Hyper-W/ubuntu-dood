FROM ubuntu:latest

# For above Ubuntu 24.04
RUN touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu && userdel -r ubuntu ; exit 0

# Your Property
ARG USER=user
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl gnupg lsb-release sudo \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" >> /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin \
    && apt-get remove -y --purge --autoremove curl gnupg lsb-release \
    && apt-get clean && rm -rf /var/lib/apt/lists/ \
    && groupadd -g ${GROUP_ID} ${USER} \
    && groupadd docker \
    && useradd -u ${USER_ID} -m -s /bin/bash -g ${USER} -G sudo,docker ${USER} \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ENV PATH=$PATH:/usr/libexec/docker/cli-plugins/

USER ${USER}

WORKDIR /home/${USER}