FROM mhongshan/centos

ENV REDIS_VERSION=5.0.8

ADD ./docker-entrypoint.sh /work

RUN groupadd -r -g 1000 redis \
    && useradd -r -g redis -u 1000 redis \
    && wget -4 -O /tmp/redis-${REDIS_VERSION}.tar.gz "http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz" \
    && tar xzf /tmp/redis-${REDIS_VERSION}.tar.gz -C /tmp \
    && pushd /tmp/redis-${REDIS_VERSION} > /dev/null \
    && sed -ri 's!^(#define CONFIG_DEFAULT_PROTECTED_MODE) 1$!\1 0!' ./src/server.h \
    && make -j $(nproc) && make install \
    && mv redis.conf /etc/redis.conf \
    && popd >/dev/null \
    && sed -i 's@pidfile.*@pidfile /var/run/redis/redis.pid@' /etc/redis.conf \
    && sed -i "s@logfile.*@logfile /data/logs/redis.log@" /etc/redis.conf \
    && sed -i "s@^dir.*@dir /data/db@" /etc/redis.conf \
    && sed -i "s@^# bind 127.0.0.1@bind 127.0.0.1@" /etc/redis.conf \
    && Mem=$(free -m | awk '/Mem:/{print $2}') \
    && redis_maxmemory=`expr ${Mem} / 8`000000 \
    && [ -z "`grep ^maxmemory /etc/redis.conf`" ] && sed -i "s@maxmemory <bytes>@maxmemory <bytes>\nmaxmemory `expr ${Mem} / 8`000000@" /etc/redis.conf \
    && mkdir -p /work/logs && chown redis:redis -R /work/logs \
    && mkdir -p /work/data && chown redis:redis -R /work/data \
    && mkdir -p /var/run/redis && chown redis:redis -R /var/run/redis \
    && mv /work/docker-entrypoint.sh /usr/bin/docker-entrypoint && chmod +x /usr/bin/docker-entrypoint

EXPOSE 6379

ENTRYPOINT ["docker-entrypoint"]

VOLUME ["/work/logs", "/work/data"]

CMD ["redis-server", "/etc/redis.conf", "--daemonize", "no"]