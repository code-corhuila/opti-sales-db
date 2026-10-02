ALTER TABLE IF EXISTS sales.work_order_item DROP CONSTRAINT IF EXISTS fk_work_order_item_work_order;
ALTER TABLE IF EXISTS sales.invoice DROP CONSTRAINT IF EXISTS fk_invoice_work_order;
ALTER TABLE IF EXISTS sales.payment DROP CONSTRAINT IF EXISTS fk_payment_invoice;
