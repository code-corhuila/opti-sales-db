-- Foreign keys live here, after every table exists, so table order never matters.
-- Only relations inside this domain. patient_id, frame_id and reservation_id point to other domains: no foreign key.
ALTER TABLE sales.work_order_item
    ADD CONSTRAINT fk_work_order_item_work_order
    FOREIGN KEY (work_order_id) REFERENCES sales.work_order (id) ON DELETE CASCADE;

ALTER TABLE sales.invoice
    ADD CONSTRAINT fk_invoice_work_order
    FOREIGN KEY (work_order_id) REFERENCES sales.work_order (id) ON DELETE RESTRICT;

ALTER TABLE sales.payment
    ADD CONSTRAINT fk_payment_invoice
    FOREIGN KEY (invoice_id) REFERENCES sales.invoice (id) ON DELETE RESTRICT;
