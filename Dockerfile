# We use the Micromamba image, as published by Continuum.io
# https://hub.docker.com/r/mambaorg/micromamba
#
# Heads-up: This image is based on Ubuntu 22.04 (jammy)
FROM mambaorg/micromamba:1.1.0-jammy

# We need superuser permission to do the building
USER root

# First, install the R-related dependencies from the Debian repository
# https://cran.r-project.org/bin/linux/debian/
ARG DEBIAN_FRONTEND=noninteractive
RUN \
    apt-get update -qq && \
    apt-get install --yes --no-install-recommends \
        # For building
        build-essential \
        # Useful utilities
        curl \
        wget \
        # R
        r-base \
        r-base-dev \
        # These items are required by the R dependencies in `deps.R`
        libcurl4-openssl-dev \
        libfontconfig1-dev \
        libmagick++-dev \
        libssl-dev \
        libxml2-dev \
        lmodern \
        texlive \
        texlive-fonts-extra \
        texlive-latex-extra \
        texlive-plain-generic \
        pandoc \
        pandoc-citeproc \
        && \
    rm -rf /var/lib/apt/lists/*

# We also install the R dependencies.
COPY deps.R /tmp/deps.R
RUN \
   R -e 'install.packages("docopt", repos = "https://cran.microsoft.com/snapshot/2022-12-08/")' && \
   Rscript /tmp/deps.R --install

# Then, we copy the `environment.yaml` into the Docker image to create a Python
# environment. Note that we are no longer superuser here.
#
# Also, note that the `bash` now automatically activates the environment used
# in the project.
USER $MAMBA_USER
COPY environment.yaml /tmp/environment.yaml
RUN \
    micromamba create -f /tmp/environment.yaml
RUN \
    micromamba shell init -s bash && \
    echo "micromamba activate chocolate_exploration" >> /home/${MAMBA_USER}/.bashrc && \
    echo "cd ~" >> /home/${MAMBA_USER}/.bashrc && \
    echo "[ -d /app ] && cd /app" >> /home/${MAMBA_USER}/.bashrc && \
    echo "[ -d app ] && cd app"  >> /home/${MAMBA_USER}/.bashrc
