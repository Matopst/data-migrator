# Use a slim and secure base image
FROM debian:bookworm-slim

# Metadata (optional)
LABEL purpose="PostgreSQL PVC migration and validation"

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        rsync \
        coreutils \
        findutils \
        bash \
        ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the validation script into the container
COPY validate-copy.sh /usr/local/bin/validate-copy.sh

# Make the script executable
RUN chmod +x /usr/local/bin/validate-copy.sh

# Default command
CMD ["/usr/local/bin/validate-copy.sh"]
