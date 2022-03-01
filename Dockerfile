FROM ubuntu:18.04

ENV GITHUB_PAT ""
ENV GITHUB_ORG_NAME ""
ENV RUNNER_WORKDIR "_work"
ENV RUNNER_LABELS ""

RUN apt-get update \
    && apt-get install -y curl sudo git jq iputils-ping zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl https://download.docker.com/linux/static/stable/x86_64/docker-20.10.7.tgz --output docker-20.10.7.tgz \
    && tar xvfz docker-20.10.7.tgz \
    && cp docker/* /usr/bin/

USER root
WORKDIR /root/

RUN GITHUB_RUNNER_VERSION="2.278.0" \
    && curl -Ls https://internal.knat.network/action-runner/actions-runner-linux-x64-${GITHUB_RUNNER_VERSION}.tar.gz | tar xz \
    && ./bin/installdependencies.sh

COPY entrypoint.sh runsvc.sh ./
RUN sudo chmod u+x ./entrypoint.sh ./runsvc.sh

ENTRYPOINT ["./entrypoint.sh"]