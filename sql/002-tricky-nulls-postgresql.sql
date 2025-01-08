-- 1) Get rows that have NULLs in field ID
create table taba (id integer);
insert into taba values (1), (2), (null);

-- Wrong. Returns nothing
select *
from   taba
where  id = null;

-- Right
select *
from   taba
where  id is null;

drop table taba;

-- 2) NOT IN query containing NULLs
create table taba (id integer);
create table tabb (id integer, ida integer);
insert into taba values (1), (2), (3);
insert into tabb values (1, 1), (2, 2), (3, null);

-- Wrong. Returns nothing
select *
from   taba
where  id not in (select ida from tabb);

-- Right
select *
from   taba
where  not exists (select 1 from tabb where taba.id = tabb.ida);

drop table taba;
drop table tabb;

-- 3) Concatenation with NULLs
-- Wrong. Returns NULL
select '1' || null;

-- Right
select '1' || coalesce(null, '');