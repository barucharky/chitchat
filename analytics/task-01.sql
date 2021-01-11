select   *
from     threads
order by created_at
;


-- ------------------
-- getting threads by hour

with
string as
(
select   created_at::text created_string
from     threads
order by created_at
),

date_hour as
(
select   created_string,
         -- -----------
         substr(created_string, 0, 11) just_date,
         substr(created_string, 12, 2) just_hour

from     string
)

select   just_date,
         just_hour,
         count(*)
from     date_hour
group by just_date, just_hour
order by 1, 2
;

-- --------------------
-- getting posts by hour
with
string as
(
select   created_at::text created_string
from     posts
order by created_at
),

date_hour as
(
select   created_string,
         -- -----------
         substr(created_string, 0, 11) just_date,
         substr(created_string, 12, 2) just_hour

from     string
),

pph as
(
select   just_date,
         just_hour,
         count(*) posts
from     date_hour
group by just_date, just_hour
order by 1, 2
),

-- --------------------
-- datetime table
 
cal_date as
(
select   '2020-12-01' the_date union all
select   '2020-12-02' the_date union all
select   '2020-12-03' the_date union all
select   '2020-12-04' the_date union all
select   '2020-12-05' the_date union all
select   '2020-12-06' the_date union all
select   '2020-12-07' the_date union all
select   '2020-12-08' the_date union all
select   '2020-12-09' the_date union all
select   '2020-12-10' the_date union all
select   '2020-12-11' the_date union all
select   '2020-12-12' the_date union all
select   '2020-12-13' the_date union all
select   '2020-12-14' the_date union all
select   '2020-12-15' the_date union all
select   '2020-12-16' the_date union all
select   '2020-12-17' the_date union all
select   '2020-12-18' the_date union all
select   '2020-12-19' the_date union all
select   '2020-12-20' the_date union all
select   '2020-12-21' the_date union all
select   '2020-12-22' the_date union all
select   '2020-12-23' the_date union all
select   '2020-12-24' the_date union all
select   '2020-12-25' the_date union all
select   '2020-12-26' the_date union all
select   '2020-12-27' the_date union all
select   '2020-12-28' the_date union all
select   '2020-12-29' the_date union all
select   '2020-12-30' the_date
),

cal_hour as
(
select '00' the_hour union all
select '01' the_hour union all
select '02' the_hour union all
select '03' the_hour union all
select '04' the_hour union all
select '05' the_hour union all
select '06' the_hour union all
select '07' the_hour union all
select '08' the_hour union all
select '09' the_hour union all
select '10' the_hour union all
select '11' the_hour union all
select '12' the_hour union all
select '13' the_hour union all
select '14' the_hour union all
select '15' the_hour union all
select '16' the_hour union all
select '17' the_hour union all
select '18' the_hour union all
select '19' the_hour union all
select '20' the_hour union all
select '21' the_hour union all
select '22' the_hour union all
select '23' the_hour 
),

calendar as
(
select   *
from     cal_date
   cross join cal_hour
order by 1, 2
)

select   cal.the_date,
         cal.the_hour,
         pph.posts
from     calendar cal
    left join pph
      on cal.the_date = pph.just_date and cal.the_hour = pph.just_hour

;




