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
    curl \
    && apk add --no-cache \
    openssl

# Download and extract Jackett binary
RUN curl -L -o Jackett.tar.gz https://github.com/Jackett/Jackett/releases/download/v0.22.119/Jackett.Binaries.LinuxAMDx64.tar.gz \
    && mkdir -p /Jackett \
    && tar -xzf Jackett.tar.gz -C /Jackett --strip-components 1 \
    && rm Jackett.tar.gz

# Set working directory
WORKDIR /Jackett

# Expose required port
EXPOSE 9117

# Define entrypoint and command to run the Jackett binary
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["./jackett"]
