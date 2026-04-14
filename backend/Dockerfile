FROM python:3.12-slim-bookworm

ENV PYTHONPATH="/app" \
    PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-17-jre-headless \
    procps \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# We use pip to install from pyproject.toml
COPY pyproject.toml .
RUN pip install .

COPY . .

# Default command for the backend service (could be sleep infinity for dev)
CMD ["/bin/bash", "scripts/run_etl_pipeline.sh"]
