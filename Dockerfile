# Use Debian slim with OpenJDK 11
FROM openjdk:11-jre-slim

# Install required dependencies and Python 3 if needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip wget unzip fontconfig fonts-dejavu \
    libxext6 libxrender1 libxtst6 libxi6 libxrandr2 libxinerama1 libfreetype6 libfontconfig1 libxss1 libx11-6 \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV SNAP_VERSION=12.0.0
ENV SNAP_HOME=/opt/snap
ENV JAVA_HOME=/usr/local/openjdk-11
ENV PATH=${SNAP_HOME}/bin:$PATH

# Download and silently install SNAP 12
RUN wget -O /tmp/snap-installer.sh "https://step.esa.int/downloads/12.0/installers/snap-${SNAP_VERSION}-linux.sh" && \
    bash /tmp/snap-installer.sh -q -dir ${SNAP_HOME} && \
    rm /tmp/snap-installer.sh

# Set working directory
WORKDIR /usr/local/app

# Optionally copy your app code
# COPY . .

# Default command (adjust as needed)
CMD ["bash"]
