# Ubuntu 16.04 (xenial) from 2018-02-28
# https://github.com/docker-library/official-images/commit/8728671fdca3dfc029be4ab838ab5315aa125181
FROM ubuntu:xenial-20180228@sha256:e348fbbea0e0a0e73ab0370de151e7800684445c509d46195aef73e090a49bd6

LABEL maintainer="Neighborhoods <neighborhoods.engineering@neighborhoods.com>"

USER root

# Install all OS dependencies for notebook server
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    # these package versions good as of 2018-08-14
    wget=1.17.1-1ubuntu1 \
    bzip2=1.0.6-8 \
    ca-certificates=20170717~16.04.1 \
    sudo=1.8.16-0ubuntu1 \
    locales=2.23-0ubuntu10 \
    fonts-liberation=1.07.4-1 \
    build-essential=12.1ubuntu2 \
    git=1:2.7.4-0ubuntu1 \
    inkscape=0.91-7ubuntu2 \
    libgmp3-dev=2:6.1.0+dfsg-2 \
    libsm6=2:1.2.2-1 \
    libssl-dev=1.0.2g-1ubuntu4.13 \
    libcurl4-openssl-dev=7.47.0-1ubuntu2.8 \
    libmpfr-dev=3.1.4-1 \
    libmpc-dev=1.0.3-1 \
    libpq-dev=9.5.13-0ubuntu0.16.04 \
    libxext-dev=2:1.3.3-1 \
    libxrender1=1:0.9.9-0ubuntu1 \
    lmodern=2.004.5-1 \
    netcat=1.10-41 \
    pandoc=1.16.0.2~dfsg-1 \
    python3-dev=3.5.1-3 \
    python3-pip=8.1.1-2ubuntu0.4 \
    texlive-fonts-extra=2015.20160320-1 \
    texlive-fonts-recommended=2015.20160320-1ubuntu0.1 \
    texlive-generic-recommended=2015.20160320-1ubuntu0.1 \
    texlive-latex-base=2015.20160320-1ubuntu0.1 \
    texlive-latex-extra=2015.20160320-1 \
    texlive-xetex=2015.20160320-1 \
    unzip=6.0-20ubuntu1 \
    vim=2:7.4.1689-3ubuntu1.2 \
    fonts-dejavu=2.35-1 \
    tzdata=2017c-0ubuntu0.16.04 \
    gfortran=4:5.3.1-1ubuntu1 \
    gcc=4:5.3.1-1ubuntu1 \
    libav-tools=7:2.8.14-0ubuntu0.16.04.1 \
    software-properties-common=0.96.20.7 \
    apt-transport-https=1.2.27 \
    libxml2-dev=2.9.3+dfsg1-1ubuntu0.6 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# get CRAN's apt repository
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/' && \
    apt-get update && apt-get clean

# R Setup
COPY install_packages.R .
RUN apt-get install -y \
    r-recommended=3.4.3-1xenial0 \
    r-base=3.4.3-1xenial0 \
 && Rscript install_packages.R

# Python Setup
RUN pip3 install -U setuptools wheel
COPY requirements.txt .
RUN pip3 install -r requirements.txt

EXPOSE 8888
