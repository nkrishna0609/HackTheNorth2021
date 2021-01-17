
./cockroach.exe sql --url 'postgres://username:password@link:port/database?sslmode=verify-full&sslrootcert=./htn-cockroach-ca.crt'

CREATE TABLE items (
    id UUID PRIMARY KEY,
    product_name VARCHAR NOT NULL,
    username VARCHAR NOT NULL,
    add_date DATE NOT NULL,
    exp_date DATE NOT NULL,
    preview_img_url VARCHAR
);