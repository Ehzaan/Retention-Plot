-- Database: Retention Plot

-- DROP DATABASE IF EXISTS "Retention Plot";

CREATE DATABASE "Retention Plot"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_India.1252'
    LC_CTYPE = 'English_India.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
	drop table if exists orders;
create table orders(
id int not null,
userId int  not null,
total int not null,
created timestamp)

select * from orders

drop table if exists grouped_orders;
create table grouped_orders as 
( select userid, date(created) as new_Date from orders
  order by 1,2)

select * from grouped_orders

drop table if exists week_start;
create table week_start as 
( select userid,date(date_trunc('week',created)) as week_start from orders
 order by 1)

select * from week_start

drop table if exists min_week;
create table min_week as
(select userid,min(week_start) as week_joined from week_start
 group by userid
order by 1)
 
 select * from min_week
 
 drop table if exists final;
 create table final as
 ( select *,(new_date-week_joined)/7 as week_diff from grouped_orders 
   join min_week
    using(userid)
    )

select week_joined,
count(distinct case when week_diff = 0 then userid end) as week0,
count(distinct case when week_diff = 1 then userid end) as week1,
count(distinct case when week_diff = 2 then userid end) as week2,
count(distinct case when week_diff = 3 then userid end) as week3,
count(distinct case when week_diff = 4 then userid end) as week4,
count(distinct case when week_diff = 5 then userid end) as week5,
count(distinct case when week_diff = 6 then userid end) as week6,
count(distinct case when week_diff = 7 then userid end) as week7,
count(distinct case when week_diff = 8 then userid end) as week8,
count(distinct case when week_diff = 9 then userid end) as week9,
count(distinct case when week_diff = 10 then userid end) as week10 from final
group by week_joined
order by 1
 
