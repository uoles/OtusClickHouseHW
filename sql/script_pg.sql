CREATE SCHEMA pgclick;

CREATE TABLE IF NOT EXISTS pgclick.valute_data(
	c_date VARCHAR(36) NOT NULL,
	c_name VARCHAR(200) NOT NULL,
	c_str_id VARCHAR(20) NOT NULL,
	c_num_code VARCHAR(20) NOT NULL,
	c_char_code VARCHAR(20) NOT NULL,
	c_nominal VARCHAR(20) NOT NULL,
	c_value VARCHAR(50) NOT NULL
)

CREATE UNIQUE INDEX idx_valute_data
ON pgclick.valute_data(c_date, c_str_id);

select *
from pgclick.valute_data
where c_str_id = 'R01770'
limit 200

