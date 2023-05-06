ARG DEBIAN_CHANNEL=testing

FROM docker.io/debian:${DEBIAN_CHANNEL}

# Set working environment up
WORKDIR /root

# Copy and run shared files
RUN bash /root/sh/shared/setup.sh

# Copy and run distro-specific files
RUN bash /root/sh/distro/setup.sh

# Run forever
CMD ["bash"]