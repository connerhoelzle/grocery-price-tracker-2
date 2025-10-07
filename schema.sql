DROP TABLE IF EXISTS store;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS receipt;
DROP TABLE IF EXISTS web_session;
DROP TABLE IF EXISTS line_item;
DROP VIEW IF EXISTS amount_spent_by_store;
DROP VIEW IF EXISTS number_of_products_purchased;

CREATE TABLE store (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    location TEXT
);

CREATE TABLE product (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    brand TEXT,
    size REAL,
    unit TEXT
);

CREATE TABLE receipt (
    id INTEGER PRIMARY KEY,
    store_id INTEGER NOT NULL,
    date TEXT NOT NULL,
    subtotal REAL,
    tax REAL,
    total_price REAL,
    FOREIGN KEY (store_id) REFERENCES store(id)
);

CREATE TABLE web_session(
    id INTEGER PRIMARY KEY,
    session_date TEXT NOT NULL,
    store_id INTEGER NOT NULL,
    notes TEXT
);

CREATE TABLE line_item (
    id INTEGER PRIMARY KEY,
    receipt_id INTEGER,
    web_session_id INTEGER,
    product_id INTEGER,
    raw_text TEXT NOT NULL,
    quantity REAL,
    unit_price REAL,
    total_price REAL,
    tax_status TEXT,
    CHECK (
        (receipt_id IS NOT NULL AND web_session_id IS NULL) OR
        (receipt_id IS NULL AND web_session_id IS NOT NULL)
    ),
    FOREIGN KEY (receipt_id) REFERENCES receipt(id),
    FOREIGN KEY (web_session_id) REFERENCES web_session(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE VIEW amount_spent_by_store AS 
SELECT store.name, store.location, SUM(receipt.total_price) 
FROM store LEFT JOIN receipt ON store.id = receipt.store_id 
GROUP BY store.id
;


CREATE VIEW number_of_products_purchased AS 
SELECT product.name, product.brand, product.size, product.unit, COUNT(line_item.product_id) AS number_of_times_purchased 
FROM product LEFT JOIN line_item ON product.id = line_item.product_id 
GROUP BY product.id 
ORDER BY number_of_times_purchased DESC, product.name
;
