FROM scratch

ARG BUILD_USER=nemo
ARG BUILD_UID=100000
ARG BUILD_GID=100000
ENV ENV_BUILD_USER=$BUILD_USER

ADD downloads/Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2 /

RUN groupadd --gid $BUILD_GID $BUILD_USER
RUN useradd --gid $BUILD_GID --uid $BUILD_UID $BUILD_USER
RUN echo "$BUILD_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Appending to the existing file would be nicer, but would also end up after
# having sourced the global profile.
COPY config/dot-bashrc-root /root/.bashrc
COPY config/dot-bashrc-nemo /home/$BUILD_USER/.bashrc
RUN chown $BUILD_USER.$BUILD_USER /home/$BUILD_USER/.bashrc

COPY downloads/Sailfish_OS-latest-Sailfish_SDK_Tooling-i486.tar.7z /
COPY downloads/Sailfish_OS-latest-Sailfish_SDK_Target-i486.tar.7z /
COPY downloads/Sailfish_OS-latest-Sailfish_SDK_Target-armv7hl.tar.7z /
COPY downloads/Sailfish_OS-latest-Sailfish_SDK_Target-aarch64.tar.7z /

RUN su $BUILD_USER -c "sdk-assistant -y create SailfishOS-latest Sailfish_OS-latest-Sailfish_SDK_Tooling-i486.tar.7z"
RUN su $BUILD_USER -c "sdk-assistant -y create SailfishOS-latest-i486 Sailfish_OS-latest-Sailfish_SDK_Target-i486.tar.7z"
RUN su $BUILD_USER -c "sdk-assistant -y create SailfishOS-latest-armv7hl Sailfish_OS-latest-Sailfish_SDK_Target-armv7hl.tar.7z"
RUN su $BUILD_USER -c "sdk-assistant -y create SailfishOS-latest-aarch64 Sailfish_OS-latest-Sailfish_SDK_Target-aarch64.tar.7z"

RUN rm /Sailfish_OS-latest-Sailfish_SDK_Tooling-i486.tar.7z
RUN rm /Sailfish_OS-latest-Sailfish_SDK_Target-i486.tar.7z
RUN rm /Sailfish_OS-latest-Sailfish_SDK_Target-armv7hl.tar.7z
RUN rm /Sailfish_OS-latest-Sailfish_SDK_Target-aarch64.tar.7z

# `CMD` cannot access variables set by `ARG`. Tedious, since `ENV` cannot be
# assigned by `--build-arg`.
CMD cd /home/$ENV_BUILD_USER && sudo -u $ENV_BUILD_USER /bin/bash -l
