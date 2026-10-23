-- Xom Data · Heavy shipments
-- Problem: https://xomdata.com/practice/easy-where-025
-- Solved: 2026-10-23

SELECT waybill_code, weight_kg, shipping_fee
from shipments
WHERE weight_kg > 3
ORDER BY weight_kg desc
