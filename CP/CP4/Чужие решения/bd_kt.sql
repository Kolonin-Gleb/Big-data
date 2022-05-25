select * from source_data;

create table car as
select 
    source_data.car_id,
    replace(source_data.price, ' ?', '') as price,
    replace(REGEXP_SUBSTR(source_data.engine_id, '.* ë'),' ë', '')as volume,
    replace(REGEXP_SUBSTR(source_data.engine_id, '. \d+'),'/ ', '')as horsepower,
    fuel.fuel_id,
    transmission.transmission_id,
    body.body_id,
    drive.drive_id,
    replace(source_data.price, ' ?', '') as mileage,
    wheel.wheel_id,
    state.state_id,
    customs.customs_id,
    source_data.color,
    source_data.release_year
from source_data, fuel, transmission, body, drive, wheel, state, customs
where 
    replace(REGEXP_SUBSTR(source_data.engine_id, '. \D+$'),'. / ', '') = fuel.fuel_name and
    source_data.transmission_id =TRANSMISSION.TRANSMISSION_name and
    source_data.body_id = body.body_name and
    source_data.drive_id = drive.drive_name and
    source_data.wheel_id = wheel.wheel_name and
    source_data.state_id = state.state_name and
    source_data.customs_id = customs.customs_name;

create table fuel as
select
    row_number() over(order by engine_id) as fuel_id,
    replace(REGEXP_SUBSTR(engine_id, '. \D+$'),'. / ', '') as fuel_name
from source_data;

create table transmission as
select
    row_number() over(order by transmission_id) as transmission_id,
    transmission_id as transmission_name
from source_data
GROUP BY transmission_id;

create table body as
select
    row_number() over(order by body_id) as body_id,
    body_id as body_name
from source_data
GROUP BY body_id;

create table drive as
select
    row_number() over(order by drive_id) as drive_id,
    drive_id as drive_name
from source_data
GROUP BY drive_id;

create table wheel as
select
    row_number() over(order by wheel_id) as wheel_id,
    wheel_id as wheel_name
from source_data
GROUP BY wheel_id;

create table state as
select
    row_number() over(order by state_id) as state_id,
    state_id as state_name
from source_data
GROUP BY state_id;

create table customs as
select
    row_number() over(order by customs_id) as customs_id,
    customs_id as customs_name
from source_data
GROUP BY customs_id;

create view car_by_years as
select
    COUNT(car_id) as count_of_car,
    release_year
from car
GROUP BY release_year
order by release_year;
