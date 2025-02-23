ex1 Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
select 
FORMAT_DATE('%Y-%m', delivered_at) as month_year, 
count(distinct user_id) as total_user,
count(order_id) as total_order
from bigquery-public-data.thelook_ecommerce.orders
where status='Complete' 
and delivered_at BETWEEN '2019-01-01 00:00:00' AND '2022-05-01 00:00:00'
group by month_year
order by month_year
visualization
ex2:  Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
select
FORMAT_DATE('%Y-%m', a.created_at) as month_year,
count(distinct a.user_id) as distinct_users,
round(sum(b.sale_price)/count(distinct a.order_id),2) as average_order_value
from bigquery-public-data.thelook_ecommerce.orders as a
join bigquery-public-data.thelook_ecommerce.order_items as b
on a.order_id=b.order_id
Where a.created_at BETWEEN '2019-01-01 00:00:00' AND '2022-05-01 00:00:00'
group by month_year
order by month_year
