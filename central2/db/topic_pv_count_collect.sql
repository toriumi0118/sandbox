create table if not exists topic_pv_count_collect (
    topic_id integer not null,
    counting_ymd integer not null,
    count integer not null,
    device_id integer not null,
    primary key (topic_id, counting_ymd, device_id)
);
