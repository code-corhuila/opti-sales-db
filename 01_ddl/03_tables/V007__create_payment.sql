-- payment: an abono against an invoice. Append-only.
CREATE TABLE sales.payment (
    id           uuid        NOT NULL,
    invoice_id   uuid        NOT NULL,
    amount_cents bigint      NOT NULL,
    method       text        NOT NULL,
    reference    text,
    paid_at      timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT pk_payment PRIMARY KEY (id),
    CONSTRAINT chk_payment_amount CHECK (amount_cents BETWEEN 1 AND 1000000000000),
    CONSTRAINT chk_payment_method CHECK (method IN ('CASH', 'CARD', 'TRANSFER', 'PSE', 'NEQUI', 'DAVIPLATA', 'OTHER')),
    CONSTRAINT chk_payment_reference CHECK (reference IS NULL OR char_length(reference) <= 100)
);

COMMENT ON TABLE sales.payment IS 'Payment received against an invoice, in cents. Never updated or deleted.';
