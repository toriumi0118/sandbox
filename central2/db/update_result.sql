CREATE TABLE IF NOT EXISTS update_result (
    id serial NOT NULL,
    message text,
    prc_date timestamp with time zone NOT NULL,
    succeed integer NOT NULL,
    device_id integer NOT NULL,
    PRIMARY KEY (id)
);
