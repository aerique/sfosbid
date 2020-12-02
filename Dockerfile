FROM scratch

ADD downloads/Jolla-latest-SailfishOS_Platform_SDK_Chroot-i486.tar.bz2 /

RUN useradd nemo
RUN echo "nemo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Appending to the existing file would be nicer, but would also end up after
# having sourced the global profile.
COPY dot-bashrc-root /root/.bashrc
COPY dot-bashrc-nemo /home/nemo/.bashrc

COPY downloads/Sailfish_OS-latest-Sailfish_SDK_Tooling-i486.tar.7z /
COPY downloads/Sailfish_OS-latest-Sailfish_SDK_Target-i486.tar.7z /
COPY downloads/Sailfish_OS-latest-Sailfish_SDK_Target-armv7hl.tar.7z /
COPY downloads/Sailfish_OS-latest-Sailfish_SDK_Target-aarch64.tar.7z /

RUN su nemo -c "sdk-assistant -y create SailfishOS-latest Sailfish_OS-latest-Sailfish_SDK_Tooling-i486.tar.7z"
RUN su nemo -c "sdk-assistant -y create SailfishOS-latest-i486 Sailfish_OS-latest-Sailfish_SDK_Target-i486.tar.7z"
RUN su nemo -c "sdk-assistant -y create SailfishOS-latest-armv7hl Sailfish_OS-latest-Sailfish_SDK_Target-armv7hl.tar.7z"
RUN su nemo -c "sdk-assistant -y create SailfishOS-latest-aarch64 Sailfish_OS-latest-Sailfish_SDK_Target-aarch64.tar.7z"

RUN rm /Sailfish_OS-latest-Sailfish_SDK_Tooling-i486.tar.7z
RUN rm /Sailfish_OS-latest-Sailfish_SDK_Target-i486.tar.7z
RUN rm /Sailfish_OS-latest-Sailfish_SDK_Target-armv7hl.tar.7z
RUN rm /Sailfish_OS-latest-Sailfish_SDK_Target-aarch64.tar.7z

CMD cd /home/nemo && sudo -u nemo /bin/bash -l
