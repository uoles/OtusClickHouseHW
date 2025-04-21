CREATE TABLE kafka_test
(
    message String
)
ENGINE = MergeTree 
ORDER BY message;


CREATE TABLE kafka_test_queue
(
    message String
)
ENGINE = Kafka
SETTINGS 
    kafka_broker_list = 'kafka:9092', 
    kafka_topic_list = 'test_clickhouse_topic', 
    kafka_group_name = 'test_group', 
    kafka_format = 'CSV', 
    kafka_num_consumers = 1, 
    kafka_skip_broken_messages = 10,
    kafka_thread_per_consumer = 0;

CREATE MATERIALIZED VIEW kafka_test_queue_mv TO kafka_test 
( 
    message String 
) AS SELECT message FROM kafka_test_queue;


select *
from kafka_test_queue_mv