FROM ubuntu:20.04

ENV GITHUB_PAT ""
ENV GITHUB_ORG_NAME ""  


RUN apt-get update \
    && apt-get install -y curl sudo git jq tar gnupg2 iputils-ping  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl https://download.docker.com/linux/static/stable/x86_64/docker-20.10.13.tgz --output docker-20.10.13.tgz \
    && tar xvfz docker-20.10.13.tgz \
    && cp docker/* /usr/bin/ 


RUN useradd -m github && \
    usermod -aG sudo github && \
    groupadd docker && \
    usermod -aG docker github && \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER github
WORKDIR /home/github

RUN curl -oLs https://github.com/actions/runner/releases/download/v2.288.1/actions-runner-linux-x64-2.288.1.tar.gz | tar xz \
    && sudo ./bin/installdependencies.sh

COPY --chown=github:github entrypoint.sh ./entrypoint.sh
RUN sudo chmod u+x ./entrypoint.sh

ENTRYPOINT ["/home/github/entrypoint.sh"]
