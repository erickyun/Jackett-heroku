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
    wget \
    tar \
    supervisor \
    && apk add --no-cache \
    openssl

# Download and install Jackett binary
RUN wget -O Jackett.tar.gz https://github.com/Jackett/Jackett/releases/download/v0.22.119/Jackett.Binaries.LinuxAMDx64.tar.gz \
    && mkdir -p /Jackett \
    && tar -xzf Jackett.tar.gz -C /Jackett --strip-components 1 \
    && rm Jackett.tar.gz

# Download and install FlareSolverr
RUN wget -O flaresolverr.tar.gz https://github.com/FlareSolverr/FlareSolverr/releases/download/v3.3.19/flaresolverr_linux_x64.tar.gz \
    && mkdir -p /FlareSolverr \
    && tar -xzf flaresolverr.tar.gz -C /FlareSolverr --strip-components 1 \
    && rm flaresolverr.tar.gz

# Ensure binaries are executable
RUN chmod +x /Jackett/jackett /FlareSolverr/flaresolverr

# Set environment variable to use invariant globalization
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

# Copy supervisor configuration file
COPY supervisord.conf /etc/supervisord.conf

# Set working directories
WORKDIR /Jackett

# Expose required ports
EXPOSE 9117
EXPOSE 8191

# Define entry point for supervisor to handle both Jackett and FlareSolverr
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["supervisord", "-c", "/etc/supervisord.conf", "-n"]

