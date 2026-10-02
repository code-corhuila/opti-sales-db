-- work_order_item: the lines of a work order. frame_id and reservation_id belong to the products domain: no foreign key.
CREATE TABLE sales.work_order_item (
    id               uuid    NOT NULL,
    work_order_id    uuid    NOT NULL,
    frame_id         uuid    NOT NULL,
    reservation_id   uuid    NOT NULL,
    sku              text    NOT NULL,
    description      text    NOT NULL,
    quantity         integer NOT NULL,
    unit_price_cents bigint  NOT NULL,
    subtotal_cents   bigint  NOT NULL,
    position         integer NOT NULL,
    CONSTRAINT pk_work_order_item PRIMARY KEY (id),
    CONSTRAINT chk_work_order_item_quantity CHECK (quantity BETWEEN 1 AND 100),
    CONSTRAINT chk_work_order_item_price CHECK (unit_price_cents BETWEEN 0 AND 100000000000),
    CONSTRAINT chk_work_order_item_subtotal CHECK (subtotal_cents = quantity * unit_price_cents),
    CONSTRAINT chk_work_order_item_description CHECK (char_length(description) BETWEEN 1 AND 150),
    CONSTRAINT uq_work_order_item_position UNIQUE (work_order_id, position)
);

COMMENT ON TABLE sales.work_order_item IS 'Line of a work order with the price agreed by the products domain at reservation time.';
COMMENT ON COLUMN sales.work_order_item.reservation_id IS 'Stock reservation of the products domain, released if the order is cancelled.';
