FROM debian:wheezy

# Update sources to use archive (Debian 7 is EOL)
RUN echo "deb http://archive.debian.org/debian wheezy main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security wheezy/updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until

# Install build dependencies
RUN apt-get update && apt-get install -y --force-yes \
    build-essential \
    gfortran \
    libreadline-dev \
    libx11-dev \
    libxt-dev \
    libpng-dev \
    libjpeg-dev \
    libcairo2-dev \
    libbz2-dev \
    zlib1g-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    wget \
    ca-certificates \
    xvfb \
    xauth \
    xfonts-base \
    && rm -rf /var/lib/apt/lists/*

# Download and build R 3.0.2
WORKDIR /tmp
RUN wget https://cran.r-project.org/src/base/R-3/R-3.0.2.tar.gz && \
    tar -xzf R-3.0.2.tar.gz && \
    cd R-3.0.2 && \
    ./configure \
        --prefix=/usr/local \
        --enable-R-shlib \
        --with-blas \
        --with-lapack \
        --with-readline \
        --with-cairo \
        --with-x=no && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/R-3.0.2*

# Set CRAN mirror
RUN echo 'options(repos = c(CRAN = "https://cran.r-project.org/"))' >> /usr/local/lib/R/etc/Rprofile.site

# Install Rcpp and inline (required for rstan)
RUN R -e "install.packages('Rcpp', type='source')"
RUN R -e "install.packages('inline', type='source')"

# Install RcppEigen (required for rstan)
RUN R -e "install.packages('RcppEigen', type='source')"

# Install BH (Boost headers, required for rstan)
RUN R -e "install.packages('BH', type='source')"

# Install StanHeaders - use older version compatible with R 3.0.2
RUN R -e "install.packages('StanHeaders', type='source')" || \
    R -e "packageurl <- 'https://cran.r-project.org/src/contrib/Archive/StanHeaders/StanHeaders_2.0.0-1.tar.gz'; install.packages(packageurl, repos=NULL, type='source')"

# Install rstan - use version compatible with R 3.0.2
RUN R -e "install.packages('rstan', type='source')" || \
    R -e "packageurl <- 'https://cran.r-project.org/src/contrib/Archive/rstan/rstan_2.5.0.tar.gz'; install.packages(packageurl, repos=NULL, type='source')" || \
    R -e "packageurl <- 'https://cran.r-project.org/src/contrib/Archive/rstan/rstan_2.6.0.tar.gz'; install.packages(packageurl, repos=NULL, type='source')"

# Install other commonly needed packages (add more as needed)
RUN R -e "install.packages('lme4', type='source')" || true
RUN R -e "install.packages('dplyr', type='source')" || true
RUN R -e "install.packages('ggplot2', type='source')" || true
RUN R -e "install.packages('readr', type='source')" || true
RUN R -e "install.packages('tidyr', type='source')" || true

# Set working directory
WORKDIR /analysis

# Default command is R console (can be overridden)
CMD ["R"]