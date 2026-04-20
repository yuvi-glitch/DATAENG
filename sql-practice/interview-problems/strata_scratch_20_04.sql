/*Calculate the friend acceptance rate for each date when friend requests were sent. A request is sent if action = sent and accepted if action = accepted. If a request is not accepted, there is no record of it being accepted in the table.
The output will only include dates where requests were sent and at least one of them was accepted (acceptance can occur on any date after the request is sent)*/
with a as(select *  from fb_friend_requests where action='accepted'),
b as(select *  from fb_friend_requests  where action='sent')
select b.date,count(a.user_id_receiver)/count(b.user_id_sender)
from a right join b on a.user_id_sender=b.user_id_sender
and a.user_id_receiver=b.user_id_receiver
group by date

/*Calculate each user's average session time, where a session is defined as the time difference between a page_load and a page_exit. Assume each user has only one session per day. If there are multiple page_load or page_exit events on the same day, use only the latest page_load and the earliest page_exit. 
Only consider sessions where the page_load occurs before the page_exit on the same day. Output the user_id and their average session time.*/
select 
user_id,
-- referred the case syntax 
max(case when action = 'page_load' then timestamp end ) as start,
max(case when action = 'page_exit' then timestamp end )  as end ,
max(case when action = 'page_load' then timestamp end ) -max(case when action = 'page_exit' then timestamp end )  as active_hrs
from facebook_web_log
-- where page_load > page_exit group by user_id;
