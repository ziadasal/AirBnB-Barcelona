## Airbnb ETL Pipeline from Staging Layer to SQL Server

This README provides an overview of the ETL (Extract, Transform, Load) pipeline for the Airbnb data from the staging layer in SQL Server to a SQL Server database. The pipeline involves extracting data from SQL Server, performing transformations using Python, and loading the transformed data into the destination SQL Server database.

### Extract

We start by connecting to the SQL Server staging layer where the Airbnb data is stored. We extract three main tables: `calendar`, `listings`, and `reviews`. These tables contain information about the availability, details of listings, and reviews respectively.

### Transform

After extracting the data, we perform several transformations using Python and pandas DataFrame:

1. **Date Dimension Table Creation**: We generate a date range from the minimum to maximum dates found in the `calendar` and `reviews` tables. This serves as the basis for our date dimension table, where we extract year, month, day, season, and quarter information.
   
2. **Cleaning and Formatting**: We clean and format the extracted data to ensure consistency and correctness. This includes converting date columns to datetime format, handling missing values, and formatting prices.

3. **Filtering and Column Selection**: We filter out unnecessary columns and select only the relevant columns for further processing. For example, we drop columns such as URLs, IDs, and descriptive information that are not needed for analysis.

### Load

Once the transformations are complete, we load the transformed data into the destination SQL Server database, which we refer to as `Airbnb_DWH` (Data Warehouse). We use SQLAlchemy to create a connection engine and upload the transformed DataFrames into respective tables in the database.

### Summary

This ETL pipeline automates the process of extracting data from the staging layer in SQL Server, performing necessary transformations using Python, and loading the transformed data into a SQL Server database. It ensures that the data in the destination database is clean, formatted, and ready for analysis.
