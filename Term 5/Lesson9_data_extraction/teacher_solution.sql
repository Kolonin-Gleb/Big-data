-- log
create table p3.tigr_log as 
with log as                                                                                                                                      
(                                                                                                                                                
    select                                                                                                                                       
        to_date(substr(data, strpos(data, chr(9))+3, 14), 'YYYYMMDDHH24MISS') as dt,                                                             
        substr(substr(data, strpos(data, 'http:')), 0, strpos(substr(data, strpos(data, 'http:')),chr(9)))  as link,
        replace(
            substr(
                substr(substr(data, strpos(data, 'http:')), strpos(substr(data, strpos(data, 'http:')),chr(9))+6),
                strpos(substr(substr(data, strpos(data, 'http:')), strpos(substr(data, strpos(data, 'http:')),chr(9))+6), chr(9))
                ), chr(9),'')  as user_agent,
        substr(data, 0, strpos(data,chr(9)))  as ip
    from de.log                                                                                                                                  
), regions as (
    select                                                                                                                                       
        substr(data, 1, strpos(data, chr(9))-1) as ip,                                                                                           
        trim(substr(data, strpos(data, chr(9))+1)) as region                                                                                     
    from de.ip  
)                                                                                                                                               
select 
    t1.dt,
    t1.link,
    t1.user_agent,
    t2.region
from log t1
left join regions t2
on t1.ip = t2.ip;                                                                                                                               
-- log report
create table p3.tigr_log_report as
with report as (
    select
        region,
        max(cnt) as max
    from (
        select  
            region,
            substr(user_agent, 1, strpos(user_agent, '/')-1) as browser,
            count(*) as cnt 
        from p3.tigr_log
        group by region, substr(user_agent, 1, strpos(user_agent, '/')-1)
    ) t1
    group by region
)
select 
    t2.region,
    max(browser) as browser 
from (
    select 
        region,
        substr(user_agent, 1, strpos(user_agent, '/')-1) as browser,
        count(*) as cnt 
    from p3.tigr_log
    group by region, substr(user_agent, 1, strpos(user_agent, '/')-1)
) t2
inner join report t1
on t1.region = t2.region
where t2.cnt = t1.max
group by t2.region