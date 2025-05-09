
select *
from system.parts
where table = 'user_activity'

select command, is_done
from system.mutations
where table = 'user_activity'


CREATE TABLE user_activity
(
    activity_date DateTime,
    user_id UInt32,
    activity_type LowCardinality(String)
)
ENGINE = MergeTree
PARTITION BY toYYYYMMDD(activity_date)
ORDER BY (activity_date);

select *
from user_activity

INSERT INTO user_activity
SELECT
	now() - toIntervalSecond(rand() % (365 * 24 * 60 * 60)) AS activity_date,
	randUniform(1,1000)::Int AS user_id,
	arrayElement(['login', 'logout', 'edit', 'delete'], randUniform(1,5)::Int) AS activity_type
FROM system.numbers
LIMIT 100;

SELECT arrayElement(['login', 'logout', 'edit', 'delete'], randUniform(1,5)::Int)


select count(1) as cnt, formatDateTime(activity_date, '%Y-%m-%d') as date
from user_activity
group by date
having cnt > 1
order by cnt desc;


select *
from user_activity
where formatDateTime(activity_date, '%Y-%m-%d') = '2024-06-01'



alter table user_activity
update activity_type = 'edit'
where formatDateTime(activity_date, '%Y-%m-%d') = '2024-06-01'
 	and activity_type = 'login'


select *
from system.parts
where table = 'user_activity' and partition like '202405%'

ALTER TABLE user_activity DROP PARTITION '20240511';
ALTER TABLE user_activity DROP PARTITION '20240514';
ALTER TABLE user_activity DROP PARTITION '20240515';
ALTER TABLE user_activity DROP PARTITION '20240516';

ALTER TABLE user_activity DROP PARTITION '20240517';
ALTER TABLE user_activity DROP PARTITION '20240525';
ALTER TABLE user_activity DROP PARTITION '20240527';
ALTER TABLE user_activity DROP PARTITION '20240529';


select *
from user_activity
where formatDateTime(activity_date, '%Y-%m') = '2024-05'

----

select *
from system.parts
where table = 'user_activity' and partition like '202406%'

select *
from user_activity
where formatDateTime(activity_date, '%Y-%m') = '2024-06'
order by activity_date