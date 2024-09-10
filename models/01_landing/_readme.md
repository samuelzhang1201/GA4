1. Data loading into landing area:
Best practice:
As the GA4 tables are multiple tables with same table structure and may increase day by day, based on my experience with AWS and snowflake tech stacks, I would use following method to load raw data:
- Use Mulesoft or fivetran to grab data from GA4 and load into AWS S3 bucket;
- Setup Snowflake-S3 integration
- Setup S3 event push to snowflake external stage area
- Setup Snowflake stream and snow pipe to load new files into snowflake tables continuously.


My workaround here in the case:
- create a marco to list all table names using INFORMATION_SCHEMA
- Use dbt_utils package to union all tables as a table
- I believe there must be similar ways to pipeline the additional files adding to the landing schema as if I suggested in snowflake and S3, but I am not going to spend time to build such cloud function for this particular case. Instead i will focus on modelling.
- ga4_raw.sql is considered to be an app fetching raw data from source system.