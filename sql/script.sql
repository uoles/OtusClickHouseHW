CREATE TABLE test_table
  (
    `id` UInt64,
    `column1` String
  )
ENGINE = MergeTree
ORDER BY id; 

INSERT INTO test_table (id, column1)
VALUES (1, 'test1'), (2, 'test2'), (3, 'test3'), (4, 'test4'), (5, 'test5');

SELECT * FROM test_table;

TRUNCATE TABLE test_table;

BACKUP TABLE test_table TO Disk('s3_plain', 'cloud_backup');

RESTORE TABLE test_table FROM Disk('s3_plain', 'cloud_backup');

-----------

CREATE TABLE test_table_2
  (
    `id` UInt64,
    `column1` String
  )
ENGINE = MergeTree
ORDER BY id; 

INSERT INTO test_table_2 (id, column1)
VALUES (1, 'test1'), (2, 'test2'), (3, 'test3'), (4, 'test4'), (5, 'test5'), (6, 'test6'), (7, 'test7');

SELECT * FROM test_table_2;

TRUNCATE TABLE test_table_2;

DROP TABLE test_table_2 SYNC