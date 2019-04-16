FROM ubuntu:16.04
ADD pack /var/www/html/pack
RUN set -x \
    && apt-get update \
    && apt-get -y install dpkg-dev apache2 \
    && cd /var/www/html && dpkg-scanpackages pack /dev/null | gzip >pack/Packages.gz
ADD pack /var/www/html/pack
COPY pause /pause
COPY start.sh /start.sh
CMD sh start.sh
