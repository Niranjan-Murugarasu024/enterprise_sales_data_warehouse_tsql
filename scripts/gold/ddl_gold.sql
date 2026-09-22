/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    This gold Layer represents the star schema in Dimensions and Facts table

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

if object_id(gold.dim_customers,'V') is not null
        drop view gold.dim_customer;
go

create view gold.dim_customers as
  
select 
ROW_NUMBER() over (order by ci.cst_id) as Customer_key,
ci.cst_id as customer_id, 
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_last_name as last_name,
la.cntry as country,
ci.cst_marital_status as marital_status,
case when ci.cst_gndr != 'n/a' then ci.cst_gndr --crm is the master table
     else COALESCE(ca.gen ,'n/a') 
end as gendre,
ca.bdate as birth_date,
ci.cst_create_date as create_date
from silver.crm_cust_info ci 
 left join silver.erp_cust_az12 ca  on ci.cst_key = ca.cid
 left join silver.erp_loc_a101 la on 
ci.cst_key = la.cid 
go


if object_id(gold.dim_products , 'V') is not null
        drop view gold.dim_products;
go 
create view gold.dim_products as 
select
     row_number() over (order by pn.prd_start_dt , pn.prd_key) as Product_key,  
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	ct.cat as category,
	ct.subcat as sub_category,
	ct.maintenance as maintenance,
	pn.prd_cost as product_cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date
from silver.crm_prd_info pn
left join silver.erp_px_cat_g1V2 ct 
on pn.cat_id =ct.id where pn.prd_end_dt is null -- filter out all historical data;
go 

if object_id (gold.fact_sales , 'V') IS NOT NULL 
		drop view gold.fact_sales;
go 
create or alter view gold.fact_sales
select 
sls.sls_ord_num as order_number,
cu.Customer_key,
pr.product_key,
sls.sls_order_dt as order_date,
sls.sls_due_dt as due_date,
sls.sls_sales as sales_amount,
sls.sls_quantity as sales_quantity,
sls.sls_price price
from silver.crm_sales_details sls 
left join gold.dim_customers cu on cu.customer_id = sls.sls_cust_id
left join gold.dim_products pr on sls.sls_prd_key = pr.product_number ;
go
