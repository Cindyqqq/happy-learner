-- [Problem 1]
set foreign_key_checks = 0; 
drop table if exists participated;
drop table if exists owns;
drop table if exists accident;
drop table if exists person;
drop table if exists car;
set foreign_key_checks = 1; 

-- The table "person" defines a driver with his id, name and address. 
create table person (
  driver_id varchar(10),
  name varchar(20) not null,
  address varchar(300) not null,
  primary key (driver_id)
);

-- The table "car" defines a car with its license, model and use of years. 
create table car (
  license varchar(7),
  model varchar(20),
  year numeric(4, 0),
  primary key (license)
);

-- The table "accident" defines an accident. It will have a report number,
-- a date when the accident occurred, the accident location 
-- and descriptions of the accident.
create table accident (
  report_number integer auto_increment,
  date_occurred datetime not null,
  location varchar(300) not null,
  description varchar(3000),
  primary key (report_number)
);

-- MySQL requires that foreign keys specify both the table name and the column name, even when the foreign key uses the primary-­‐‑key column of the referenced table.

-- The table "owns" defines the matching relation of a license 
-- and the driver's ID.
create table owns (
  driver_id varchar(10),
  license varchar(7),
  primary key (driver_id, license),
  foreign key (driver_id) references person(driver_id)
    on delete cascade on update cascade,
  foreign key (license) references car(license)
    on delete cascade on update cascade
);

-- The table "participated" defines the information of a person 
-- involved in an accident. It includes his id, license number, 
-- the report number of the accident, and the damage amount in the accident.
create table participated (
  driver_id varchar(10),
  license varchar(7),
  report_number integer auto_increment,
  damage_amount numeric(12, 2),
  primary key (driver_id, license, report_number),
  foreign key (driver_id) references person(driver_id)
    on update cascade, 
  foreign key (license) references car(license)
    on update cascade,
  foreign key (report_number) references accident(report_number)
    on update cascade
);