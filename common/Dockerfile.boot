ENV BOOT_VERSION=2.7.2
ENV BOOT_INSTALL=/usr/local/bin/
ENV BOOT_CHECKSUM=f717ef381f2863a4cad47bf0dcc61e923b3d2afb
ENV PATH=$PATH:$BOOT_INSTALL
ENV BOOT_AS_ROOT yes
ENV BOOT_HOME=/root/.boot

RUN apt-get update -y && \
    apt-get install -y wget gnupg && \
    wget -q https://github.com/boot-clj/boot-bin/releases/download/$BOOT_VERSION/boot.sh && \
    echo "Comparing boot.sh checksum ..." && \
    echo "$BOOT_CHECKSUM boot.sh" | sha1sum -c - && \
    mv boot.sh $BOOT_INSTALL/boot && \
    chmod 0755 $BOOT_INSTALL/boot && \
    boot && \
    apt-get remove -y wget gnupg && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*


