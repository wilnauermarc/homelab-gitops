TRUNCATE TABLE product_views, products, categories RESTART IDENTITY CASCADE;

INSERT INTO categories (id, name)
SELECT i, 'Category ' || i
FROM generate_series(1, 100) AS s(i);

INSERT INTO products (id, name, description, category_id, price, stock, updated_at)
SELECT
  i,
  'Product ' || i,
  'Catalog item ' || i || ' for cache and load experiments.',
  1 + ((i - 1) % 100),
  round((5 + random() * 200)::numeric, 2),
  (10 + floor(random() * 200))::int,
  now()
FROM generate_series(1, 100000) AS s(i);

INSERT INTO product_views (product_id, views)
SELECT id, 0 FROM products;

ANALYZE categories;
ANALYZE products;
ANALYZE product_views;
