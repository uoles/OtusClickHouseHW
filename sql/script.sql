CREATE DATABASE uk;

CREATE TABLE uk.uk_price_paid
(
    price UInt32,
    date Date,
    postcode1 LowCardinality(String),
    postcode2 LowCardinality(String),
    type Enum8('terraced' = 1, 'semi-detached' = 2, 'detached' = 3, 'flat' = 4, 'other' = 0),
    is_new UInt8,
    duration Enum8('freehold' = 1, 'leasehold' = 2, 'unknown' = 0),
    addr1 String,
    addr2 String,
    street LowCardinality(String),
    locality LowCardinality(String),
    town LowCardinality(String),
    district LowCardinality(String),
    county LowCardinality(String)
)
ENGINE = MergeTree
ORDER BY (postcode1, postcode2, addr1, addr2);


INSERT INTO uk.uk_price_paid
SELECT
    toUInt32(price_string) AS price,
    parseDateTimeBestEffortUS(time) AS date,
    splitByChar(' ', postcode)[1] AS postcode1,
    splitByChar(' ', postcode)[2] AS postcode2,
    transform(a, ['T', 'S', 'D', 'F', 'O'], ['terraced', 'semi-detached', 'detached', 'flat', 'other']) AS type,
    b = 'Y' AS is_new,
    transform(c, ['F', 'L', 'U'], ['freehold', 'leasehold', 'unknown']) AS duration,
    addr1,
    addr2,
    street,
    locality,
    town,
    district,
    county
FROM url(
    'http://prod.publicdata.landregistry.gov.uk.s3-website-eu-west-1.amazonaws.com/pp-monthly-update-new-version.csv',
    'CSV',
    'uuid_string String,
    price_string String,
    time String,
    postcode String,
    a String,
    b String,
    c String,
    addr1 String,
    addr2 String,
    street String,
    locality String,
    town String,
    district String,
    county String,
    d String,
    e String'
) SETTINGS max_http_get_redirects=10;


SELECT count(*)
FROM uk.uk_price_paid



SELECT
   toYear(date) AS year,
   round(avg(price)) AS price,
   bar(price, 0, 1000000, 80)
FROM uk.uk_price_paid
GROUP BY year
ORDER BY year



select year, cntPrice, round(avgPrice) AS roundAvgPrice, bar(roundAvgPrice, 0, 1000000, 80)
from (
	SELECT toYear(date) AS year, count(price) as cntPrice, avg(price) as avgPrice
	FROM uk.uk_price_paid
	GROUP BY year
	ORDER BY year	
)


select year, cntPrice, round(avgPrice) AS roundAvgPrice, bar(roundAvgPrice, 0, 1000000, 80) as bar
from (
	SELECT toYear(date) AS year, count(price) as cntPrice, avg(price) as avgPrice
	FROM uk.uk_price_paid
	GROUP BY year
	ORDER BY year	
)





select count(price) cnt, town
from uk.uk_price_paid
where price in (4440000, 155000, 587500, 100000, 25000, 172500, 2350000, 190000, 468000)
GROUP BY cnt, town
ORDER BY cnt desc


select count(price) cnt, 
	price,
	town,
	(select count(price) from uk.uk_price_paid) cntTotal,
	 cnt / cntTotal * 100
from uk.uk_price_paid
GROUP BY price, town
ORDER BY cnt desc


select count(price) cnt, 
	price,
	town,
	(select count(price) from uk.uk_price_paid) cntTotal,
	round((cnt / cntTotal) * 100, 6) AS perc
from uk.uk_price_paid
GROUP BY price, town
ORDER BY cnt desc
limit 1000


select 
	count(*) cnt, 
	price,
	town,
from uk.uk_price_paid
where town in ('LONDON','SOUTHALL')
GROUP BY price, town
ORDER BY cnt desc
