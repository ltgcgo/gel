FROM docker.io/debian/tumbleweed

# Set working environment up
WORKDIR /root

# Copy and run shared files
COPY ./shared/etc/ /etc/
COPY ./shared/sh/ /root/sh/shared
RUN bash /root/sh/shared/setup.sh

# Copy and run distro-specific files
COPY ./etc/ /etc/
COPY ./sh/ /root/sh/distro
RUN bash /root/sh/distro/setup.sh

# Run forever
EXPOSE 1122
CMD ["/sbin/init"]