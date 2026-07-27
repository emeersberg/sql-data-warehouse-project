/*
===============================================================================
Project: SQL Data Warehouse
Procedure: bronze.load_bronze
Purpose:
    Performs a full refresh of all Bronze-layer tables by:

    1. Truncating the existing Bronze tables.
    2. Loading source CRM and ERP CSV files.
    3. Reporting individual and total load durations.

Notes:
    - Update the file paths to match the local dataset location.
    - SQL Server's service account must have read access to the source files.
===============================================================================
*/

USE DataWarehouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @start_time       DATETIME2(3),
        @end_time         DATETIME2(3),
        @batch_start_time DATETIME2(3);

    BEGIN TRY
        SET @batch_start_time = SYSDATETIME();

        PRINT '================================================';
        PRINT 'Starting Bronze Layer Load';
        PRINT '================================================';

        BEGIN TRANSACTION;

        /*
        -----------------------------------------------------------------------
        Load CRM tables
        -----------------------------------------------------------------------
        */

        PRINT '';
        PRINT '------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------';

        SET @start_time = SYSDATETIME();

        PRINT '>> Truncating bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Loading bronze.crm_cust_info';

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\meeeri0308\Dropbox\To_Do_List\SQL Data Warehouse Project\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = SYSDATETIME();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF_BIG(MILLISECOND, @start_time, @end_time) AS VARCHAR(20))
            + ' ms';


        SET @start_time = SYSDATETIME();

        PRINT '>> Truncating bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Loading bronze.crm_prd_info';

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\meeeri0308\Dropbox\To_Do_List\SQL Data Warehouse Project\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = SYSDATETIME();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF_BIG(MILLISECOND, @start_time, @end_time) AS VARCHAR(20))
            + ' ms';


        SET @start_time = SYSDATETIME();

        PRINT '>> Truncating bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Loading bronze.crm_sales_details';

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\meeeri0308\Dropbox\To_Do_List\SQL Data Warehouse Project\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = SYSDATETIME();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF_BIG(MILLISECOND, @start_time, @end_time) AS VARCHAR(20))
            + ' ms';


        /*
        -----------------------------------------------------------------------
        Load ERP tables
        -----------------------------------------------------------------------
        */

        PRINT '';
        PRINT '------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------------';

        SET @start_time = SYSDATETIME();

        PRINT '>> Truncating bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Loading bronze.erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\meeeri0308\Dropbox\To_Do_List\SQL Data Warehouse Project\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = SYSDATETIME();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF_BIG(MILLISECOND, @start_time, @end_time) AS VARCHAR(20))
            + ' ms';


        SET @start_time = SYSDATETIME();

        PRINT '>> Truncating bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Loading bronze.erp_loc_a101';

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\meeeri0308\Dropbox\To_Do_List\SQL Data Warehouse Project\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = SYSDATETIME();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF_BIG(MILLISECOND, @start_time, @end_time) AS VARCHAR(20))
            + ' ms';


        SET @start_time = SYSDATETIME();

        PRINT '>> Truncating bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Loading bronze.erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\meeeri0308\Dropbox\To_Do_List\SQL Data Warehouse Project\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = SYSDATETIME();

        PRINT '>> Load duration: '
            + CAST(DATEDIFF_BIG(MILLISECOND, @start_time, @end_time) AS VARCHAR(20))
            + ' ms';

        COMMIT TRANSACTION;

        SET @end_time = SYSDATETIME();

        PRINT '';
        PRINT '================================================';
        PRINT 'Bronze Layer Load Completed Successfully';
        PRINT 'Total duration: '
            + CAST(
                DATEDIFF_BIG(
                    MILLISECOND,
                    @batch_start_time,
                    @end_time
                ) AS VARCHAR(20)
            )
            + ' ms';
        PRINT '================================================';
    END TRY

    BEGIN CATCH
        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;

        PRINT '';
        PRINT '================================================';
        PRINT 'ERROR OCCURRED DURING BRONZE LAYER LOAD';
        PRINT 'Error number:    ' + CAST(ERROR_NUMBER() AS VARCHAR(20));
        PRINT 'Error severity:  ' + CAST(ERROR_SEVERITY() AS VARCHAR(20));
        PRINT 'Error state:     ' + CAST(ERROR_STATE() AS VARCHAR(20));
        PRINT 'Error procedure: ' + COALESCE(ERROR_PROCEDURE(), 'N/A');
        PRINT 'Error line:      ' + CAST(ERROR_LINE() AS VARCHAR(20));
        PRINT 'Error message:   ' + ERROR_MESSAGE();
        PRINT '================================================';

        THROW;
    END CATCH;
END;
GO
