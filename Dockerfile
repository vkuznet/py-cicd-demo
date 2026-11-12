
# syntax=docker/dockerfile:1
#
# py-cicd-demo container image
# Base   : debian:bookworm-slim
# Packs  : python3, pip, and requirements.txt dependencies
#
# Built multi-arch (linux/amd64, linux/arm64) by .github/workflows/containers.yml
# and pushed to Docker Hub and GitHub Container Registry (GHCR).

FROM debian:bookworm-slim

# Avoid interactive prompts and pyc noise during build
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# --- OS packages -------------------------------------------------------
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
    && rm -rf /var/lib/apt/lists/*

# --- Application -------------------------------------------------------
WORKDIR /app

# Create an unprivileged user
RUN useradd --create-home --shell /usr/sbin/nologin appuser

# Install only dependencies explicitly declared in requirements.txt.
# An empty requirements.txt is perfectly valid.
COPY requirements.txt ./

RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && if [ -s requirements.txt ]; then \
           /opt/venv/bin/pip install -r requirements.txt; \
       fi

ENV PATH="/opt/venv/bin:${PATH}"

COPY hello.py ./

RUN chown -R appuser:appuser /app

USER appuser

ENTRYPOINT ["python3", "hello.py"]
CMD ["World"]

# --- OCI labels --------------------------------------------------------
LABEL org.opencontainers.image.title="py-cicd-demo" \
      org.opencontainers.image.description="Minimal Python demo application with optional dependencies" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.source="https://github.com/vkuznet/py-cicd-demo"
