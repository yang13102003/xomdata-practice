-- Xom Data · Delivery performance by size class
-- Problem: https://xomdata.com/practice/medium-case-160
-- Solved: 2026-10-23

WITH vehicle as(
SELECT t.vehicle_type, t.capacity_tons, count(DISTINCT s.id) as shipment_count,
    CASE 
        WHEN t.capacity_tons >= 10 then 'Large Truck'
        WHEN t.capacity_tons >= 5 then 'Medium Truck'
        ELSE 'Small Truck'
    END AS size_class,
    COUNT(DISTINCT CASE WHEN d.results = 'success' then s.id END) as delivered,
    round(COUNT(DISTINCT CASE WHEN d.results = 'success' then s.id end) * 100.0 / count(DISTINCT s.id)  ,2) as delivery_rate
FROM deliveries d JOIN shipments s on d.shipment_id = s.id
join trucks t on s.truck_id = t.id
GROUP BY t.vehicle_type, t.capacity_tons
)
SELECT vehicle_type, capacity_tons, shipment_count, size_class,delivered, delivery_rate, rank() over (PARTITION BY size_class ORDER BY delivery_rate DESC) as rank_in_size
FROM vehicle
ORDER BY size_class asc, rank_in_size asc, vehicle_type asc
