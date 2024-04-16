# Purpuse of this project


The purpuse of this project is to apply the knowledge of the snowflake data engineering badge. For this project i will creata a data pipeline in order to retrieve the production of biomethane in france. Indeed everyday, in data.gouv the french governement publish 
a csv files with the production of biomethane in france by date, productor, are (region). The csv publish everyday contains all the historic + the production of the precedent day. 




# Schema 



![schéma biomethane](https://github.com/Francois-lenne/biomethane/assets/114836746/e55e013a-81bd-4cb9-8a93-2f83a76ab776)



## Explanation of the schema 



Like we say in the purpuse first we retrieve with the link provide by data.gouv the latest csv files. We use a google cloud function that run a python code. This python code load the csv in google cloud storage. 
This google cloud function is trigger every night at 23h00 by a google cloud scheduler and i also implement a CI/CD between this github repo and the python file. By using Google cloud deploy. Every time a file is load in the bucket a message is send to a topic. Snowflake who is a subscriber so every time a message is send in the topic a pipe is trigger in order to retrieve to integrate the last CSV into the stage table. After that every twelve hours (we can't trigger a snowpipe with an event in april 2024). We merge into the prod table the latest raw. And then we compute the metrics.



# How to implement the project


Fisrt in order to implement this project you need to have :

* Snowflake account
* GCP account with a facturation
* Activate the API of pub/sub,GCS, Cloud function, cloud schedueler
* Link you github account with google cloud build
* Having the google cloud SDK install in your local machine or VM





## 1) create the bucket 

Two way to create a bucke : 

* Using CLI
* Using the console


Important you need to create a folder inside you bucket ! 





## 2) develop the google cloud fucntions 

Develop the python program with a main function with one paramater (requets) the python program need to be name main.py (you can name the python program whatever you want but you need to modify the gcloud code).

then deploy it using this commandands in the local repository

``` Powershell
gcloud functions deploy "name_function" --runtime python39 --trigger-http --allow-unauthenticated --set-env-vars GOOGLE_CLOUD_PROJECT= [name_secret] # we set up a environnement secret for this project       
```



``` Powershell

gcloud scheduler jobs create http "name_scheduler" \
>> --schedule "0 23 * * *" \                                                                                                                     
>> --http-method GET \
>> --uri url_function \
>> --oidc-service-account-email "service-account-email" \
```




## 4) create the integration of the GCS bucket in stage


You need to follow the documentation in this link : 

https://docs.snowflake.com/en/user-guide/data-load-gcs-config 




## 5) create the pub/sub link between GCS and snowflake 


first you need to follow the documentation here :

https://docs.snowflake.com/en/user-guide/data-load-snowpipe-auto-gcs

but the documentation have two problems first you need to gave to the iam account of snowflake the monitor view right and the seconds is they use a quote between the name but that triger an error as you can see in my stack overflow blog :

https://stackoverflow.com/questions/78327105/troubleshoot-to-create-a-notification-integrations-between-gcs-and-snowflake?noredirect=1#comment138092331_78327105




## 6) create CI/CD for the python code

This video explain well how to do that :

https://www.youtube.com/watch?v=TeguiTFprFo&pp=ygUhQ0kvQ0QgZ2l0aHViIGNsb3VkIGZuY3Rpb24gcHl0aG9u

don't forget to add a .cloudingore for ignoring all the file that isn't useful (copy my file) 




## 7) Create CI/CD between snowflake and the github repo 

Again follow the new snowflake documentation :

https://docs.snowflake.com/en/developer-guide/git/git-overview















