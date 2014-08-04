create table if not exists pv_count_collect (
    page_type integer not null,
    office_id integer not null,
    counting_ymd integer not null,
    device_id integer not null,
    count integer not null,
    primary key (page_type, office_id, counting_ymd, device_id)
);
