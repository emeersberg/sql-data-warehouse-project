/*
===============================================================================
Project: Data Warehouse
Purpose: Creates the DataWarehouse database and Bronze, Silver, and Gold schemas
===============================================================================
*/

USE master;
GO

-- Create the database only if it does not already exist
IF DB_ID(N'DataWarehouse') IS NULL
BEGIN
    CREATE DATABASE DataWarehouse;
    PRINT 'Database DataWarehouse created successfully.';
END
ELSE
BEGIN
    PRINT 'Database DataWarehouse already exists.';
END;
GO

USE DataWarehouse;
GO

-- Create the Bronze schema for raw source data
IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = N'bronze'
)
BEGIN
    EXEC(N'CREATE SCHEMA bronze');
    PRINT 'Schema bronze created successfully.';
END
ELSE
BEGIN
    PRINT 'Schema bronze already exists.';
END;
GO

-- Create the Silver schema for cleaned and transformed data
IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = N'silver'
)
BEGIN
    EXEC(N'CREATE SCHEMA silver');
    PRINT 'Schema silver created successfully.';
END
ELSE
BEGIN
    PRINT 'Schema silver already exists.';
END;
GO

-- Create the Gold schema for business-ready analytical data
IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = N'gold'
)
BEGIN
    EXEC(N'CREATE SCHEMA gold');
    PRINT 'Schema gold created successfully.';
END
ELSE
BEGIN
    PRINT 'Schema gold already exists.';
END;
GO
