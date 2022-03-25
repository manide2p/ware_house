use iowa_state;

Create table liquor
(
data_date DATE,
store_number INT(5),
zip_code INT(5),
category INT(7),
vendor_number INT(5),
item_number INT(5),
pack INT(3),
state_bottle_retail float,
bottles_sold INT(3),
sale_dollars float,
longi VARCHAR(25),
lat VARCHAR(25)
);

create table store
(
store_number int(5) primary key ,
store_name varchar(45)
);
create table category(
category int(7) primary key,
category_name varchar(40)
);
create table items(
item_number int(6) primary key,
item_description varchar(60),
bottle_volume_ml int(4)
);

show tables;

load data  infile 'D:/sql_data/2019_rename_dat.csv' into table liquor fields terminated by ',' lines terminated by '\n';

load data  infile 'D:/sql_data/store.csv' into table store fields terminated by ',' lines terminated by '\n';

load data  infile 'D:/sql_data/category.csv' into table category fields terminated by ',' lines terminated by '\n';

load data  infile 'D:/sql_data/item.csv' into table items fields terminated by ',' lines terminated by '\n';

## total sales

select sum(bottles_sold),sum(pack),sum(sale_dollars) as total,item_number from liquor group by(item_number) order by total desc;   

## item wise total sales

select sum(l.bottles_sold)as Bottles ,l.pack,sum(l.sale_dollars) as total,l.item_number,i.item_description from liquor l join items i on i.item_number = l.item_number group by(l.item_number);

## volume wise sales

SELECT i.bottle_volume_ml AS bottle_ml, l.sale_dollars AS sale FROM items i JOIN
liquor l ON i.item_number = l.item_number group by(i.bottle_volume_ml) ;

# volumes and sales

select distinct(i.bottle_volume_ml) , sum(l.sale_dollars) from items i join liquor l on i.item_number = l.item_number;

## number of sales of each volume

select bottle_volume_ml as bottle_ml,COUNT(1) as numb from items group by bottle_volume_ml order by numb;

## indexing 6 million records to better querry 

create index item_number_index on liquor(item_number);
create index item_table_item_number_index on items(item_number);

#store_number , item_number , item_description,

select l.store_number, l.item_number,count(l.item_number), i.item_description from liquor l join items i on l.item_number = i.item_number join store s on l.store_number = s.store_number;

## category wise sales

SELECT SUM(l.bottles_sold) AS Bottles,l.pack,SUM(l.sale_dollars) AS total,
    l.item_number,c.category_name
FROM
    liquor l JOIN category c ON c.category = l.category GROUP BY (c.category);


## for changing the safety time out of the connection Edir -> Preferences -> SQL Editor -> DBMS connection read time out (secs) :600    to 6000 
