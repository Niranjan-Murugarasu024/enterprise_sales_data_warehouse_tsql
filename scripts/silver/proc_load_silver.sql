/* 
=============================================
Stored Procedure : Load data from Bronze -> Silver 
=============================================
Script Procedure : 
   This stored procedure perform ETL process (Extract , Transform , Load) to load the data in the tables in Silver schema from Bronze schema 
Process Performed : 
    Truncated the existing tables 
    Load the data in the tables (Performs Full Load Operation)
Parameters : None 
    It will not accept any values as parameters and return any values 

Execution :
  EXEC silver.load_silver
=============================================
*/
create or alter procedure silver.load_silver as 
begin 
    begin try
    declare @starttime datetime , @endtime datetime , @batch_starttime datetime , @batch_endtime datetime;
    set @batch_starttime = getDate();
	PRINT '===========================';
	PRINT 'Loading Silver Layer';
	PRINT '===========================';

	set @starttime = getDate();
	PRINT '---------------------------';
	PRINT 'Loading CRM  TABLE';
	PRINT '---------------------------';
	PRINT '>>>Truncating table  :silver.crm_cust_info';
	truncate table silver.crm_cust_info;
	print 'Inserting data in table:silver.crm_cust_info';
	insert into silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_last_name,
	cst_marital_status,
	cst_gndr,
	cst_create_date
	)
	select
	cst_id,
	cst_key,
	trim(cst_firstname) as first_name,
	trim(cst_last_name) as last_name,
	case when upper(trim(cst_marital_status)) = 'S' then 'Single'
		 when upper(trim(cst_marital_status)) = 'M' then 'Married'
		 else 'n/a'
	end cst_material_status,

	case when upper(trim(cst_gndr)) = 'M' then 'Male'
		 when upper(trim(cst_gndr)) = 'F' then 'Female'
		 else 'n/a'
	end cst_gndr,
	cst_create_date
	from (select *, Row_NUMBER() OVER (PARTITION BY cst_id order by cst_create_date desc) as flag_test from bronze.crm_cust_info where cst_id is not null )t  where flag_test=1;
    set @endtime = getDate();
	print 'Duration ' + cast(datediff(second , @starttime , @endtime) as nvarchar) + ' seconds';
	print '-------------------------';

	set @starttime = getDate();
	PRINT '>>>Truncating table  :silver.crm_prd_info';
	truncate table silver.crm_prd_info;
	print 'Inserting data in table:silver.crm_prd_info';
	insert into silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
	)
	select 
	prd_id,
	replace(substring(prd_key , 1,5),'-','_') as cat_id ,
	substring(prd_key , 7 , len(prd_key)) as prd_key,
	prd_nm,
	isnull(prd_cost,0) as prd_cost,
	case upper(trim(prd_line)) 
	  when 'M' then 'Mountain'
	  when 'R' then 'Road'
	  when 'S' then 'Other_Sales'
	  when 'T' then 'Touring'
	  else 'n/a'
	  end as prd_line,
	CAST(prd_start_dt as  date) as prd_start_dt,
	CAST(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date)  as prd_end_dt
	from bronze.crm_prd_info; 
	set @endtime = getDate();
	print 'Duration ' + cast(datediff(second , @starttime , @endtime) as nvarchar) + ' seconds';
	print '-------------------------';

	set @starttime = getDate();
	PRINT '>>>Truncating table  :silver.crm_sales_details';
	truncate table silver.crm_sales_details;
	print 'Inserting data in table:silver.crm_sales_details';
	insert into silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
	)
	select sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	case when sls_order_dt = 0 or len(sls_order_dt) !=8  then null 
		else cast(cast(sls_order_dt as nvarchar) as date)
	end as sls_order_dt,
	case when sls_ship_dt = 0 or len(sls_ship_dt) !=8  then null 
		else cast(cast(sls_ship_dt as nvarchar) as date)
	end as sls_ship_dt,
	case when sls_due_dt = 0 or len(sls_due_dt) !=8  then null 
		else cast(cast(sls_due_dt as nvarchar) as date)
	end as sls_due_dt,
	case when sls_sales is null or sls_sales <=0 or sls_sales != sls_quantity * abs(sls_price)
		then sls_quantity * abs(sls_price)
		else sls_sales
	end as sls_sales,
	sls_quantity,
	case when sls_price is null or sls_price <=0
		then sls_sales / NULLIF(sls_quantity,0)
		else sls_price
	end as sls_price from bronze.crm_sales_details;  
	set @endtime = getDate();
	print 'Duration ' + cast(datediff(second , @starttime , @endtime) as nvarchar) + ' seconds';
	print '-------------------------';

	set @starttime = getDate();
	PRINT '>>>Truncating table  :silver.erp_cust_az12';
	truncate table silver.erp_cust_az12;
	print 'Inserting data in table:silver.erp_cust_az12';
	insert into silver.erp_cust_az12(
	cid,
	bdate,
	gen
	)
	select
	case when cid like 'NAS%' then substring(cid ,4,len(cid))
		else cid
	end as cid,
	case when bdate> getDate() then null
		else bdate
	end as bdate,
	case when upper(trim(gen)) in ('F','FEMALE') then 'Female'
		 when upper(trim(gen)) in ('M','MALE') then 'Male'
		 else 'n/a'
	end as gen
	from bronze.erp_cust_az12;
	set @endtime = getDate();
	print 'Duration ' + cast(datediff(second , @starttime , @endtime) as nvarchar) + ' seconds';
	print '-------------------------';

	set @starttime = getDate();
	PRINT '>>>Truncating table  :silver.erp_loc_a101';
	truncate table silver.erp_loc_a101;
	print 'Inserting data in table:silver.erp_loc_a101';
	insert into silver.erp_loc_a101(
	cid,
	cntry
	)
	select replace(cid,'-','') as cid,
	case when trim(cntry) = 'DE' then 'Germany'
		when trim(cntry) in ('US','USA') then 'United States'
		when trim(cntry) is null or cntry = '' then 'n/a'
		else trim(cntry)
	end as cntry from bronze.erp_loc_a101; 
	set @endtime = getDate();
	print 'Duration ' + cast(datediff(second , @starttime , @endtime) as nvarchar) + ' seconds';
	print '-------------------------';

	set @starttime = getDate();
	PRINT '>>>Truncating table  :silver.erp_px_cat_g1V2';
	truncate table silver.erp_px_cat_g1V2;
	print 'Inserting data in table:silver.erp_px_cat_g1V2';
	insert into silver.erp_px_cat_g1V2 
	(
	id,
	cat,
	subcat,
	maintenance
	)
	select id, cat, subcat, maintenance from bronze.erp_px_cat_g1V2;
	set @endtime = getDate();
	print 'Duration ' + cast(datediff(second , @starttime , @endtime) as nvarchar) + ' seconds';
	print '-------------------------';

	PRINT '=======================';
	PRINT 'Procedure Completed';
	PRINT '=======================';
	set @batch_endtime = getDate();
	PRINT '=======================';
	PRINT 'TOTAL BATCH_TIME COMPLETED ';
	PRINT 'Total  batch_time  '+ cast(datediff(second,@batch_starttime , @batch_endtime) as nvarchar) + ' seconds';
	PRINT '=======================';


END try
begin catch 
	print 'Error Occured during Silver table initialization';
	print '================================================';
	print 'Error Message ' + ERROR_MESSAGE();
	PRINT 'Error Message ' + CAST(Error_Number() as nvarchar);
	print 'Error Message' + CAST(Error_state() as nvarchar);
	print '================================================';
end catch 
end;

-- exec silver.load_silver;
