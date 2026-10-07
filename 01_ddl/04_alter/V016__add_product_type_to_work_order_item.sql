-- HU-25: a work order line can now be a Frame, Lens, Accessory or Liquid, not only a frame.
-- product_type + product_id replace the old frame_id (still no foreign key: the products
-- domain owns that id). Existing rows are backfilled as FRAME before frame_id is dropped,
-- all in this same migration so the table is never left in an inconsistent half state.
ALTER TABLE sales.work_order_item ADD COLUMN product_type text;
ALTER TABLE sales.work_order_item ADD COLUMN product_id uuid;

UPDATE sales.work_order_item SET product_type = 'FRAME', product_id = frame_id;

ALTER TABLE sales.work_order_item ALTER COLUMN product_type SET NOT NULL;
ALTER TABLE sales.work_order_item ALTER COLUMN product_id SET NOT NULL;
ALTER TABLE sales.work_order_item
    ADD CONSTRAINT chk_work_order_item_product_type
    CHECK (product_type IN ('FRAME', 'LENS', 'ACCESSORY', 'LIQUID'));

ALTER TABLE sales.work_order_item DROP COLUMN frame_id;

COMMENT ON COLUMN sales.work_order_item.product_type IS 'Which products-domain catalog product_id points to: FRAME, LENS, ACCESSORY or LIQUID.';
COMMENT ON COLUMN sales.work_order_item.product_id IS 'Id of the product in its catalog (products domain); no foreign key, same convention as reservation_id.';
