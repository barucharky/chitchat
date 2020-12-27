-- I didn't do it this way because I'd need another step to add the topic
select   thread_id,
         count(*)

from     posts
   inner join threads
      on posts.thread_id = threads.id

group by posts.thread_id
order by 2 desc
limit 1
;

-- thread with the most posts
with
step_01 as

(
select   distinct count(*) over (partition by posts.thread_id) most,
         threads.topic topic

from     posts
   inner join threads 
      on posts.thread_id = threads.id

ORDER BY most desc
),

step_02 as
(
select   topic,
         most,
         dense_rank() over (order by most desc) most_rank
from     step_01
)

select   topic,
         most
from     step_02
where    most_rank < 3
order by most desc
;

-- user with the most posts
select   count(*) over (partition by posts.thread_id) most,
         users.name

from     posts
   inner join users 
      on posts.user_id = users.id

ORDER BY most desc
limit 1
;

