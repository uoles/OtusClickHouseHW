

SHOW USERS

SELECT name,
	auth_type,
	auth_params
FROM system.users 
WHERE storage = 'local_directory'

SELECT *
FROM system.roles

SELECT *
FROM system.role_grants

SELECT *
FROM system.grants
WHERE user_name = 'jhon'

----

CREATE USER test_user IDENTIFIED WITH sha256_password BY 'test_password'

DROP USER test_user

----

CREATE USER jhon IDENTIFIED WITH sha256_password BY 'qwerty'

CREATE ROLE devs;

GRANT devs TO jhon;

REVOKE devs FROM jhon;

GRANT SELECT ON my_database.* TO devs;

----

SELECT 
  grants.user_name,
  grants.role_name,
  users.name AS role_member,
  grants.access_type,
  grants.database,
  grants.table
FROM system.grants 
LEFT JOIN system.role_grants ON grants.role_name = role_grants.granted_role_name
LEFT JOIN system.users ON role_grants.user_name = users.name
WHERE users.name = 'jhon'
  

