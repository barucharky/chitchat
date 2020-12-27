
select   *
from     newsletters
;


-- INSERT
insert into newsletters
       (
       uuid,
       name,
       created_at    
       )
       values
       (
       uuid_generate_v1(),
       'Arky News',
       current_timestamp   
       )
;       



CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- UPDATE
update newsletters
   set name       = 'Hacker News',
       created_at = current_timestamp
where  id = 2
;

update newsletters
   set enabled = FALSE
where id = 2
;



-- DELETE
delete from newsletters
where  lower(name) like 'h%'
;


select *
from   users
;

update users
   set password = 'a94a8fe5ccb19ba61c4c0873d391e987982fbbd3'
where id = 1;