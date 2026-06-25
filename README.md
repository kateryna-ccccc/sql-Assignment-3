Practice Assignment 3
Creating a small database system for managing orders in an online store.
1. Створено базу даних online_store
2. Створено пʼять таблиць + наповнено даними:
- customers 
- products 
- orders
- order_items
- order_log
3. Створено функцію calculate_order_total, яка рахує суму замовлення.
4. Створено процедуру create_order, яка створює нове замовлення з перевіркою існування покупця.
5. Створено процедуру add_product_to_order, яка додає товар до замовлення + зменшує залишок на складі.
6. Створено тригер trg_update_order_total, який автоматично перераховує суму замовлення після змін у order_items.
7. Створено тригер trg_log_order, який записує лог при кожному новому замовленні.

8. Bonus Task 3 — Query Analysis
<img width="1375" height="608" alt="bonus_3" src="https://github.com/user-attachments/assets/6783c883-0940-42e9-ad4b-6b1180d2558b" />
Execution Time: 0.250 ms (дуже швидко)
PostgreSQL використовує Hash Join для з'єднання таблиць order_items і products.
На обох таблицях виконується Seq Scan, бо таблиці малі і індекси не потрібні.
Фільтр order_id = 1 застосовується під час сканування order_items — відфільтровано 5 рядків, залишилось 2.
