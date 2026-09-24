-- Plain CREATE INDEX is fine here: the tables were created in this same release and are empty.
-- Any later index on a table with data goes in its own migration with CREATE INDEX CONCURRENTLY.

-- fk_work_order_item_work_order is covered by uq_work_order_item_position (work_order_id, position).
-- fk_invoice_work_order is covered by uq_invoice_work_order.
-- fk_payment_invoice:
CREATE INDEX idx_payment_invoice_paid ON sales.payment (invoice_id, paid_at DESC, id DESC);

-- GET /work-orders: newest first, by status (the worker asks for QUOTATION older than a date).
CREATE INDEX idx_work_order_created ON sales.work_order (created_at DESC, id DESC);
CREATE INDEX idx_work_order_status_created ON sales.work_order (status, created_at);
CREATE INDEX idx_work_order_patient ON sales.work_order (patient_id, created_at DESC);

-- GET /invoices: newest first, by status.
CREATE INDEX idx_invoice_created ON sales.invoice (created_at DESC, id DESC);
CREATE INDEX idx_invoice_status_created ON sales.invoice (status, created_at DESC);
