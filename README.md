Modelling Principle:

high level: 
conceptual model->logical model->physical model.

low level:
Landing-> cleansed-> enterprise->presentation->semantic layer


dbt env setup:
I have Dev and Prod environments, however, in real world, we will have dev, staging, and prod. For this case study, I just skip staging environment.

CI/CD:
I developed on my dev, and push to github remote, when create PR against prod, will automatically trigger a slim_ci test, which will test all changed nodes from last status.

pipeline:
Can use cloud scheduler or use airflow to pipeline.

semantic layer:
I use cloud cli to query sl result, however, in real world, semantic layer will be conncected to BI tools such as tableau or Power BI, excel , gsheet, etc.

Ingetsion:
I am not familar with GCP(I am AWS and snowflake user). But generally speaking, I need to load data into GCS (simliar to AWS S3 bucket), and then load into landing area.
in snowflake, I may use snowpipe and steam function to pipeline, and setup AWS S3 event trigger to snowflake. I believe in GCP we may have similar function.

