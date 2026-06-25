Answers
1. What is the difference between a function and a procedure in PostgreSQL?
2. Can a trigger be executed manually? Why or why not?
3. What are the advantages and disadvantages of storing business logic inside the database?
 
1. Функція повертає значення і може використовуватись в select-запиті. А процедура не повертає значення і викликається через call.
2. Не можна, бо він автоматично спрацьовує коли відбувається якась подія в таблиці. Наприклад: insert, update, delete. Тригер не має інтерфейсу для прямого виклику, бо завжди є реакцією на зміну даних (trg_log_order сам записував лог коли створювалось нове замовлення)
3. Переваги: логіка централізована і доступна для будь-якого застосунку, що підключається до бази даних, а також швидше виконується. 

Недоліки: складніше тестувати і підтримувати, бо логіка прив'язана до конкретної субд.