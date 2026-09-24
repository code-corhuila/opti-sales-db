-- invoice: one per work order, opened together with it. paid_cents is the sum of its payments.
CREATE TABLE sales.invoice (
    id            uuid        NOT NULL,
    number        text        NOT NULL,
    work_order_id uuid        NOT NULL,
    patient_id    uuid        NOT NULL,
    total_cents   bigint      NOT NULL,
    paid_cents    bigint      NOT NULL DEFAULT 0,
    status        text        NOT NULL DEFAULT 'PENDING',
    created_at    timestamptz NOT NULL DEFAULT now(),
    updated_at    timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT pk_invoice PRIMARY KEY (id),
    CONSTRAINT uq_invoice_number UNIQUE (number),
    CONSTRAINT uq_invoice_work_order UNIQUE (work_order_id),
    CONSTRAINT chk_invoice_number CHECK (number ~ '^FV-[0-9]{4,}$'),
    CONSTRAINT chk_invoice_total CHECK (total_cents BETWEEN 0 AND 1000000000000),
    CONSTRAINT chk_invoice_paid CHECK (paid_cents >= 0 AND paid_cents <= total_cents),
    CONSTRAINT chk_invoice_status CHECK (status IN ('PENDING', 'PARTIAL', 'PAID', 'VOID')),
    CONSTRAINT chk_invoice_status_matches_paid CHECK (
        (status = 'PAID' AND paid_cents = total_cents)
        OR (status = 'PARTIAL' AND paid_cents > 0 AND paid_cents < total_cents)
        OR (status = 'PENDING' AND paid_cents = 0)
        OR (status = 'VOID' AND paid_cents = 0))
);

COMMENT ON TABLE sales.invoice IS 'Invoice of a work order. PENDING, PARTIAL (abonos), PAID, or VOID when the order is cancelled.';
COMMENT ON COLUMN sales.invoice.paid_cents IS 'Sum of the payments; the balance is total_cents - paid_cents.';
