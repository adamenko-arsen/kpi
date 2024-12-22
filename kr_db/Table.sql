-- Buildings and invididuals

create table Department(
    ID_             serial primary key,
    Name_           varchar(64) unique,
    Address_        varchar(64),
    Description_    varchar(128)
);

create table Operator(
    ID_         serial primary key,
    FIO         varchar(48) not null unique,
    Department  int references Department(ID_) not null
);

create table Client(
    ID_         serial primary key,
    FIO         varchar(48) not null unique,
    Phone       varchar(24) unique,
    Email       varchar(64) unique
);

-- Call info

create table Call_(
    ID_              serial primary key,
    Client           int references Client(ID_)
        on delete cascade,
    Operator         int references Operator(ID_)
        on delete cascade,
    StartTimestamp   timestamp not null,
    Duration         decimal(7, 1)
);

create table CallType(
    ID_             serial primary key,
    Call_           int references Call_(ID_)
        on delete cascade,
    Type_           varchar(16) not null,
    Description_    varchar(48)
);

create table Feedback(
    ID_             serial primary key,
    Client          int references Client(ID_)
        on delete cascade,
    Call_           int references Call_(ID_)
        on delete cascade,
    Rating          decimal(2, 1)
		not null
		check (Rating between 0 and 10), -- from 0 to 10
    Comment         varchar(48)
);

-- Call requests

create table Request(
    ID_                  serial primary key,
    Call_                int references Call_(ID_)
        on delete cascade,
    RequestTimestamp     timestamp not null,
    Notes                varchar(72)
);

create table RequestResult(
    ID_                   serial primary key,
    Request               int references Request(ID_)
        on delete cascade,
    ResolutionTimestamp   timestamp,
    Result                varchar(64)
);

-- Operator working time

create type ShiftType as enum(
    'during_morning',
    'during_afternoon',
    'during_evening',
    'during_night'
);

create type ShiftDate as enum(
    'every_monday',
    'every_tuesday',
    'every_wednesday',
    'every_fourday',
    'every_friday',
    'every_saturday',
    'every_sunday'
);

create table Shedule(
    Operator        int references Operator(ID_)
        on delete cascade,
    ShiftDate       ShiftDate not null,
    ShiftType       ShiftType not null
);

create table Incident(
    Operator        int references Operator(ID_)
        on delete cascade,
    Date_           date not null,
    Description_    varchar(64),
    IsResolved      boolean not null
);
