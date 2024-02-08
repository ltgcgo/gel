FROM docker.io/opensuse/tumbleweed

# Set working environment up
WORKDIR /root

# Copy and run
COPY ./shared/etc/ /etc/
COPY ./shared/sh/ /root/gel/shared/sh
COPY ./etc/ /etc/
COPY ./sh/ /root/gel/distro/sh
RUN bash /root/gel/distro/sh/init.sh
RUN bash /root/gel/shared/sh/setup.sh
RUN bash /root/gel/distro/sh/setup.sh
RUN bash /root/gel/shared/sh/post.sh

# Run forever
EXPOSE 1122
CMD ["/sbin/init"]
#CMD ["sleep", "infinity"]