ALTER TABLE IF EXISTS sales.work_order_item ADD COLUMN IF NOT EXISTS frame_id uuid;
UPDATE sales.work_order_item SET frame_id = product_id WHERE product_type = 'FRAME';
ALTER TABLE sales.work_order_item ALTER COLUMN frame_id SET NOT NULL;

ALTER TABLE IF EXISTS sales.work_order_item DROP CONSTRAINT IF EXISTS chk_work_order_item_product_type;
ALTER TABLE IF EXISTS sales.work_order_item DROP COLUMN IF EXISTS product_type;
ALTER TABLE IF EXISTS sales.work_order_item DROP COLUMN IF EXISTS product_id;
