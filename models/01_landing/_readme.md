1. Data loading into landing area:
Best practice:
As the GA4 tables are multiple tables with same table structure and may increase day by day, based on my experience with AWS and snowflake tech stacks, I would use following method to load raw data:
- Use Mulesoft or fivetran to grab data from GA4 and load into AWS S3 bucket;
- Setup Snowflake-S3 integration
- Setup S3 event push to snowflake external stage area
- Setup Snowflake stream and snow pipe to load new files into snowflake tables continuously.


My workaround here in the case:
- use python script to load data from public dataset into gcs
- load gcs tables into landing_ga4_raw table
