-- GET /api/v1/reports/my-sales: a seller's own orders, newest first. work_order already has data,
-- so CONCURRENTLY (outside a transaction, per flyway.toml's postgresql.transactional.lock = false).
CREATE INDEX CONCURRENTLY idx_work_order_seller_created
    ON sales.work_order (seller_id, created_at DESC) WHERE seller_id IS NOT NULL;
