-- Set only for electronic methods (CARD, PSE, NEQUI, DAVIPLATA), authorized through the payment
-- gateway before the payment is recorded; null for CASH/TRANSFER/OTHER, which are a manual entry.
ALTER TABLE sales.payment ADD COLUMN gateway_transaction_id text;

COMMENT ON COLUMN sales.payment.gateway_transaction_id IS 'Id the payment gateway assigned to the authorized charge; null for manually recorded methods.';
