create table if not exists device (
    id serial not null,
    kyotaku_id integer null,
    last_used_ymd integer null,
    last_app_updated_ymd integer null,
    primary key (id));
