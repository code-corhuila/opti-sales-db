-- Demo data for DEVELOPMENT only. It runs when the placeholder seedDemoData is "true"
-- (FLYWAY_PLACEHOLDERS_SEEDDEMODATA=true, set by opti-infra/env/.env.develop.example); in qa and main it is a no-op.
-- Invoices covering PAID / PARTIAL / PENDING / VOID for the billing screens. Depends on V017 work orders.
DO $seed$
BEGIN
    IF '${seedDemoData}' = 'true' THEN
        INSERT INTO sales.invoice (id, number, work_order_id, patient_id, total_cents, paid_cents, status, created_at, updated_at)
        VALUES
            ('cc011111-1111-4111-8111-111111111111', 'FV-0001', 'dd011111-1111-4111-8111-111111111111',
             '11111111-1111-4111-8111-111111111111', 104900000, 104900000, 'PAID',
             now() - interval '10 days', now() - interval '9 days'),
            ('cc022222-2222-4222-8222-222222222222', 'FV-0002', 'dd022222-2222-4222-8222-222222222222',
             '22222222-2222-4222-8222-222222222222', 66000000, 66000000, 'PAID',
             now() - interval '7 days', now() - interval '7 days'),
            ('cc033333-3333-4333-8333-333333333333', 'FV-0003', 'dd033333-3333-4333-8333-333333333333',
             '33333333-3333-4333-8333-333333333333', 85900000, 40000000, 'PARTIAL',
             now() - interval '5 days', now() - interval '3 days'),
            ('cc044444-4444-4444-8444-444444444444', 'FV-0004', 'dd044444-4444-4444-8444-444444444444',
             '11111111-1111-4111-8111-111111111111', 53500000, 0, 'PENDING',
             now() - interval '4 days', now() - interval '4 days'),
            ('cc055555-5555-4555-8555-555555555555', 'FV-0005', 'dd055555-5555-4555-8555-555555555555',
             '22222222-2222-4222-8222-222222222222', 46000000, 0, 'PENDING',
             now() - interval '3 days', now() - interval '3 days'),
            ('cc077777-7777-4777-8777-777777777777', 'FV-0007', 'dd077777-7777-4777-8777-777777777777',
             '11111111-1111-4111-8111-111111111111', 48000000, 0, 'VOID',
             now() - interval '6 days', now() - interval '5 days'),
            ('cc088888-8888-4888-8888-888888888888', 'FV-0008', 'dd088888-8888-4888-8888-888888888888',
             '33333333-3333-4333-8333-333333333333', 104900000, 104900000, 'PAID',
             now() - interval '1 day', now() - interval '1 day')
        ON CONFLICT (id) DO UPDATE SET
            status = EXCLUDED.status,
            paid_cents = EXCLUDED.paid_cents,
            total_cents = EXCLUDED.total_cents,
            updated_at = EXCLUDED.updated_at;

        PERFORM setval('sales.invoice_number_seq', GREATEST(8, (SELECT last_value FROM sales.invoice_number_seq)), true);
    END IF;
END
$seed$;
