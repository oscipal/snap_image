# Use a Debian-based OpenJDK 11 runtime
FROM openjdk:11-jre-slim

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget unzip python3 fontconfig fonts-dejavu \
    libxext6 libxrender1 libxtst6 libxi6 libxrandr2 libxinerama1 libfreetype6 libfontconfig1 libxss1 libx11-6 \
    && rm -rf /var/lib/apt/lists/*

# Set versions and directories
ENV SNAP_VERSION=12.0.0
ENV SNAP_HOME=/opt/snap
ENV PATH=${SNAP_HOME}/bin:${PATH}

# Download and install SNAP silently
RUN wget -O /tmp/snap-installer.sh "https://download.esa.int/step/snap/12.0/installers/esa-snap_all_linux-12.0.0.sh" && \
    bash /tmp/snap-installer.sh -q -dir ${SNAP_HOME} && \
    rm /tmp/snap-installer.sh
    echo "-Dsnap.userdir=/eodc/private/tempearth" >> ${SNAP_HOME}/bin/gpt.vmoptions


# Create auxdata directory and set permissions
#RUN mkdir -p ${SNAP_AUXDATA} && chmod -R 777 ${SNAP_AUXDATA}

# Set working directory for convenience
#WORKDIR /data

# Default command: run bash
CMD ["bash"]