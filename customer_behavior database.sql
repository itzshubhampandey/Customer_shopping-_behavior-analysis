use customer_behavior;
select * from customer
limit 20;
-- Q1. What is the total revenue genrated by male vs. female customers ?

select gender, sum(purchase_amount) as revenue
from customer
group by gender;

-- Q2. which customer used a discount but still spent more than the average purchase amount ?
select customer_id, purchase_amount 
from customer
where discount_applied= 'yes'
and purchase_amount>= (select avg( purchase_amount) from customer);

-- Q3. which are the top 5 products with the highest avrage review rating ?
select item_purchased,
round(avg(review_rating),2) as Average_product_rating 
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

-- Q4. compare the average purchase amounts between standard and express shipping  ?
select shipping_type ,
round(avg(purchase_amount),2)
from customer
where shipping_type in('standard','express')
group by shipping_type ;

-- Q5. Do subscribed customers spend more? Compare average spend and total revenue 
-- between subscribers and non-subscribers.
select subscription_status, count(customer_id) as Total_customer,
round(avg(purchase_amount),2) as Average_spend,
round(sum(purchase_amount),2) as Total_revenue
from customer
group by subscription_status ;

-- Q6. Which 5 products have the highest percentage of purchases with discounts applied?

select item_purchased,
round(100* sum(case when discount_applied= 'yes' then 1 else 0 end )/ count(*) ,2) as Discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5 ;

-- Q7. Segment customers into New, Returning, and Loyal based on their total 
-- number of previous purchases, and show the count of each segment. 

with customer_type as ( 
select customer_id ,previous_purchases,
case
    when previous_purchases= 1 then 'New'
    when previous_purchases between 2 and 10 then 'Returning'
   else 'Loyal'
   end as customer_segment
   from customer
   )
select customer_segment, count(*) as number_of_customers
from customer_type 
group by customer_segment ;

-- Q8. What are the top 3 most purchased products within each category?

with item_count as (
select category, item_purchased,
count(customer_id) as total_order,
row_number() over(partition by category order by count(customer_id)desc) 
as item_rank
from customer
group by category, item_purchased
)
select item_rank, category, item_purchased, total_order
from item_count 
where item_rank <= 3;

-- Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;

-- Q10. What is the revenue contribution of each age group? 
SELECT 
    age_group,
    SUM(purchase_amount) AS total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue desc;













