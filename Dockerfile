FROM alpine:edge

LABEL author="qwerty"

# Update repositories and install dependencies
RUN echo 'https://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
    && echo 'https://nl.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
    ca-certificates \
    libstdc++ \
    libgcc \
    krb5-libs \
    gmp \
    icu-libs \
    libintl \
    tzdata \
    libcurl \
    libuv \
    libssl1.1 \
    su-exec \
    tini \
    libc6-compat \
    nodejs \
    npm \
    curl \
    && apk add --no-cache \
    openssl

# Download and install Jackett binary
RUN curl -L -o Jackett.tar.gz https://github.com/Jackett/Jackett/releases/download/v0.22.119/Jackett.Binaries.LinuxAMDx64.tar.gz \
    && mkdir -p /Jackett \
    && tar -xzf Jackett.tar.gz -C /Jackett --strip-components 1 \
    && rm Jackett.tar.gz

# Download and install FlareSolverr
RUN curl -L -o flaresolverr.zip https://github.com/FlareSolverr/FlareSolverr/releases/latest/download/FlareSolverr-linux.zip \
    && mkdir -p /FlareSolverr \
    && unzip flaresolverr.zip -d /FlareSolverr \
    && rm flaresolverr.zip

# Copy supervisor configuration file
COPY supervisord.conf /etc/supervisord.conf

# Set working directories
WORKDIR /Jackett

# Expose required ports
EXPOSE 9117
EXPOSE 8191

# Define entry point for supervisor to handle multiple services
ENTRYPOINT ["/sbin/tini", "--", "supervisord", "-c", "/etc/supervisord.conf"]
