-- Attributes a work order to the seller who placed it, for the sales reports (HU: sales summary,
-- a seller's own sales vs their goal). Nullable: the column is backfilled going forward only,
-- never for history, and the workflow's own cancel/advance flows never need to set it.
ALTER TABLE sales.work_order ADD COLUMN seller_id uuid;

COMMENT ON COLUMN sales.work_order.seller_id IS 'Identity (auth domain) of the ADMIN/SELLER who started the sale; verified by contract, not a foreign key.';
