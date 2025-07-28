FROM alpine:3.21 AS base

# Install OpenJDK 11 and essential runtime dependencies
RUN apk add --no-cache openjdk11 python3 ttf-dejavu fontconfig libstdc++ libgcc libx11 libxext libxrender libxtst libxi libxrandr libxinerama libfreetype libfontconfig libxss

ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk"
ENV PATH="$JAVA_HOME/bin:$PATH"

FROM base AS build

USER root

ENV BUILD_PACKAGES="\
      gawk \
      gcc \
      gcompat \
      git \
      maven \
      musl-dev \
      python3-dev \
      wget \
      "

ENV PACKAGES="\
      fontconfig \
      gcompat \
      libgfortran \
      openjdk11 \
      python3 \
      vim \
      ttf-dejavu \
      zip \
      "

RUN echo "Install build dependencies"; \
    apk update; \
    apk add --no-cache --virtual .build-deps $BUILD_PACKAGES; \
    apk add --no-cache $PACKAGES; \
    echo "Install step done"

ENV LC_ALL="en_US.UTF-8"
# SNAP wants current folder '.' included in LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH=".:/usr/lib/jvm/java-11-openjdk/lib/server/:${LD_LIBRARY_PATH}"

# Set JAVA_HOME correctly for SNAP
ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk"

# Copy your SNAP installer script/folder into the container
COPY snap /src/snap

# Run your SNAP installation script
RUN sh /src/snap/install.sh

FROM base AS snappy

# Install runtime dependencies for SNAP
RUN apk add --no-cache openjdk11 python3 ttf-dejavu fontconfig libstdc++ libgcc libx11 libxext libxrender libxtst libxi libxrandr libxinerama libfreetype libfontconfig libxss

ENV LD_LIBRARY_PATH=".:$LD_LIBRARY_PATH"
COPY --from=build /root/.snap /root/.snap
COPY --from=build /usr/local/snap /usr/local/snap

# Update SNAP modules (requires fontconfig)
RUN /usr/local/snap/bin/snap --nosplash --nogui --modules --update-all

# Add SNAP binaries to PATH
ENV PATH="${PATH}:/usr/local/snap/bin"

# Test SNAP GPT CLI
RUN gpt -h
