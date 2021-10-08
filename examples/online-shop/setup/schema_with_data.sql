CONNECT sys/Oradoc_db1 AS sysdba;
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER balUser IDENTIFIED BY balpass;
GRANT CONNECT, RESOURCE, DBA TO balUser;
/

CREATE OR REPLACE TYPE ReviewArrayType AS VARRAY(5) OF NUMBER;
/

-- employees
CREATE TABLE employees(
    employee_id NUMBER
                GENERATED BY DEFAULT AS IDENTITY START WITH 100
                PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name  VARCHAR(255) NOT NULL,
    email      VARCHAR(255) NOT NULL,
    phone      VARCHAR(50) NOT NULL ,
    hire_date  DATE NOT NULL,
    manager_id NUMBER(12, 0),
    job_title  VARCHAR(255) NOT NULL,
    CONSTRAINT fk_employees_manager
        FOREIGN KEY(manager_id)
        REFERENCES employees(employee_id)
        ON DELETE CASCADE
  );

-- products table
CREATE TABLE products(
    product_id NUMBER
               GENERATED BY DEFAULT AS IDENTITY START WITH 150
               PRIMARY KEY,
    product_name  VARCHAR2( 255) NOT NULL,
    description   VARCHAR2(2000),
    standard_cost NUMBER(9, 2),
    list_price    NUMBER(9, 2),
    reviews       ReviewArrayType
  );

-- customers
CREATE TABLE customers(
    customer_id NUMBER
                GENERATED BY DEFAULT AS IDENTITY START WITH 150
                PRIMARY KEY,
    name         VARCHAR2(255) NOT NULL,
    address      VARCHAR2(255),
    website      VARCHAR2(255),
    credit_limit NUMBER(8, 2)
  );

-- contacts
CREATE TABLE contacts(
    contact_id NUMBER
               GENERATED BY DEFAULT AS IDENTITY START WITH 150
               PRIMARY KEY,
    first_name  VARCHAR2(255) NOT NULL,
    last_name   VARCHAR2(255) NOT NULL,
    email       VARCHAR2(255) NOT NULL,
    phone       VARCHAR2(20),
    customer_id NUMBER,
    CONSTRAINT fk_contacts_customers
      FOREIGN KEY(customer_id)
      REFERENCES customers(customer_id)
      ON DELETE CASCADE
  );

-- orders table
CREATE TABLE orders(
    order_id NUMBER
             GENERATED BY DEFAULT AS IDENTITY START WITH 150
             PRIMARY KEY,
    customer_id NUMBER(6, 0) NOT NULL,
    status      VARCHAR(20) NOT NULL ,
    salesman_id NUMBER(6, 0),
    order_date  DATE NOT NULL,
    CONSTRAINT fk_orders_customers
      FOREIGN KEY(customer_id)
      REFERENCES customers(customer_id)
      ON DELETE CASCADE,
    CONSTRAINT fk_orders_employees
      FOREIGN KEY(salesman_id)
      REFERENCES employees(employee_id)
      ON DELETE SET NULL
  );

-- order items
CREATE TABLE order_items(
    order_id   NUMBER(12, 0),
    item_id    NUMBER(12, 0),
    product_id NUMBER(12, 0) NOT NULL,
    quantity   NUMBER(8, 2) NOT NULL,
    unit_price NUMBER(8, 2) NOT NULL,
    warranty_period INTERVAL YEAR TO MONTH,
    CONSTRAINT pk_order_items
      PRIMARY KEY(order_id, item_id),
    CONSTRAINT fk_order_items_products
      FOREIGN KEY(product_id)
      REFERENCES products(product_id)
      ON DELETE CASCADE,
    CONSTRAINT fk_order_items_orders
      FOREIGN KEY(order_id)
      REFERENCES orders(order_id)
      ON DELETE CASCADE
  );
/

-- disable FK constraints
ALTER TABLE employees DISABLE CONSTRAINT fk_employees_manager;
ALTER TABLE contacts DISABLE CONSTRAINT fk_contacts_customers;
ALTER TABLE orders DISABLE CONSTRAINT fk_orders_customers;
ALTER TABLE orders DISABLE CONSTRAINT fk_orders_employees;
ALTER TABLE order_items DISABLE CONSTRAINT fk_order_items_products;
ALTER TABLE order_items DISABLE CONSTRAINT fk_order_items_orders;

