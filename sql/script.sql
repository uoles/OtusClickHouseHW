CREATE TABLE my_database.transactions (
	transaction_id UInt32,
	user_id UInt32,
	product_id UInt32,
	quantity UInt8,
	price Float32,
	transaction_date Date
) ENGINE = MergeTree()
ORDER BY (transaction_id);

INSERT INTO my_database.transactions 
SELECT
    --floor(randNormal(100000000, 1000000)),
	100000000 + number,
    randNormal(10000, 500),
    randNormal(1000, 200),
	randNormal(50, 20),
	round(randNormal(1000, 5), 2),
	now() - randUniform(1, 1000000.)
FROM numbers(1000000);

truncate table my_database.transactions

select *
from my_database.transactions

----------------

-- Рассчитайте общий доход от всех операций.
select sum(price) 
from my_database.transactions

-- Найдите средний доход с одной сделки.
select avg(price / quantity), transaction_id
from my_database.transactions
group by transaction_id

-- Определите общее количество проданной продукции.
select sum(quantity)
from my_database.transactions

-- Подсчитайте количество уникальных пользователей, совершивших покупку.
select count(distinct user_id)
from my_database.transactions

----------------

-- Преобразуйте `transaction_date` в строку формата `YYYY-MM-DD`.
select formatDateTime(transaction_date, '%Y-%m-%d') as NewDateTime, transaction_date
from my_database.transactions

select formatDateTime(now(), '%Y-%m-%d %H:%M:%S')



-- Извлеките год и месяц из `transaction_date`.
select toYear(transaction_date) AS Year, 
	toMonth(transaction_date) AS Month,
	transaction_date
from my_database.transactions

SELECT toDateTime('2021-04-21 10:20:30', 'Europe/Moscow') AS Time

SELECT toYear(now())

SELECT toMonth(now())


-- Округлите `price` до ближайшего целого числа.
select round(price, 0), price
from my_database.transactions

SELECT round(123.4, 0) as res;

SELECT round(123.5, 0) as res;



-- Преобразуйте `transaction_id` в строку.
select toString(transaction_id), transaction_id
from my_database.transactions


----------------

SYSTEM RELOAD FUNCTIONS; 

SELECT name, origin 
FROM system.functions 
WHERE name in ('transaction_state', 'transaction_sum');


select transaction_id, price, quantity, transaction_sum(price, quantity)
from my_database.transactions 
where transaction_id = 100511426

select 
 	transaction_id, 
 	price, 
 	quantity, 
 	transaction_sum(price, quantity), 
 	transaction_state(price, quantity, 50000)
from my_database.transactions 
where transaction_id = 100511426


select 
	count(1) cnt,
 	transaction_id
from my_database.transactions 
group by transaction_id
having cnt > 1

