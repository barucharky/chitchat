-- thread with the most posts
select   count(*) over (partition by posts.thread_id) most,
         threads.topic

from     posts
   inner join threads 
      on posts.thread_id = threads.id

ORDER BY most desc
limit 1
;

-- user with the most posts
select   count(*) over (partition by posts.thread_id) most,
         users.name

from     posts
   inner join users 
      on posts.user_id = users.id

ORDER BY most desc
limit 1