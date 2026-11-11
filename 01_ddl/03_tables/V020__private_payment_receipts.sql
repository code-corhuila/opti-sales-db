-- Additive: historical payments remain readable without receipts. New HTTP payments enforce evidence.
CREATE TABLE sales.payment_receipt (
    payment_id uuid PRIMARY KEY REFERENCES sales.payment(id),
    invoice_id uuid NOT NULL REFERENCES sales.invoice(id),
    content_type text NOT NULL CHECK (content_type IN ('application/pdf', 'image/png', 'image/jpeg')),
    content bytea NOT NULL CHECK (octet_length(content) BETWEEN 1 AND 2097152),
    created_at timestamptz NOT NULL DEFAULT now()
);
COMMENT ON TABLE sales.payment_receipt IS 'Private payment evidence. Download only through authenticated sales API; never public URLs.';
GRANT SELECT, INSERT ON sales.payment_receipt TO sales_writer;
-- Readers of the general sales reporting role deliberately do not receive receipt access.
