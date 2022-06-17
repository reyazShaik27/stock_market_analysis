#Creating a database for Assignment
create database assignment;

#Selecting the database for Quering 
use assignment;

#Import tables from datasets provided

#Describing the data types of variables in the respective company table's
desc bajaj_auto;
desc eicher_motors;
desc hero_motocorp;
desc infosys;
desc tcs;
desc tvs_motors;

#Creating temporary tables to convert date variable to date format so that it could be sorted and fetch 'Close Price'

create table bajajtemp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from bajaj_auto; 
create table eichertemp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from eicher_motors;
create table herotemp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from hero_motocorp;
create table infosystemp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from infosys;
create table tcstemp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from tcs;
create table tvstemp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from tvs_motors;

#TASK-1 : Calculating 20 Day and 50 Day Moving Average 

#For Bajaj Auto:
create table bajaj1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from bajajtemp
window w as (order by Date asc);

#For Eisher Motors:
create table eicher1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from eichertemp
window w as (order by Date asc);

#For Hero Motocorp:
create table hero1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from herotemp
window w as (order by Date asc);

#For Infosys:
create table infosys1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from infosystemp
window w as (order by Date asc);

#For TCS:
create table tcs1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from tcstemp
window w as (order by Date asc);

#For TVS Motors:
create table tvs1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from tvstemp
window w as (order by Date asc);

#Select these tables and check values
select * from bajaj1 limit 100;
select * from eicher1 limit 100;
select * from hero1 limit 100;
select * from infosys1 limit 100;
select * from tcs1 limit 100;
select * from tvs1 limit 100;

#Each new table created shows the 20 day & 50 day Moving average
#Dropping Temporary tables

drop table bajajtemp;
drop table eichertemp;
drop table herotemp;
drop table infosystemp;
drop table tcstemp;
drop table tvstemp;

#TASK-2 : Master table creation by joining all the tables into single table
 create table master_table
 select tcs.`Date`,b.`Close price` as 'Bajaj',
 tcs.`Close price` as 'TCS' ,t.`Close price` as 'TVS',
 i.`Close price` as 'Infosys',e.`Close price` as 'Eicher',
 h.`Close price` as 'Hero'
 from tcs inner join eicher_motors e on e.`Date`=tcs.`Date`
 inner join  tvs_motors t on t.`Date`= tcs.`Date`
 inner join  hero_motocorp h on h.`Date` = tcs.`Date`
 inner join  bajaj_auto b on b.`Date`=tcs.`Date`
 inner join  infosys i on i.`Date`=tcs.`Date` order by tcs.`Date`;
 
#Display data from master_table
select * from master_table;

#Task 3: Creating a table to generate buy and sell signal
 
#create table bajaj2
create table bajaj2
select `Date`,`Close price`,
case 
when `50 Day MA` is NULL then 'NA'
when `20 Day MA`>`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) then 'BUY'
when `20 Day MA`<`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) then 'SELL'
else 'HOLD' 
end as `Signal`
from bajaj1 ;
 
#create table eicher2 
create table eicher2
select `Date`,`Close price`,
case 
when `50 Day MA` is NULL then 'NA'
when `20 Day MA`>`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) then 'BUY'
when `20 Day MA`<`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) then 'SELL'
else 'HOLD' 
end as `Signal`
from eicher1;
 
#create table tcs2
create table tcs2
select `Date`,`Close price`,
case 
when `50 Day MA` is NULL then 'NA'
when `20 Day MA`>`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) then 'BUY'
when `20 Day MA`<`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) then 'SELL'
else 'HOLD' 
end as `Signal`
from tcs1 ;
 
#create table tvs2
create table tvs2
select `Date`,`Close price`,
case 
when `50 Day MA` is NULL then 'NA'
when `20 Day MA`>`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) then 'BUY'
when `20 Day MA`<`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) then 'SELL'
else 'HOLD' 
end as `Signal`
from tvs1 ;
 
#create table hero2
create table hero2
select `Date`,`Close price`,
case 
when `50 Day MA` is NULL then 'NA'
when `20 Day MA`>`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) then 'BUY'
when `20 Day MA`<`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) then 'SELL'
else 'HOLD' 
end as `Signal`
from hero1 ;
 
#create  table infosys2
create table infosys2
select `Date`,`Close price`,
case 
when `50 Day MA` is NULL then 'NA'
when `20 Day MA`>`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))<(lag(`50 Day MA`,1) over(order by `Date`))) then 'BUY'
when `20 Day MA`<`50 Day MA` and ((lag(`20 Day MA`,1) over(order by `Date`))>(lag(`50 Day MA`,1) over(order by `Date`))) then 'SELL'
else 'HOLD' 
end as `Signal`
from infosys1 ;
 
#Checking Data
 
select * from bajaj2;
select * from eicher2;
select * from hero2;
select * from infosys2;
select * from tcs2;
select * from tvs2;
 
#Task 4: Creating a user deifned function to return the signal for the date given as input
DELIMITER $$
create function get_signal(signal_date date)
returns varchar(20) deterministic
BEGIN
return (select `Signal` from bajaj2 where bajaj2.`Date` = signal_date);
END $$
 
#testing the user defined function for bajaj auto data
DELIMITER ;
select get_signal(`Date`),`Date` as 'Signal' from bajaj1;
 