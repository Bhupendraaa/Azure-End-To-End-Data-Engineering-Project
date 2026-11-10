CREATE SCHEMA gold;

---------Create VIEW

CREATE VIEW gold.calendar
AS
SELECT *
FROM OPENROWSET(
    BULK 'https://awstoragedatalakee06.blob.core.windows.net/silver/AdventureWorks_Calendar/',
    FORMAT = 'PARQUET'
) AS Q;
GO

CREATE VIEW gold.cust
AS
SELECT *
FROM OPENROWSET(
    BULK 'https://awstoragedatalakee06.blob.core.windows.net/silver/AdventureWorks_Customers/',
    FORMAT = 'PARQUET'
) AS Q;
GO

CREATE VIEW gold.Product_Categories
AS
SELECT *
FROM OPENROWSET(
    BULK 'https://awstoragedatalakee06.blob.core.windows.net/silver/AdventureWorks_Product_Categories/',
    FORMAT = 'PARQUET'
) AS Q;
GO

CREATE VIEW gold.prosubcat
AS
SELECT *
FROM OPENROWSET(
    BULK 'https://awstoragedatalakee06.blob.core.windows.net/silver/AdventureWorks_Product_Subcategories/',
    FORMAT = 'PARQUET'
) AS Q;
GO

CREATE VIEW gold.products
AS
SELECT *
FROM OPENROWSET(
    BULK 'https://awstoragedatalakee06.blob.core.windows.net/silver/AdventureWorks_Products/',
    FORMAT = 'PARQUET'
) AS Q;
GO

CREATE VIEW gold.ret
AS
SELECT *
FROM OPENROWSET(
    BULK 'https://awstoragedatalakee06.blob.core.windows.net/silver/AdventureWorks_Returns/',
    FORMAT = 'PARQUET'
) AS Q;
GO

CREATE VIEW gold.sales
AS
SELECT *
FROM OPENROWSET(
    BULK 'https://awstoragedatalakee06.blob.core.windows.net/silver/AdventureWorks_Sales/',
    FORMAT = 'PARQUET'
) AS Q;
GO

CREATE VIEW gold.terr
AS
SELECT *
FROM OPENROWSET(
    BULK 'https://awstoragedatalakee06.blob.core.windows.net/silver/AdventureWorks_Territories/',
    FORMAT = 'PARQUET'
) AS Q;
GO


--------------------------------------------------------------------------------------------------
select * FROM gold.cust

----------------------------------------------------------------------
---LAST

CREATE DATABASE SCOPED CREDENTIAL cred_ansh
WITH 
    IDENTITY = 'Managed Identity'

    CREATE EXTERNAL DATA SOURCE source_silver
    WITH
    (
        LOCATION = 'https://awstoragedatalakee06.blob.core.windows.net/silver/',
        CREDENTIAL = cred_ansh
    )

     CREATE EXTERNAL DATA SOURCE source_gold
    WITH
    (
        LOCATION = 'https://awstoragedatalakee06.blob.core.windows.net/gold',
        CREDENTIAL = cred_ansh
    )

    CREATE EXTERNAL FILE FORMAT format_parquet
    WITH
    (
        FORMAT_TYPE = PARQUET,
        DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
    )


    CREATE EXTERNAL TABLE gold.extsales
    WITH
    (
        LOCATION = 'extsales',
        DATA_SOURCE = source_gold,
        FILE_FORMAT = format_parquet
    )
    AS
    SELECT * FROM gold.sales