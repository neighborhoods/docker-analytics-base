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
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
    build-essential \
    git \
    inkscape \
    libgmp3-dev \
    libsm6 \
    libssl-dev \
    libcurl4-openssl-dev \
    libmpfr-dev \
    libmpc-dev \
    libpq-dev \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    pandoc \
    python3-dev \
    python3-pip \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    unzip \
    vim \
    fonts-dejavu \
    tzdata \
    gfortran \
    gcc \
    libav-tools \
    software-properties-common \
    apt-transport-https \
    libxml2-dev \
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
