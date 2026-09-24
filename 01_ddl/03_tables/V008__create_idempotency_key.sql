-- idempotency_key: written in the same transaction as the resource it created, so a retry with
-- the same key finds the original resource instead of creating another one.
CREATE TABLE sales.idempotency_key (
    key           text        NOT NULL,
    resource_type text        NOT NULL,
    resource_id   uuid        NOT NULL,
    created_at    timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT pk_idempotency_key PRIMARY KEY (key),
    CONSTRAINT chk_idempotency_key_length CHECK (char_length(key) BETWEEN 8 AND 128),
    CONSTRAINT chk_idempotency_key_type CHECK (resource_type IN ('WORK_ORDER', 'PAYMENT'))
);

COMMENT ON TABLE sales.idempotency_key IS 'Client-supplied Idempotency-Key bound to the resource it created.';
