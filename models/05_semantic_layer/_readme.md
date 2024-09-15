Use the mf prefix before the command name to execute them in dbt Core. For example, to list all metrics, run mf list metrics.

list — Retrieves metadata values.
list metrics — Lists metrics with dimensions.
list dimensions — Lists unique dimensions for metrics.
list dimension-values — List dimensions with metrics.
list entities — Lists all unique entities.
validate-configs — Validates semantic model configurations.
health-checks — Performs data platform health check.
tutorial — Dedicated MetricFlow tutorial to help get you started.
query — Query metrics and dimensions you want to see in the command line interface. Refer to query examples to help you get started.



dbt sl query --metrics <metric_name> --group-by <dimension_name> # In dbt Cloud 
dbt sl query --saved-query <name> # In dbt Cloud CLI

mf query --metrics <metric_name> --group-by <dimension_name> # In dbt Core

Options:

  --metrics SEQUENCE       Syntax to query single metrics: --metrics metric_name
                           For example, --metrics bookings
                           To query multiple metrics, use --metrics followed by the metric names, separated by commas without spaces.
                           For example,  --metrics bookings,messages

  --group-by SEQUENCE      Syntax to group by single dimension/entity: --group-by dimension_name
                           For example, --group-by ds
                           For multiple dimensions/entities, use --group-by followed by the dimension/entity names, separated by commas without spaces.
                           For example, --group-by ds,org
                           

  --end-time TEXT          Optional iso8601 timestamp to constraint the end
                           time of the data (inclusive).
                           *Not available in dbt Cloud yet 

  --start-time TEXT        Optional iso8601 timestamp to constraint the start
                           time of the data (inclusive)
                           *Not available in dbt Cloud yet

  --where TEXT             SQL-like where statement provided as a string and wrapped in quotes: --where "condition_statement"
                           For example, to query a single statement: --where "revenue > 100"
                           To query multiple statements: --where "revenue > 100 and user_count < 1000"
                           To add a dimension filter to a where filter, ensure the filter item is part of your model. 
                           Refer to the FAQ for more info on how to do this using a template wrapper.

  --limit TEXT             Limit the number of rows out using an int or leave
                           blank for no limit. For example: --limit 100

  --order-by SEQUENCE     Specify metrics, dimension, or group bys to order by.
                          Add the `-` prefix to sort query in descending (DESC) order. 
                          Leave blank for ascending (ASC) order.
                          For example, to sort metric_time in DESC order: --order-by -metric_time 
                          To sort metric_time in ASC order and revenue in DESC order:  --order-by metric_time,-revenue

  --csv FILENAME           Provide filepath for data frame output to csv

 --compile (dbt Cloud)    In the query output, show the query that was
 --explain (dbt Core)     executed against the data warehouse         
                           

  --show-dataflow-plan     Display dataflow plan in explain output

  --display-plans          Display plans (such as metric dataflow) in the browser

  --decimals INTEGER       Choose the number of decimal places to round for
                           the numerical values

  --show-sql-descriptions  Shows inline descriptions of nodes in displayed SQL

  --help                   Show this message and exit.