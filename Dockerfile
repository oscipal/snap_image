# Use Debian slim with OpenJDK 11
FROM openjdk:11-jre-slim

# Install required dependencies and Python 3
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip wget unzip fontconfig fonts-dejavu \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for SNAP
ENV SNAP_VERSION=12.0.0
ENV SNAP_HOME=/opt/snap
ENV PATH="${SNAP_HOME}/bin:${PATH}"
ENV JAVA_HOME=/usr/local/openjdk-11

# Download and silently install SNAP 12 headless
RUN wget -O /tmp/snap-installer.sh "https://step.esa.int/downloads/8.0/installers/snap-${SNAP_VERSION}-linux.sh" && \
    bash /tmp/snap-installer.sh -q -dir ${SNAP_HOME} && \
    rm /tmp/snap-installer.sh

# Set working directory
WORKDIR /usr/local/app

# Copy requirements and install Python packages
COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy your app source code
COPY . .

# Test SNAP install by printing GPT version (optional)
RUN gpt --version

# Default command (adjust as needed)
CMD ["bash"]
