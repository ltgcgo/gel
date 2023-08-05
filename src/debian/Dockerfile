ARG DEBIAN_CHANNEL=stable

FROM docker.io/debian:${DEBIAN_CHANNEL}

# Set working environment up
WORKDIR /root

# Copy and run
COPY ./shared/etc/ /etc/
COPY ./shared/sh/ /root/sh/shared
COPY ./etc/ /etc/
COPY ./sh/ /root/sh/distro
RUN bash /root/sh/shared/setup.sh
RUN bash /root/sh/distro/setup.sh
RUN bash /root/sh/shared/post.sh

# Run forever
EXPOSE 1122
CMD ["/sbin/init"]
#CMD ["sleep", "infinity"]
