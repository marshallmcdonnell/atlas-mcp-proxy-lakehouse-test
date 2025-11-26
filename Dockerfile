FROM ghcr.io/sparfenyuk/mcp-proxy:v0.10.0

# Setup python + uv (need for uvx)
ENV PYTHONUNBUFFERED=1
RUN ln -sf python3 /usr/bin/python \
    && python -m ensurepip \
    && python -m pip install --no-cache --upgrade \
        pip \
        setuptools \
        uv

# Install `curl` (image is Alpine-based and uses `apk`).
RUN apk add --no-cache curl
