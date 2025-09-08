FROM ubuntu:22.04

# Preparing
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends bash locales cmake build-essential libboost-dev libxml2-dev python3.11 python3.11-dev unzip apt-transport-https ca-certificates git libgtk-3-0 libxxf86vm1 libsm6 tzdata libpcsclite1 pcscd

SHELL ["/bin/bash", "-c"]

# Install Russian locales
RUN echo "ru_RU.UTF-8" >> /etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    locale-gen "ru_RU.UTF-8" && \
    update-locale LANG=ru_RU.UTF-8

ENV LANG=ru_RU.UTF-8 \
    LANGUAGE=ru_RU:ru \
    LC_ALL=ru_RU.UTF-8

# Set Time Zone "Europe/Moscow"
ENV TZ="Europe/Moscow"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Cpyptopro install
ADD dist /tmp/src
ADD files /files

RUN cd /tmp/src && \
    tar -xf linux-amd64_deb.tgz && \
    linux-amd64_deb/install.sh lsb-cprocsp-devel && \
    dpkg -i linux-amd64_deb/lsb-cprocsp-base*.deb && \
    dpkg -i linux-amd64_deb/lsb-cprocsp-rdr-64*.deb && \
    dpkg -i linux-amd64_deb/lsb-cprocsp-kc1-64*.deb && \
    dpkg -i linux-amd64_deb/lsb-cprocsp-kc2-64*.deb && \
    dpkg -i linux-amd64_deb/lsb-cprocsp-capilite-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-gui-gtk-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-cptools-gtk-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-curl-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-pki-cades-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-pki-plugin-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-cloud-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-pcsc-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-cpfkc-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-cryptoki-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-edoc-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-emv-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-infocrypt-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-inpaspot-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-jacarta-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-kst-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-mskey-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-novacard-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-rosan-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-rustoken-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-rdr-rutoken-64*.deb && \
    dpkg -i linux-amd64_deb/cprocsp-stunnel-64*.deb && \
    dpkg -i linux-amd64_deb/lsb-cprocsp-ca-certs*.deb && \
    dpkg -i linux-amd64_deb/lsb-cprocsp-import-ca-certs*.deb && \
    dpkg -i linux-amd64_deb/lsb-cprocsp-pkcs11-64*.deb && \ 
    git clone https://github.com/CryptoPro/pycades.git pycades && \
    cd pycades && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j4 && \
    ls -la && \
    sleep 1 && \
    cp pycades.so /opt/cprocsp/lib/amd64/pycades.so && \
    echo 'export PYTHONPATH=/opt/cprocsp/lib/amd64/' >> ~/.bashrc && \
    source ~/.bashrc && \ 
    cd /bin && \
    ln -s /opt/cprocsp/bin/amd64/certmgr && \
    ln -s /opt/cprocsp/bin/amd64/cptools && \
    ln -s /opt/cprocsp/bin/amd64/cpverify && \
    ln -s /opt/cprocsp/bin/amd64/cryptcp && \
    ln -s /opt/cprocsp/bin/amd64/csptest && \
    ln -s /opt/cprocsp/bin/amd64/csptestf && \
    ln -s /opt/cprocsp/bin/amd64/der2xer && \
    ln -s /opt/cprocsp/bin/amd64/inittst && \
    ln -s /opt/cprocsp/bin/amd64/wipefile && \
    ln -s /opt/cprocsp/sbin/amd64/cpconfig && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 && \
    rm -rf /tmp/src 

RUN /opt/cprocsp/sbin/amd64/cryptsrv && sleep 10 && \
    # Чтобы установить свою лицензию указываем ее в строке ниже и раскоментируем ее && \
    #/opt/cprocsp/sbin/amd64/cpconfig -license -set 5050N-00000-00000-00000-00000 && \
    # Установка сертификата центра сертификации Крипто-Про. Сертификат предварительно необходимо положить в директорию files && \
    /opt/cprocsp/bin/amd64/certmgr -inst -cert  -store mroot -file /files/certnew.cer -all &&\
    # Установка сертификата ЭЦП. Сертификат предварительно необходимо положить в директорию files/ЭЦП && \
    /opt/cprocsp/bin/amd64/certmgr -install -pfx -file /files/ЭЦП/certificate.pfx -pin 12345 -newpin 12345

