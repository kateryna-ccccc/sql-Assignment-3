--Task 1 — Function: Calculate Order Total

create or replace function calculate_order_total(p_order_id int)
returns numeric as $$
declare
	v_total numeric;
begin
	select coalesce (sum(quantity * price), 0) 
	into v_total
	from order_items
	where order_id = p_order_id;
	return v_total;
end
$$ language plpgsql;
-- coalesce замінює null на 0

--перевірка
select calculate_order_total(1);


--Task 2 — Procedure: Create New Order

create or replace procedure create_order(p_customer_id int)
language plpgsql as $$
begin
	if not exists(
	select 1 from customers where customer_id = p_customer_id
	) 
	then
		raise exception 'customer with id % does not exist', p_customer_id;
	end if;

	insert into orders(customer_id, order_date, total_amount)
	values (p_customer_id, current_timestamp, 0);
end;
$$;


--перевірка
call create_order(1);
select * from orders;


--Task 3 — Procedure: Add Product to Order
-- додає товар до замовлення + перевіряє наявність товару на складі та коректність кількості

create or replace procedure add_product_to_order(
    p_order_id int,
    p_product_id int,
    p_quantity int
)

language plpgsql as $$
declare 
	v_price numeric;        
    v_stock int;            
begin
	if p_quantity <= 0 then
	raise exception 'quantity must be greater than 0';
	end if;

	--отримати ціну і залишок на складі
    select price, stock_quantity
    into v_price, v_stock
    from products
    where product_id = p_product_id;
	
	if v_stock < p_quantity then
        raise exception 'not enough stock: available %, requested %', v_stock, p_quantity;
    end if;
	
	--позицію до замовлення
    insert into order_items (order_id, product_id, quantity, price)
    values (p_order_id, p_product_id, p_quantity, v_price);
	
    update products
    set stock_quantity = stock_quantity - p_quantity
    where product_id = p_product_id;
end;
$$;

--перевірка
call add_product_to_order(4, 2, -1);


--Task 4 — Trigger: Update Order Total

--функція для тригера - перераховує суму замовлення після змін в order_items
create or replace function trigger_update_order_total()
returns trigger as $$
begin
    update orders
    set total_amount = calculate_order_total(
        coalesce(new.order_id, old.order_id)
    )
    where order_id = coalesce(new.order_id, old.order_id);

    return new;
end;
$$ language plpgsql;

--тригер спрацьовує після insert, update або delete в order_items
create or replace trigger trg_update_order_total
after insert or update or delete on order_items
for each row
execute function trigger_update_order_total();

--перевірка
call add_product_to_order(4, 2, 3);
select * from orders where order_id = 4;


--Task 5 — Trigger: Order Audit Log

create or replace function trigger_log_order()
returns trigger as $$
begin
    insert into order_log (order_id, customer_id, action, log_date)
    values (new.order_id, new.customer_id, 'order created', current_timestamp);

    return new;
end;
$$ language plpgsql;


create or replace trigger trg_log_order
after insert on orders
for each row
execute function trigger_log_order();

--після вставки нового рядка в ордерс


--перевірка
call create_order(2);
select * from order_log;
