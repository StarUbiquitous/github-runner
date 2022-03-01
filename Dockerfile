FROM ubuntu:18.04

ENV GITHUB_PAT ""
ENV GITHUB_ORG_NAME ""  


RUN apt-get update \
    && apt-get install -y curl sudo git jq tar gnupg2 iputils-ping  \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl https://download.docker.com/linux/static/stable/x86_64/docker-19.03.9.tgz --output docker-19.03.9.tgz \
    && tar xvfz docker-19.03.9.tgz \
    && cp docker/* /usr/bin/ 


RUN useradd -m github && \
    usermod -aG sudo github && \
    echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER github
WORKDIR /home/github

RUN curl -Ls https://github.com/actions/runner/releases/download/v2.287.1/actions-runner-linux-x64-2.287.1.tar.gz | tar xz \
    && sudo ./bin/installdependencies.sh

COPY --chown=github:github entrypoint.sh ./entrypoint.sh
RUN sudo chmod u+x ./entrypoint.sh

ENTRYPOINT ["/home/github/entrypoint.sh"]