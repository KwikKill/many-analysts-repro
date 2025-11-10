FROM debian:wheezy

# Set archive sources for Wheezy
RUN echo "deb http://archive.debian.org/debian wheezy main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security wheezy/updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until

# Install build dependencies
RUN apt-get update && apt-get install -y --force-yes --no-install-recommends \
    build-essential \
    gfortran \
    libreadline-dev \
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
        --with-x=no && \
    make && make install && \
    cd / && rm -rf /tmp/R-3.0.2*

# Set CRAN mirror
RUN echo 'options(repos = c(CRAN = "https://cran.r-project.org/"))' >> /usr/local/lib/R/etc/Rprofile.site

# Install R packages (use archive URLs for old versions)
RUN R -e "install.packages(c('Rcpp', 'inline', 'RcppEigen', 'BH'), type='source')" && \
    R -e "install.packages('StanHeaders', repos='https://cran.r-project.org/src/contrib/Archive/StanHeaders/', type='source')" && \
    R -e "install.packages('rstan', repos='https://cran.r-project.org/src/contrib/Archive/rstan/', type='source')" && \
    R -e "install.packages(c('lme4','dplyr','ggplot2','readr','tidyr'), type='source', dependencies=TRUE)"

# Set working directory
WORKDIR /analysis

# Copy data and analysis script
#COPY data ./data
COPY 3.r ./

# Default command
CMD ["Rscript", "./3.r"]
