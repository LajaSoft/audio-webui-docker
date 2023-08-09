# Build Stage
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 as build

# Set the working directory in the container
WORKDIR /app

# Install dependencies
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y \
    python3 python3-pip python3-dev python3-venv build-essential wget unzip git ffmpeg \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install --upgrade setuptools wheel \
    && wget https://github.com/gitmylo/audio-webui/releases/download/Installers/audio-webui.zip \
    && unzip audio-webui.zip \
    && bash /app/install_linux_macos.sh

# Production Stage
FROM nvidia/cuda:11.8.0-runtime-ubuntu22.04 as production

# Create a non-root user with home directory /app
RUN useradd --create-home --home-dir /app appuser

# Switch to the non-root user
USER appuser

# Set the working directory in the container
WORKDIR /app

# Copy necessary files and binaries from the build stage
COPY --from=build /app /app
COPY ./.env /app
COPY ./run.sh /app

ENTRYPOINT ["/app/run.sh"]
