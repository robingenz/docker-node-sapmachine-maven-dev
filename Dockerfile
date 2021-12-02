FROM --platform=linux/amd64 ubuntu:18.04

LABEL MAINTAINER="Robin Genz <mail@robingenz.dev>"

ARG NODEJS_VERSION=16
ARG SAP_MACHINE_VERSION=11
ARG MAVEN_VERSION=3.8.4

ARG USERNAME=vscode
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ARG HOME=/home/${USERNAME}
ARG WORKDIR=$HOME

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8

WORKDIR /tmp

SHELL ["/bin/bash", "-l", "-c"] 

RUN apt-get update -q

# General packages
RUN apt-get install -qy \
    apt-utils \
    locales \
    gnupg2 \
    build-essential \
    curl \
    wget \
    ca-certificates \
    git \
    unzip

# Set locale
RUN locale-gen en_US.UTF-8 && update-locale

# Add user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --create-home --uid $USER_UID --gid $USER_GID -m $USERNAME

# [Optional] Add sudo support for the non-root user
RUN apt-get install -qy sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash - \
    && apt-get update -q && apt-get install -qy nodejs
ENV NPM_CONFIG_PREFIX=${HOME}/.npm-global
ENV PATH=$PATH:${HOME}/.npm-global/bin

# Install SapMachine
RUN export GNUPGHOME="$(mktemp -d)" \
    && wget -q -O - https://dist.sapmachine.io/debian/sapmachine.old.key | gpg --batch --import \
    && gpg --batch --export --armor 'DA4C 00C1 BDB1 3763 8608 4E20 C7EB 4578 740A EEA2' > /etc/apt/trusted.gpg.d/sapmachine.old.gpg.asc \
    && wget -q -O - https://dist.sapmachine.io/debian/sapmachine.key | gpg --batch --import \
    && gpg --batch --export --armor 'CACB 9FE0 9150 307D 1D22 D829 6275 4C3B 3ABC FE23' > /etc/apt/trusted.gpg.d/sapmachine.gpg.asc \
    && gpgconf --kill all && rm -rf "$GNUPGHOME" \
    && echo "deb http://dist.sapmachine.io/debian/amd64/ ./" > /etc/apt/sources.list.d/sapmachine.list \
    && apt-get update -q \
    && apt-get install -qy sapmachine-${SAP_MACHINE_VERSION}-jdk

# Install Maven
ENV MAVEN_HOME=/opt/apache-maven-${MAVEN_VERSION}
RUN curl -sL https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip -o apache-maven-${MAVEN_VERSION}-bin.zip \
    && unzip -d /opt apache-maven-${MAVEN_VERSION}-bin.zip
ENV PATH=$PATH:${MAVEN_HOME}/bin

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

WORKDIR $WORKDIR

USER $USERNAME

ENTRYPOINT ["/bin/bash", "-l", "-c"]
