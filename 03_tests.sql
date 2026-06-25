-- Task 6 - Testing

-- + клієнт
insert into customers (full_name, email, balance)
values ('Maria', 'maria@gmail.com', 1000);

-- + замовлення через процедуру
call create_order(5);

-- + товар
call add_product_to_order(5, 3, 2);

--тригер
select order_id, total_amount from orders where order_id = 5;

--сток зменшився
select product_id, product_name, stock_quantity from products where product_id = 3;

-- audit log
select * from order_log;