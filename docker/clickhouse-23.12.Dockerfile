FROM clickhouse/clickhouse-server:23.12
MAINTAINER Maksim Kulikov <max.uoles@rambler.ru>

RUN apt-get -qq update
RUN apt-get install nano python3 pip -y
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install mc
RUN pip install clickhouse_driver

COPY clickhouse/config.xml /etc/clickhouse-server/config.d/config.xml

COPY clickhouse/user_scripts/transaction_state.py /var/lib/clickhouse/user_scripts/transaction_state.py
COPY clickhouse/user_scripts/transaction_sum.py /var/lib/clickhouse/user_scripts/transaction_sum.py

COPY clickhouse/transaction_state.xml /etc/clickhouse-server/transaction_state.xml
COPY clickhouse/transaction_sum.xml /etc/clickhouse-server/transaction_sum.xml

RUN ["chmod", "+x", "/var/lib/clickhouse/user_scripts/transaction_state.py"]
RUN ["chmod", "+x", "/var/lib/clickhouse/user_scripts/transaction_sum.py"]

EXPOSE 8123 9000

ENTRYPOINT ["/entrypoint.sh"]