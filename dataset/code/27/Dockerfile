FROM python:2.7-slim

# Fix sources for old Debian Buster
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        python-dev \
        libatlas-base-dev \
        tk-dev \
        ca-certificates \
        wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY data ./data
COPY requirements.txt ./
COPY 27.py ./

RUN pip install --upgrade pip==20.3.4
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "27.py"]
