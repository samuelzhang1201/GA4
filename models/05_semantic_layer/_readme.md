

 you can list some dimensions by using command in dbt cloud CLI
 ./dbt sl list dimensions --metrics total_new_users
 
![image](https://github.com/user-attachments/assets/057fc734-0167-4d5a-acec-d9fde0e6b647)


then you can query the metrics using command:
./dbt sl query --metrics total_new_users --group-by fact_session_pk__is_search_included 

![image](https://github.com/user-attachments/assets/830a94ad-55dc-4234-98c6-17472cf29091)

you can select any graun you like or add timespine analysis.


you can list all metrics and dimensions:
by ./dbt sl list metrics
![image](https://github.com/user-attachments/assets/bd977eab-f3bf-4a6d-8ba6-07e04a854d71)


you can find total_sessions_with_search group by conutries
![image](https://github.com/user-attachments/assets/dd478246-35e0-4a10-827a-b47869424435)


you can find total_sessions_with_search group by new/old users

![image](https://github.com/user-attachments/assets/3d618351-6fa5-4fec-96fc-0a1e8170348d)
