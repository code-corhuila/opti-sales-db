REVOKE ALL ON ALL TABLES IN SCHEMA sales FROM sales_reader, sales_writer;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA sales FROM sales_writer;
REVOKE USAGE ON SCHEMA sales FROM sales_reader, sales_writer;
