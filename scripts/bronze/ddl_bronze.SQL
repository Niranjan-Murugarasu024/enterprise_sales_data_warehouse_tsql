/* 
====================================================
DDL Scripts  : Creating Bronze tables
==================================================== 
Script Purpose : 
This command will create tables in bronze schema and also it will drop the table if it already exists in order to avoid errors 
Naming rule used here : <schema_name>.<source_system>_<entity> Eg : bronze.crm_custo_info 
====================================================
*/


if object_id('bronze.crm_cust_info','u') is not null
   drop table bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname nvarchar(50),
	cst_last_name nvarchar(50),
	cst_material_status nvarchar(50),
	cst_gndr nvarchar(50),
	cst_create_date date
);

if object_id('bronze.crm_prd_info','u') is not null
   drop table bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info(
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line nvarchar(50),
	prd_start_dt datetime,
	prd_end_dt datetime
);

if object_id('bronze.crm_sales_details','u') is not null
   drop table bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
); 

if object_id('bronze.erp_cust_az12','u') is not null
   drop table bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
cid nvarchar(50),
bdate date,
gen nvarchar(50)
);

if object_id('bronze.erp_loc_a101','u') is not null
   drop table bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
cid nvarchar(50),
cntry nvarchar(50)
);

if object_id('bronze.erp_px_cat_g1V2','u') is not null
   drop table bronze.erp_px_cat_g1V2;
CREATE TABLE bronze.erp_px_cat_g1V2(
id nvarchar(50),
cat nvarchar(50),
subcat nvarchar(50),
maintenance nvarchar(50) 
);
