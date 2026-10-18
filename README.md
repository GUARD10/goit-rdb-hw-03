# Домашнє завдання №3 — Завантаження даних та основи SQL. DQL-команди

Репозиторій містить розв’язання п’яти завдань: шість SQL-запитів для вибірки, фільтрації, сортування та агрегування даних. Для роботи використовується MySQL 8.4 у Docker, а для виконання запитів і перегляду результатів — MySQL Workbench.

[Репозиторій на GitHub](https://github.com/GUARD10/goit-rdb-hw-03)

## Структура проєкту

```text
goit-rdb-hw-03/
├── README.md
├── goit-rdb.compose.yaml       # Конфігурація MySQL у Docker
└── database/
    ├── csv/                    # Вісім вихідних CSV-файлів
    ├── init/
    │   ├── 01_schema.sql       # Створення таблиць і зв’язків
    │   └── 02_seed.sql         # Імпорт даних із CSV
    └── queries/
        ├── task-1/             # Два запити та два скриншоти
        ├── task-2/             # Середня, максимальна й мінімальна ціна
        ├── task-3/             # Унікальні пари категорії та ціни
        ├── task-4/             # Кількість продуктів у ціновому діапазоні
        └── task-5/             # Агрегування за постачальниками
```

База `goit_rdb_hw_03` містить таблиці `categories`, `customers`, `employees`, `shippers`, `suppliers`, `products`, `orders` та `order_details`. Схема використовує InnoDB, кодування `utf8mb4` і зовнішні ключі. Ціна продукту зберігається як `DECIMAL(10, 2)`.

## Запуск бази даних

Потрібні Docker із підтримкою Docker Compose та MySQL Workbench. Виконайте з кореня репозиторію:

```sh
docker compose -f goit-rdb.compose.yaml up -d
```

Під час першого запуску з порожнім томом `mysql_data` автоматично виконуються `01_schema.sql` та `02_seed.sql`: створюються таблиці й завантажуються CSV через `LOAD DATA INFILE`. Спочатку імпортуються батьківські таблиці, щоб дотриматися зв’язків зовнішніх ключів.

Переглянути стан сервісу та журнал запуску:

```sh
docker compose -f goit-rdb.compose.yaml ps
docker compose -f goit-rdb.compose.yaml logs mysql
```

Дочекайтеся повідомлення `ready for connections` після завершення ініціалізації. Дані зберігаються в Docker-томі; за наявності вже ініціалізованої бази скрипти з `database/init/` повторно автоматично не виконуються.

## Підключення в MySQL Workbench

Створіть підключення з методом **Standard (TCP/IP)**:

| Параметр | Значення |
| --- | --- |
| Hostname | `127.0.0.1` |
| Port | `3307` |
| Username | `goit_hw_03` |
| Password | `goit_hw_03_local` |
| Default Schema | `goit_rdb_hw_03` |

Параметри відповідають локальній конфігурації в `goit-rdb.compose.yaml`.

Після підключення виберіть схему `goit_rdb_hw_03` як типову або виконайте:

```sql
USE goit_rdb_hw_03;
```

Відкрийте потрібний `.sql`-файл із `database/queries/`, виконайте запит і перегляньте результат у **Result Grid**.

## Завдання та SQL-запити

### 1. Вибірка даних із таблиць

Усі стовпчики таблиці `products` за допомогою wildcard `*`:

```sql
SELECT *
FROM products;
```

[SQL-файл](database/queries/task-1/all-select-query.sql) · [Скриншот](database/queries/task-1/all-select-query.png)

Тільки стовпчики `name` та `phone` таблиці `shippers`:

```sql
SELECT name, phone
FROM shippers;
```

[SQL-файл](database/queries/task-1/name-phone-select-query.sql) · [Скриншот](database/queries/task-1/name-phone-select-query.png)

### 2. Середня, максимальна та мінімальна ціна

```sql
SELECT
    AVG(price) AS average_price,
    MAX(price) AS max_price,
    MIN(price) AS min_price
FROM products;
```

[SQL-файл](database/queries/task-2/avg-max-min-select-query.sql) · [Скриншот](database/queries/task-2/avg-max-min-select-query.png)

### 3. Унікальні категорії та ціни

```sql
SELECT DISTINCT
    category_id,
    price
FROM products
ORDER BY price DESC
LIMIT 10;
```

`DISTINCT` прибирає повтори саме пар `(category_id, price)`. Результат містить 10 пар, відсортованих за спаданням ціни.

[SQL-файл](database/queries/task-3/uniq-category_id-price-select-query.sql) · [Скриншот](database/queries/task-3/uniq-category_id-price-select-query.png)

### 4. Кількість продуктів із ціною від 20 до 100

```sql
SELECT COUNT(*) AS products_count
FROM products
WHERE price BETWEEN 20 AND 100;
```

Оператор `BETWEEN` включає обидві межі: продукти з ціною рівно `20` або `100` також враховуються.

[SQL-файл](database/queries/task-4/count-product-price-between-20-and-100-select-quer.sql) · [Скриншот](database/queries/task-4/count-product-price-between-20-and-100-select-quer.png)

### 5. Кількість продуктів і середня ціна за постачальником

```sql
SELECT
    supplier_id,
    COUNT(*) AS products_count,
    AVG(price) AS average_price
FROM products
GROUP BY supplier_id
ORDER BY supplier_id;
```

Для кожного `supplier_id`, наявного в `products`, запит повертає кількість продуктів і їхню середню ціну. Результат упорядковано за ідентифікатором постачальника.

[SQL-файл](database/queries/task-5/count-products-and-avg-price-select-query.sql) · [Скриншот](database/queries/task-5/count-products-and-avg-price-select-query.png)

## Контрольні значення

Нижче наведено очікувані результати, обчислені за CSV-файлами цього репозиторію. Вони допомагають перевірити імпорт і виконання запитів у Workbench; це не звіт про повторний запуск SQL.

| Завдання | Очікуваний результат |
| --- | --- |
| 1 — `products` | 77 рядків |
| 1 — `shippers` | 3 рядки, стовпчики `name`, `phone` |
| 2 | Середня ціна ≈ `28.866364`, максимальна — `263.50`, мінімальна — `2.50` |
| 3 | 10 унікальних пар `(category_id, price)` за спаданням `price` |
| 4 | `products_count = 36` |
| 5 | 29 груп постачальників; сума `products_count` — 77 |
