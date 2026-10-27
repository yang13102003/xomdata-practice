-- Xom Data · Portfolio profit/loss
-- Problem: https://xomdata.com/practice/medium-casewhen-047
-- Solved: 2026-10-27

WITH
  details AS (
    SELECT
      s.stock_code,
      c.stock_quantity,
      c.avg_cost_price,
      s.current_price,
      (s.current_price - c.avg_cost_price) * c.stock_quantity AS profit_loss,
      round(
        100.0 * (s.current_price - c.avg_cost_price) / avg_cost_price,
        2
      ) AS profit_pct
    FROM
      stocks s
      JOIN categories c ON s.id = c.stock_id
  )
SELECT
  stock_code,
  stock_quantity,
  avg_cost_price,
  current_price,
  profit_loss,
  profit_pct,
  CASE
    WHEN profit_pct > 10 then 'Strong Gain'
    WHEN profit_pct > 0 then 'Mild Gain'
    WHEN profit_pct = 0 then 'Break Even'
    WHEN profit_pct > -10 then 'Mild Loss'
    ELSE 'Strong Loss'
    END AS status,
  rank() OVER (ORDER BY profit_pct desc) as rank_by_pct,
  sum(avg_cost_price * stock_quantity) OVER ( ORDER BY profit_pct DESC, stock_code ASC rows BETWEEN unbounded preceding and current row ) as cumulative_invested
FROM details
ORDER BY rank() OVER (ORDER BY profit_pct) desc, stock_code asc
