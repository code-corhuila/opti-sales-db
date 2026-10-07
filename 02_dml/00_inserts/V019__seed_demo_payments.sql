-- Demo data for DEVELOPMENT only. It runs when the placeholder seedDemoData is "true"
-- (FLYWAY_PLACEHOLDERS_SEEDDEMODATA=true, set by opti-infra/env/.env.develop.example); in qa and main it is a no-op.
-- Payments for PAID/PARTIAL demo invoices (CASH, CARD, TRANSFER, NEQUI, PSE). Depends on V018.
DO $seed$
BEGIN
    IF '${seedDemoData}' = 'true' THEN
        INSERT INTO sales.payment (id, invoice_id, amount_cents, method, reference, paid_at, gateway_transaction_id)
        VALUES
            ('bb011111-1111-4111-8111-111111111111', 'cc011111-1111-4111-8111-111111111111',
             104900000, 'CASH', 'caja-demo-1', now() - interval '9 days', NULL),
            ('bb022222-2222-4222-8222-222222222222', 'cc022222-2222-4222-8222-222222222222',
             66000000, 'CARD', 'visa-****4242', now() - interval '7 days', 'gw-demo-ot2'),
            ('bb033333-3333-4333-8333-333333333333', 'cc033333-3333-4333-8333-333333333333',
             40000000, 'TRANSFER', 'abono-ot3', now() - interval '3 days', NULL),
            ('bb088888-8888-4888-8888-888888888888', 'cc088888-8888-4888-8888-888888888888',
             60000000, 'NEQUI', 'nequi-ot8-a', now() - interval '1 day', 'gw-nequi-1'),
            ('bb088889-8888-4888-8888-888888888889', 'cc088888-8888-4888-8888-888888888888',
             44900000, 'PSE', 'pse-ot8-b', now() - interval '20 hours', 'gw-pse-1')
        ON CONFLICT (id) DO UPDATE SET
            amount_cents = EXCLUDED.amount_cents,
            method = EXCLUDED.method,
            reference = EXCLUDED.reference,
            paid_at = EXCLUDED.paid_at,
            gateway_transaction_id = EXCLUDED.gateway_transaction_id;
    END IF;
END
$seed$;
