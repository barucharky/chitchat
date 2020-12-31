select   *
from     posts
order by created_at
;

select   *
from     threads
order by created_at
;

with
date_stuff as
(
select   cast('2020-02-23 12:00:00' as date) dt
)

select   dt,
         dt + 1
from     date_stuff
;