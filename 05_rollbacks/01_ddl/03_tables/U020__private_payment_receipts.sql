-- Review-only inverse for the repository rebuild workflow. Never run against real receipts.
-- No rollback or deletion was executed as part of this task.
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM sales.payment_receipt) THEN
        RAISE EXCEPTION 'Refusing rollback: payment_receipt contains data';
    END IF;
END $$;
DROP TABLE sales.payment_receipt;
