/*
=================================
DDL Script : Create Silver Table
=================================
Script Purpose : 
   This command will create tables in Silver Schema drop exisiting tables if existed 
   This is been associated in order to transform and Load in Silver Layer (Transformation phase where the metadata might be changed in order to preserve the Table) 
=================================


*/

if object_id('silver.crm_cust_info','u') is not null
   drop table silver.crm_cust_info;
GO 
CREATE TABLE silver.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_last_name nvarchar(50),
	cst_marital_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date,
	dwh_create_date datetime2 default getDate()
);
GO

if object_id('silver.crm_prd_info','u') is not null
   drop table silver.crm_prd_info;
GO
CREATE TABLE silver.crm_prd_info(
	prd_id int,
	cat_id nvarchar(50),
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date datetime2 default getDate()
);
GO

if object_id('silver.crm_sales_details','u') is not null
   drop table silver.crm_sales_details;
GO 

CREATE TABLE silver.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int,
	dwh_create_date datetime2 default getDate()
); 
GO 

if object_id('silver.erp_cust_az12','u') is not null
   drop table silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12(
	cid nvarchar(50),
	bdate date,
	gen nvarchar(50),
	dwh_create_date datetime2 default getDate()
);
GO

if object_id('silver.erp_loc_a101','u') is not null
   drop table silver.erp_loc_a101;
GO 

CREATE TABLE silver.erp_loc_a101(
	cid nvarchar(50),
	cntry nvarchar(50),
	dwh_create_date datetime2 default getDate()
);
GO 


if object_id('silver.erp_px_cat_g1V2','u') is not null
   drop table silver.erp_px_cat_g1V2;
GO 

CREATE TABLE silver.erp_px_cat_g1V2(
	id nvarchar(50),
	cat nvarchar(50),
	subcat nvarchar(50),
	maintenance nvarchar(50),
	dwh_create_date datetime2 default getDate() 
);
GO 
