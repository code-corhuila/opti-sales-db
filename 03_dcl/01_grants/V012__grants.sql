GRANT USAGE ON SCHEMA sales TO sales_reader, sales_writer;
GRANT SELECT ON ALL TABLES IN SCHEMA sales TO sales_reader;
GRANT SELECT, INSERT, UPDATE ON sales.work_order, sales.invoice TO sales_writer;
GRANT SELECT, INSERT ON sales.work_order_item, sales.payment, sales.idempotency_key TO sales_writer;
GRANT USAGE ON SEQUENCE sales.work_order_number_seq, sales.invoice_number_seq TO sales_writer;
