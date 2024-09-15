

 you can list some dimensions by using command in dbt cloud CLI
 ./dbt sl list dimensions --metrics total_new_users
 
![image](https://github.com/user-attachments/assets/057fc734-0167-4d5a-acec-d9fde0e6b647)


then you can query the metrics using command:
./dbt sl query --metrics total_new_users --group-by fact_session_pk__is_search_included 

![image](https://github.com/user-attachments/assets/830a94ad-55dc-4234-98c6-17472cf29091)

you can select any graun you like or add timespine analysis.
