-- create db
CREATE DATABASE core
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

CREATE DATABASE identity
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- create schema
\c core;
CREATE SCHEMA IF NOT EXISTS shop1;

\c identity;
CREATE SCHEMA IF NOT EXISTS shop1;

--create tables for core
\c core;
CREATE TABLE IF NOT EXISTS shop1.order_status(
    id_order_status SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS shop1.category(
    id_category SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS shop1.item(
    id_item SERIAL PRIMARY KEY,
    id_user INT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    id_category INT,
    created_at TIMESTAMP NOT NULL,
    active BOOLEAN NOT NULL,

    CONSTRAINT fk_category FOREIGN KEY (id_category)
    REFERENCES shop1.category(id_category)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS shop1.item_group(
    id_item_group INT,
    id_item INT,

    CONSTRAINT fk_item FOREIGN KEY (id_item)
    REFERENCES shop1.item(id_item)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS shop1.order(
    id_order SERIAL PRIMARY KEY,
    id_user INT,
    id_item_group INT,
    id_order_status INT,
    total DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP NOT NULL,

    CONSTRAINT fk_order_status FOREIGN KEY (id_order_status)
    REFERENCES shop1.order_status(id_order_status)
    ON DELETE SET NULL ON UPDATE CASCADE,

    CONSTRAINT fk_item_group FOREIGN KEY (id_item_group)
    REFERENCES shop1.item_group(id_item_group)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- create tables for identity
\c identity;

CREATE TABLE IF NOT EXISTS shop1.hash_method(
    id_hash_method SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS shop1.role(
    id_role SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS shop1.user(
    id_user SERIAL PRIMARY KEY,
    login VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    id_hash_method INT,
    email VARCHAR(100) UNIQUE,
    active BOOLEAN,

    CONSTRAINT fk_hash_method FOREIGN KEY (id_hash_method) 
    REFERENCES shop1.hash_method(id_hash_method) 
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS shop1.role_group(
    id_role_group SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    id_role INT,

    CONSTRAINT fk_role FOREIGN KEY (id_role) 
    REFERENCES shop1.role(id_role) 
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS shop1.user_role(
    id_user_role SERIAL PRIMARY KEY,
    id_user INT,
    id_role INT,
    id_role_group INT,

    CONSTRAINT fk_user FOREIGN KEY (id_user) 
    REFERENCES shop1.user(id_user) 
    ON DELETE SET NULL ON UPDATE CASCADE,

    CONSTRAINT fk_role FOREIGN KEY (id_role) 
    REFERENCES shop1.role(id_role) 
    ON DELETE SET NULL ON UPDATE CASCADE,

    CONSTRAINT fk_role_group FOREIGN KEY (id_role_group) 
    REFERENCES shop1.role_group(id_role_group)  
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- create users for db_repo service
CREATE USER db_repo WITH PASSWORD '1234';

\c core
GRANT USAGE ON SCHEMA shop1 TO db_repo;
GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA shop1 TO db_repo;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA shop1 TO db_repo;
ALTER DEFAULT PRIVILEGES IN SCHEMA shop1 GRANT USAGE, SELECT ON SEQUENCES TO db_repo;
ALTER DEFAULT PRIVILEGES FOR ROLE db_repo IN SCHEMA shop1
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLES TO db_repo;
ALTER ROLE db_repo CREATEDB;
ALTER ROLE db_repo CREATEROLE;
GRANT ALL PRIVILEGES ON SCHEMA shop1 TO db_repo;


\c identity
GRANT USAGE ON SCHEMA shop1 TO db_repo;
GRANT SELECT, UPDATE, INSERT, DELETE ON ALL TABLES IN SCHEMA shop1 TO db_repo;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA shop1 TO db_repo;
ALTER DEFAULT PRIVILEGES IN SCHEMA shop1 GRANT USAGE, SELECT ON SEQUENCES TO db_repo;
ALTER DEFAULT PRIVILEGES FOR ROLE db_repo IN SCHEMA shop1
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLES TO db_repo;
ALTER ROLE db_repo CREATEDB;
ALTER ROLE db_repo CREATEROLE;
GRANT ALL PRIVILEGES ON SCHEMA shop1 TO db_repo;



