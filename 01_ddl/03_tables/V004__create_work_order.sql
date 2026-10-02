-- work_order: the aggregate of a sale. Money in cents (bigint). patient_id points to another domain: no foreign key.
CREATE TABLE sales.work_order (
    id          uuid        NOT NULL,
    number      text        NOT NULL,
    patient_id  uuid        NOT NULL,
    reference   text        NOT NULL,
    status      text        NOT NULL DEFAULT 'QUOTATION',
    total_cents bigint      NOT NULL,
    created_at  timestamptz NOT NULL DEFAULT now(),
    updated_at  timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT pk_work_order PRIMARY KEY (id),
    CONSTRAINT uq_work_order_number UNIQUE (number),
    CONSTRAINT chk_work_order_number CHECK (number ~ '^OT-[0-9]{4,}$'),
    CONSTRAINT chk_work_order_reference CHECK (char_length(reference) BETWEEN 1 AND 64),
    CONSTRAINT chk_work_order_status CHECK (status IN ('QUOTATION', 'APPROVED', 'IN_LABORATORY', 'READY', 'DELIVERED', 'CANCELLED')),
    CONSTRAINT chk_work_order_total CHECK (total_cents BETWEEN 0 AND 1000000000000)
);

COMMENT ON TABLE sales.work_order IS 'A work order (sale of glasses). Lifecycle: QUOTATION, APPROVED, IN_LABORATORY, READY, DELIVERED, or CANCELLED.';
COMMENT ON COLUMN sales.work_order.patient_id IS 'Patient of the customers domain: an identifier verified by contract, not a foreign key.';
COMMENT ON COLUMN sales.work_order.reference IS 'Caller reference, for example the id of the saga that created the order.';
