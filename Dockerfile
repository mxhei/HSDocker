FROM centos:7

RUN pkgList="wget gcc gcc-c++ make cmake autoconf glibc glibc-devel bzip2 bzip2-devel readline-devel openssl openssl-devel libevent-devel vim zip unzip net-tools telnet" \
    && yum install -y ${pkgList} \
# install Jemalloc
    && wget -4 -O /tmp/jemalloc-5.2.1.tar.bz2 http://mirrors.linuxeye.com/oneinstack/src/jemalloc-5.2.1.tar.bz2 \
    && tar xjf /tmp/jemalloc-5.2.1.tar.bz2  -C /tmp \
    && pushd /tmp/jemalloc-5.2.1 > /dev/null \
    && ./configure && make -j $(nproc) && make install \
    && ln -s /usr/local/lib/libjemalloc.so.2 /usr/lib64/libjemalloc.so.1 \
    && ln -s /usr/local/lib/libjemalloc.so.2 /usr/lib/libjemalloc.so.1 \
    && popd >/dev/null \
    && ldconfig && rm -rf /tmp/jemalloc* \
# install gosu
    && wget -4 -O /usr/bin/gosu "https://github.com/tianon/gosu/releases/download/1.12/gosu-amd64" \
    && wget -4 -O /tmp/gosu.asc "https://github.com/tianon/gosu/releases/download/1.12/gosu-amd64.asc" \
    && gpg --keyserver keyserver.ubuntu.com --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /tmp/gosu.asc /usr/bin/gosu && rm -rf /tmp/gosu.asc \
    && yum clean all

WORKDIR /work