REM INSERTING into balUser.EMPLOYEES
SET DEFINE OFF;
Insert into balUser.EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE,HIRE_DATE,MANAGER_ID,JOB_TITLE) values (1,'Tommy','Bailey','tommy.bailey@example.com','515.123.4567',to_date('17-JUN-16','DD-MON-RR'),null,'President');
Insert into balUser.EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE,HIRE_DATE,MANAGER_ID,JOB_TITLE) values (46,'Ava','Sullivan','ava.sullivan@example.com','011.44.1344.429268',to_date('01-OCT-16','DD-MON-RR'),1,'Sales Manager');
Insert into balUser.EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE,HIRE_DATE,MANAGER_ID,JOB_TITLE) values (47,'Ella','Wallace','ella.wallace@example.com','011.44.1344.467268',to_date('05-JAN-16','DD-MON-RR'),1,'Sales Manager');
Insert into balUser.EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE,HIRE_DATE,MANAGER_ID,JOB_TITLE) values (56,'Evie','Harrison','evie.harrison@example.com','011.44.1344.486508',to_date('23-NOV-16','DD-MON-RR'),46,'Sales Representative');
Insert into balUser.EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE,HIRE_DATE,MANAGER_ID,JOB_TITLE) values (57,'Scarlett','Gibson','scarlett.gibson@example.com','011.44.1345.429268',to_date('30-JAN-16','DD-MON-RR'),47,'Sales Representative');
Insert into balUser.EMPLOYEES (EMPLOYEE_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE,HIRE_DATE,MANAGER_ID,JOB_TITLE) values (58,'Ruby','Mcdonald','ruby.mcdonald@example.com','011.44.1345.929268',to_date('04-MAR-16','DD-MON-RR'),47,'Sales Representative');

REM INSERTING into balUser.PRODUCTS
SET DEFINE OFF;
Insert into balUser.PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE, REVIEWS) values (1,'Intel Xeon E5-2699 V3 (OEM/Tray)','Speed:2.3GHz,Cores:18,TDP:145W',2867.51,3410.46, ReviewArrayType(2, 4, 23, 9, 399));
Insert into balUser.PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE, REVIEWS) values (2,'Intel Xeon E5-2697 V3','Speed:2.6GHz,Cores:14,TDP:145W',2326.27,2774.98, ReviewArrayType(0, 4, 23, 67, 359));
Insert into balUser.PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE, REVIEWS) values (3,'Intel Xeon E5-2698 V3 (OEM/Tray)','Speed:2.3GHz,Cores:16,TDP:135W',2035.18,2660.72, ReviewArrayType(2, 4, 3, 67, 697));
Insert into balUser.PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE, REVIEWS) values (4,'Intel Xeon E5-2697 V4','Speed:2.3GHz,Cores:18,TDP:145W',2144.4,2554.99, ReviewArrayType(2, 4, 23, 67, 379));
Insert into balUser.PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE, REVIEWS) values (5,'Intel Xeon E5-2685 V3 (OEM/Tray)','Speed:2.6GHz,Cores:12,TDP:120W',2012.11,2501.69, ReviewArrayType(2, 4, 23, 7, 38));
Insert into balUser.PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE, REVIEWS) values (6,'Intel Xeon E5-2695 V3 (OEM/Tray)','Speed:2.3GHz,Cores:14,TDP:120W',1925.13,2431.95, ReviewArrayType(2, 4, 23, 67, 999));
Insert into balUser.PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE, REVIEWS) values (7,'Intel Xeon E5-2697 V2','Speed:2.7GHz,Cores:12,TDP:130W',2101.59,2377.09, ReviewArrayType(0, 4, 23, 64, 792));
Insert into balUser.PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE, REVIEWS) values (8,'Intel Xeon E5-2695 V4','Speed:2.1GHz,Cores:18,TDP:120W',1780.35,2269.99, ReviewArrayType(0, 4, 23, 67, 111));
Insert into balUser.PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE, REVIEWS) values (9,'Intel Xeon E5-2695 V2','Speed:2.4GHz,Cores:12,TDP:115W',1793.53,2259.99, ReviewArrayType(2, 4, 23, 67, 908));
Insert into balUser.PRODUCTS (PRODUCT_ID,PRODUCT_NAME,DESCRIPTION,STANDARD_COST,LIST_PRICE, REVIEWS) values (10,'Intel Xeon E5-2643 V2 (OEM/Tray)','Speed:3.5GHz,Cores:6,TDP:130W',1940.18,2200, ReviewArrayType(2, 0, 26, 67, 254));


