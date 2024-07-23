ARG PHOTON_CHANNEL=latest

FROM docker.io/photon:${PHOTON_CHANNEL}

# Set working environment up
WORKDIR /root

# Copy and run
COPY ./shared/etc/ /etc/
COPY ./shared/sh/ /root/gel/shared/sh
COPY ./etc/ /etc/
COPY ./sh/ /root/gel/distro/sh
RUN bash /root/gel/shared/sh/setup.sh
RUN bash /root/gel/distro/sh/setup.sh
RUN bash /root/gel/shared/sh/post.sh

# Run forever
EXPOSE 1122
CMD ["/sbin/init", "sshd", "-f", "/etc/ssh/sshd_config"]
#CMD ["sleep", "7d"]
