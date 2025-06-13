# Specify the database
use mavenfuzzyfactory; 

# Find top traffic sources
select utm_source, utm_campaign, http_referer, count(distinct website_session_id) as number_of_sessions
from website_sessions
where created_at <'2012-04-12'
Group by utm_source, utm_campaign, http_referer
Order by number_of_sessions desc;  

# Traffic Source Conversions
select count(distinct website_sessions.website_session_id) as sessions, Count(distinct orders.order_id) as orders,  Count(distinct orders.order_id)/ count(distinct website_sessions.website_session_id) as session_to_conv_rate
from website_sessions
left join orders on orders.website_session_id = website_sessions.website_session_id
where website_sessions.created_at <'2012-04-14'
AND utm_source= 'gsearch'
AND utm_campaign = 'nonbrand'; 

# Bid optimization & Trend Analysis
select 
YEAR(created_at), 
WEEK(created_at), 
MIN(Date(created_at)) as week_start,
Count(Distinct website_session_id) as sessions
 from website_sessions
where website_session_id between 100000 and 115000
group by 1, 2; 

# Count single and two items orders by primary product id
select 
	primary_product_id, 
    COUNT(Distinct CASE WHEN items_purchased=1 THEN order_id ELSE NULL END ) As count_single_item_orders, 
    COUNT(DIstinct CASE WHEN items_purchased=2 THEN order_id ELSE NULL END) As count_two_item_orders
from orders
where order_id between 31000 and 32000
group by primary_product_id; 

# Traffic source trending
Select 
	-- YEAR(created_at),
    -- WEEK(created_at), 
    MIN(Date(created_at)) as week_start,
	Count(distinct website_session_id) as count_of_sessions
from website_sessions
where created_at<'2012-05-12' and utm_source = 'gsearch' and utm_campaign = 'nonbrand'
group by YEAR(created_at), WEEK(created_at); 

# Bid optimization for paid traffic 
select 
	device_type,
    count(distinct website_sessions.website_session_id) as sessions, 
    count(distinct order_id) as orders, 
    count(distinct order_id)/count(distinct website_sessions.website_session_id) as conv_rate
from website_sessions
left join orders on website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at <'2012-05-11'and utm_source = 'gsearch' and utm_campaign = 'nonbrand'
group by device_type; 

# Trending with granular segments 
select 
	MIN(Date(created_at)) as week_start,
    Count(Distinct CASE WHEN device_type='mobile' THEN website_session_id ELSE NULL END) As mobile_sessions, 
    Count(Distinct CASE WHEN device_type='desktop' THEN website_session_id ELSE NULL END) As desktop_sessions
from website_sessions
where created_at Between '2012-04-15' and '2012-06-09' and utm_source = 'gsearch' and utm_campaign = 'nonbrand' 
Group by YEAR(created_at), WEEK(created_at); 
