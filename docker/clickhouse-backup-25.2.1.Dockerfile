FROM clickhouse/clickhouse-server:25.2.1
MAINTAINER Maksim Kulikov <max.uoles@rambler.ru>

RUN apt-get update -y --fix-missing 
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade
RUN apt-get install nano mc python3 pip kafkacat -y
RUN pip install clickhouse_driver

RUN mkdir /tmp/clickhouse-backup \
	&& cd /tmp/clickhouse-backup \
	&& wget https://github.com/Altinity/clickhouse-backup/releases/download/v2.6.16/clickhouse-backup-linux-amd64.tar.gz \
	&& tar -xf clickhouse-backup-linux-amd64.tar.gz \
	&& install -o root -g root -m 0755 build/linux/amd64/clickhouse-backup /usr/local/bin \
    && mkdir /etc/clickhouse-backup

COPY clickhouse/clickhouse-backup/config.yml /etc/clickhouse-backup/config.yml

EXPOSE 8123 9000

ENTRYPOINT ["/entrypoint.sh"]