REM INSERTING into balUser.CUSTOMERS
SET DEFINE OFF;
Insert into balUser.CUSTOMERS (CUSTOMER_ID,NAME,ADDRESS,CREDIT_LIMIT,WEBSITE) values (1,'Facebook','5112 Sw 9Th St, Des Moines, IA',500,'http://www.facebook.com');
Insert into balUser.CUSTOMERS (CUSTOMER_ID,NAME,ADDRESS,CREDIT_LIMIT,WEBSITE) values (2,'Apple','18 Glenridge Rd, Schenectady, NY',1200,'http://www.apple.com');
Insert into balUser.CUSTOMERS (CUSTOMER_ID,NAME,ADDRESS,CREDIT_LIMIT,WEBSITE) values (3,'Walmart','1790 Grand Blvd, Schenectady, NY',1200,'http://www.walmart.com');



REM INSERTING into balUser.CONTACTS
SET DEFINE OFF;
Insert into balUser.CONTACTS (CONTACT_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE,CUSTOMER_ID) values (1,'Gabrielle','Dennis','gabrielle.dennis@facebook.com','+1 515 123 4290',1);
Insert into balUser.CONTACTS (CONTACT_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE,CUSTOMER_ID) values (2,'Jaime','Lester','jaime.lester@apple.com','+1 518 123 4624',2);
Insert into balUser.CONTACTS (CONTACT_ID,FIRST_NAME,LAST_NAME,EMAIL,PHONE,CUSTOMER_ID) values (3,'Annice','Boyer','annice.boyer@walmart.com','+1 518 123 4618',3);


REM INSERTING into balUser.ORDERS
SET DEFINE OFF;
Insert into balUser.ORDERS (ORDER_ID,CUSTOMER_ID,STATUS,SALESMAN_ID,ORDER_DATE) values (1,1,'Canceled',56,to_date('10-OCT-16','DD-MON-RR'));
Insert into balUser.ORDERS (ORDER_ID,CUSTOMER_ID,STATUS,SALESMAN_ID,ORDER_DATE) values (2,2,'Shipped',57,to_date('02-OCT-16','DD-MON-RR'));
Insert into balUser.ORDERS (ORDER_ID,CUSTOMER_ID,STATUS,SALESMAN_ID,ORDER_DATE) values (3,3,'Pending',58,to_date('02-OCT-16','DD-MON-RR'));
Insert into balUser.ORDERS (ORDER_ID,CUSTOMER_ID,STATUS,SALESMAN_ID,ORDER_DATE) values (4,1,'Shipped',58,to_date('02-OCT-16','DD-MON-RR'));

REM INSERTING into balUser.ORDER_ITEMS
SET DEFINE OFF;
Insert into balUser.ORDER_ITEMS (ORDER_ID,ITEM_ID,PRODUCT_ID,QUANTITY,UNIT_PRICE,WARRANTY_PERIOD) values (2,1,1,116,3410.99,INTERVAL '5' YEAR);
Insert into balUser.ORDER_ITEMS (ORDER_ID,ITEM_ID,PRODUCT_ID,QUANTITY,UNIT_PRICE,WARRANTY_PERIOD) values (1,1,10,77,2200,INTERVAL '3-6' YEAR TO MONTH);
Insert into balUser.ORDER_ITEMS (ORDER_ID,ITEM_ID,PRODUCT_ID,QUANTITY,UNIT_PRICE,WARRANTY_PERIOD) values (2,2,3,65,2670.99,INTERVAL '5' YEAR);
Insert into balUser.ORDER_ITEMS (ORDER_ID,ITEM_ID,PRODUCT_ID,QUANTITY,UNIT_PRICE,WARRANTY_PERIOD) values (4,1,4,45,2550.99,INTERVAL '5' YEAR);
Insert into balUser.ORDER_ITEMS (ORDER_ID,ITEM_ID,PRODUCT_ID,QUANTITY,UNIT_PRICE,WARRANTY_PERIOD) values (4,2,5,70,2500.98,INTERVAL '5' YEAR);
Insert into balUser.ORDER_ITEMS (ORDER_ID,ITEM_ID,PRODUCT_ID,QUANTITY,UNIT_PRICE,WARRANTY_PERIOD) values (3,1,9,123,2259.99,INTERVAL '6' MONTH);

-- enable FK constraints
ALTER TABLE employees ENABLE CONSTRAINT fk_employees_manager;
ALTER TABLE contacts ENABLE CONSTRAINT fk_contacts_customers;
ALTER TABLE orders ENABLE CONSTRAINT fk_orders_customers;
ALTER TABLE orders ENABLE CONSTRAINT fk_orders_employees;
ALTER TABLE order_items ENABLE CONSTRAINT fk_order_items_products;
ALTER TABLE order_items ENABLE CONSTRAINT fk_order_items_orders;
/