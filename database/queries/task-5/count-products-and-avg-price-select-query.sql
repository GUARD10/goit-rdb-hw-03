SELECT
    supplier_id,
    COUNT(*) AS products_count,
    AVG(price) AS average_price
FROM products
GROUP BY supplier_id
ORDER BY supplier_id;