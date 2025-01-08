-- 1) The LIKE clause in CREATE TABLE
create table tab (id integer, first_name varchar(50),
                  last_name varchar(50), salary numeric check(salary > 0));
create index tab_idx on tab(id);

create table tab_new (like tab including all);
create table tab_new2 (like tab excluding indexes including constraints);
create table tab_new3 (like tab including all, new_col1 integer, new_col2 text);

drop table tab;
drop table tab_new;
drop table tab_new2;
drop table tab_new3;

-- 2) Data-Modifying Statements in CTE
create table tab (id integer, first_name varchar(50),
                  last_name varchar(50), salary numeric);
create table tab_new (id integer, first_name varchar(50),
                      last_name varchar(50), salary numeric);
insert into tab values (1, 'A', 'B', 100), (5, 'C', 'D', 200),
                       (10, 'E', 'F', 300), (15, 'G', 'H', 400);

with migrated_rows as (
  delete
  from   tab
  where  id between 1 and 10
  returning *
)
insert into tab_new
select *
from   migrated_rows;

select * from tab;
select * from tab_new;

drop table tab;
drop table tab_new;

-- 3) Table as a data type
create table tab (id integer, first_name varchar(50),
                  last_name varchar(50), salary numeric);
create table tab_main (id integer, tab_data tab);
insert into tab_main (id, tab_data) values (1, (1, 'A', 'B', 100)),
                                          (2, (2, 'C', 'D', 200));

select id
      ,(tab_data).id
      ,(tab_data).first_name
      ,(tab_data).last_name
      ,(tab_data).salary
from   tab_main;

drop table tab_main;
drop table tab;