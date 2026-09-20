/*
===========================================
Stored Procedure : Load Bronze layer (Source -> Bronze) 
===========================================
Script Procedure  : 
    This stored procedure will insert the data into the bronze schema from external CSV files here Bulk insert is been used which insert large data in one go 
     Truncates the Bronze table before loading the data

Parameters : 
None 
This stored procedure will does not accept any parameters and return any values 

Usage example : 
  Exec bronze.load_bronze
===========================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze as 
begin 
	begin try
	    declare @start_time datetime , @end_time datetime , @batch_start_time datetime , @batch_end_time datetime;

		set @batch_start_time = getDate();
		PRINT '===========================';
		PRINT 'Loading Bronze Layer';
		PRINT '===========================';

		PRINT '---------------------------';
		PRINT 'Loading CRM  TABLE';
		PRINT '---------------------------';

		set @start_time = getDate();
		PRINT '>>>Truncating CRM Table';
		truncate table bronze.crm_cust_info;
		PRINT '>>> Inserting CUST_INFO data';
		bulk insert bronze.crm_cust_info from 'E:\Data_Warehousing\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		with(
		  firstrow=2,
		  fieldterminator = ',',
		  tablock
		);
		set @end_time = getDate();
		print 'Duration : '+ cast(DATEDIFF(second , @start_time , @end_time) as nvarchar) + ' seconds';
		print '--------------';


		set @start_time = getDate();
		PRINT '>>> Truncating prd table';
		truncate table bronze.crm_prd_info;
		PRINT '>>> Inserting PRD data';
		bulk insert bronze.crm_prd_info from 'E:\Data_Warehousing\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		with(
		  firstrow=2,
		  fieldterminator = ',',
		  tablock
		);
		set @end_time = getDate();
		print'Duration : ' + cast(datediff(second , @start_time , @end_time) as nvarchar) + ' seconds';
		print '--------------';


		set @start_time = getDate();
		PRINT '>>>Truncating sales details table';
		truncate table bronze.crm_sales_details;
		PRINT '>>> Inserting sales details data ';
		bulk insert bronze.crm_sales_details from 'E:\Data_Warehousing\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		with(
		  firstrow=2,
		  fieldterminator = ',',
		  tablock
		);
		set @end_time = getDate();
		print'Duration : ' + cast(datediff(second , @start_time , @end_time) as nvarchar) + ' seconds';
		print '--------------';


	
		PRINT '---------------------------';
		PRINT 'Loading ERP  TABLE';
		PRINT '---------------------------';

		set @start_time = getDate();
		PRINT '>>>Truncating ERP_cust_az12 table';
		truncate table bronze.erp_cust_az12;
		PRINT '>>>Inserting cust_az12 data';
		bulk insert bronze.erp_cust_az12 from 'E:\Data_Warehousing\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
		with(
		  firstrow=2,
		  fieldterminator = ',',
		  tablock
		);
		set @end_time = getDate();
		print'Duration : ' + cast(datediff(second , @start_time , @end_time) as nvarchar) + ' seconds';
		print '--------------';


		set @start_time = getDate();
		PRINT '>>>Truncating loc_a101 table';
		truncate table bronze.erp_loc_a101;
		PRINT '>>>Inserting loc_a101 data';
		bulk insert bronze.erp_loc_a101 from 'E:\Data_Warehousing\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
		with(
		  firstrow=2,
		  fieldterminator = ',',
		  tablock
		);
		set @end_time = getDate();
		print'Duration  : ' + cast(datediff(second , @start_time , @end_time) as nvarchar) + ' seconds';
		print '--------------';


	    set @start_time = getDate();
		PRINT '>>>Truncating erp_px_cat_g1V2 table';
		truncate table bronze.erp_px_cat_g1V2;
		PRINT '>>>Inserting erp_px_cat_g1V2 data';
		bulk insert bronze.erp_px_cat_g1V2 from 'E:\Data_Warehousing\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
		with(
		  firstrow=2,
		  fieldterminator = ',',
		  tablock
		);
		set @end_time = getDate();
		print'Duration : ' + cast(datediff(second , @start_time , @end_time) as nvarchar) + ' seconds';
		print '--------------';

		PRINT '=======================';
		PRINT 'Procedure Completed';
		PRINT '=======================';
		set @batch_end_time = getDate();

		PRINT '=======================';
		PRINT 'TOTAL BATCH_TIME COMPLETED ';
		PRINT 'Total  batch_time  '+ cast(datediff(second,@batch_start_time , @batch_end_time) as nvarchar) + ' seconds';
		PRINT '=======================';
	END TRY

	BEGIN CATCH 
	PRINT '=====================';
	PRINT 'Error Occured during loading the Bronze layer';
	PRINT 'Error Message' + ERROR_MESSAGE();
	PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
	PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
	PRINT '=====================';
	END CATCH
END;
go 

EXEC bronze.load_bronze
