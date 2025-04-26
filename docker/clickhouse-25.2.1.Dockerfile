FROM clickhouse/clickhouse-server:25.2.1
MAINTAINER Maksim Kulikov <max.uoles@rambler.ru>

RUN apt-get update -y --fix-missing 
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade
RUN apt-get install nano mc python3 pip kafkacat -y
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