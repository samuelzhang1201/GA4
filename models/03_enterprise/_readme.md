Based on my inspection and data fact, I observed the following fact:

one user may have multiple sessions,

one session contains multiple event bundle, 

one timestamp can only has one event bundle, 

one event bundle can have multiple events.

In enterprise layer, I keep all the information in a normalized structure, divding by different concepts.



-- verify there are multiple user_pseudo_id in one session
select 
ga_session_id
, count(distinct user_pseudo_id)
from dbttest-435106.enterprise.ga4_events
group by 1
having count(distinct user_pseudo_id)>1
limit 100;
![image](https://github.com/user-attachments/assets/e1fc214c-1f96-484b-a708-4407656dd36d)



--check one user with multiple pseudo id
select 
*
from dbttest-435106.enterprise.ga4_events
where 
ga_session_id = '5161330271'
order by event_timestamp;
![image](https://github.com/user-attachments/assets/3dec9172-84e4-4ab8-b759-a2f4a35c5994)

Based on result, I found that an user can have many pseudo_id across a day or a period, with differnt event_bundle_id in one session. One possible reason is that user got timeout and restart the session later, or using VPN or change device, etc.But anyway, this is ONE user!

So I use row_number function to make the very first pseudo_id as user's user_id to remove the noise.
--merged id
select * from dbttest-435106.enterprise.ga4_user_id_merged limit 100;
