/* SALES AND CUSTOMER INSIGHTS ANALYSIS (2017 - 2020) */

/*Data Familiarization*/

use sales ;
show tables;
describe transactions;
describe date;

/*Time-Based Trends*/


select min(date),max(date) from date;
SELECT
    d.year,
    d.month_name,
    SUM(t.sales_amount) AS monthly_sales
FROM transactions t
JOIN date d
    ON t.order_date = d.date
GROUP BY d.year, d.month_name
ORDER BY d.year, d.month_name;

/*Sales Quality Analysis*/


SELECT
    d.year,
    SUM(CASE WHEN t.sales_amount > 0 THEN t.sales_amount ELSE 0 END) AS gross_sales,
    SUM(CASE WHEN t.sales_amount < 0 THEN ABS(t.sales_amount) ELSE 0 END) AS returns,
    SUM(t.sales_amount) AS net_sales
FROM transactions t
JOIN date d
    ON t.order_date = d.date
GROUP BY d.year
ORDER BY d.year;


/*-- Market-wise Net Sales*/

/* “What are the total net sales by each market?”*/

select m.markets_name , sum(t.sales_amount) as net_sales
from transactions t
join markets m
on t.market_code = m.markets_code
group by m.markets_name
order by net_sales desc;

/*“What percentage of total net sales does each market contribute?”*/

select m.markets_name , sum(t.sales_amount) as net_sales, round ( sum(t.sales_amount) * 100 /sum(sum(t.sales_amount)) over(),2) as contribution_pct
from transactions t
join markets m
on t.market_code = m.markets_code
group by m.markets_name
order by contribution_pct desc;

/*“Which markets contribute less than 5% of total revenue?”*/

select *
from (select m.markets_name , sum(t.sales_amount) as net_sales, round ( sum(t.sales_amount) * 100 /sum(sum(t.sales_amount)) over(),2) as contribution_pct
from transactions t
    JOIN markets m
        ON t.market_code = m.markets_code
    GROUP BY m.markets_name)a
WHERE contribution_pct < 5
ORDER BY contribution_pct DESC;

/*Product Analysis*/

/*Which products generate the highest net sales?*/

select p.product_type , sum(t.sales_amount) as net_sales
from transactions t 
join products p 
on t.product_code = p.product_code
group by p.product_type
order by net_sales desc;

/*How does revenue compare to quantity sold across product types?*/

select p.product_type, sum(t.sales_qty) as total_quantity,sum(t.sales_amount) as net_sales
from transactions t 
join products p 
on t.product_code = p.product_code
group by p.product_type
order by net_sales desc;

/*How much revenue does each unit generate?*/

select p.product_type, sum(t.sales_qty) as total_quantity,sum(t.sales_amount) as net_sales,round(sum(t.sales_amount)/sum(t.sales_qty) , 2) as revenue_per_unit
from transactions t 
join products p 
on t.product_code = p.product_code
group by p.product_type
order by net_sales desc;

/*Customer Analysis*/

/*How is revenue distributed across customer types?*/

select c.customer_type , sum(t.sales_amount) as net_sales
from transactions t
join customers c
on t.customer_code = c.customer_code
group by c.customer_type
order by net_sales desc;

/*Who are the top customers by net sales, and how concentrated is revenue among them?*/

select c.custmer_name , sum(t.sales_amount) as net_sales
from transactions t
join customers c 
on t.customer_code = c.customer_code
group by c.custmer_name
order by net_sales desc
limit 10;

/*What percentage of total revenue comes from the top customers?*/

select 
    c.custmer_name,
    sum(t.sales_amount) as net_sales,
    round(
        sum(t.sales_amount) * 100 
        / sum(sum(t.sales_amount)) over (),
        2
    ) as contribution_pct
from transactions t
join customers c
    on t.customer_code = c.customer_code
group by c.custmer_name
order by net_sales desc;






