# Case study project

# Scenario

I'm a junior data analyst, I'm part of a marketing team at a bike rental company and I was tasked with finding out the average time customers use bikes from 2019 and 2020.


# Analysis process

First I downloaded the data from the Amazon AWS platform as it is open data. With it I obtained several data from 2013-2020, however, I downloaded the data from 2019-2020 as it contained a lot of data and was more recent.

Soon after, I imported them into RStudio and created new variables with "<-" which is called "receive" in the R language. After creating these new variables, I placed them with the "colnames()" function and did them one by one to know the name of all the columns in the tables.

Once you know all the columns in the tables, rename the 2019 columns with the same name as the 2020 columns (to make it easier to work with them).

I also used the "str()" function which allows me to know the type of data that each column contains. Once I did this I realized that the 2019 columns had different data types than the description that the column said. Realizing this I used the "mutate" function to change the type of data they previously had.

Then I created a new variable called "all-trips" and combined all the columns into a single table.

I saw that there were data that I was not interested in and immediately removed them from my table. Like replacing the old variable I created with a new one on top of it.

Then I carried out a series of processes to find out the names of the columns, the number of rows, the size of the cells, the table summary and finally the variables contained in it.

Then I wrote the "table()" function and placed the "casual_members" column to see if there were some different things about the customers and I was presented with 4 different types of names. Then I changed it to just 2 names, making it easier to see what's to come. I checked again to see if there was anything wrong and saw that everything was fine as I wanted.

After that, I separated the dates in the table into different columns by: day, month, year and day of the week in the format "Date".

I created the "ride_lenght" column in the table as a combination of two other columns in the table that were data and form the time in seconds of use per customer.

Then I created a new variable as a second version to remove some bad data that was presented.

I summarized the new column-specific variable to get an idea of ​​the results of "ride_length".

I aggregated them and compared the data in the "ride_length" and "member_casual" columns. To know the time comparison between members.

Finally, I made the "ggplot" function to show a graph that showed which members use the bikes the most, and which days of the week they are used the most. Showing that member customers use it more than casual customers.

## Codes

```
#Creating new variables

q2_2019 <- Divvy_Trips_2019_Q2
q3_2019 <- Divvy_Trips_2019_Q3
q4_2019 <- Divvy_Trips_2019_Q4
q1_2020 <- Divvy_Trips_2020_Q1

#Querying the name of table columns

colnames(q3_2019)
colnames(q4_2019)
colnames(q2_2019)
colnames(q1_2020)

#Renaming table columns to be easier to work with

(q4_2019 <- rename(q4_2019
                   ,ride_id = trip_id
                   ,rideable_type = bikeid 
                   ,started_at = start_time  
                   ,ended_at = end_time  
                   ,start_station_name = from_station_name 
                   ,start_station_id = from_station_id 
                   ,end_station_name = to_station_name 
                   ,end_station_id = to_station_id 
                   ,member_casual = usertype))

(q3_2019 <- rename(q3_2019
                   ,ride_id = trip_id
                   ,rideable_type = bikeid 
                   ,started_at = start_time  
                   ,ended_at = end_time  
                   ,start_station_name = from_station_name 
                   ,start_station_id = from_station_id 
                   ,end_station_name = to_station_name 
                   ,end_station_id = to_station_id 
                   ,member_casual = usertype))

(q2_2019 <- rename(q2_2019
                   ,ride_id = "01 - Rental Details Rental ID"
                   ,rideable_type = "01 - Rental Details Bike ID" 
                   ,started_at = "01 - Rental Details Local Start Time"  
                   ,ended_at = "01 - Rental Details Local End Time"  
                   ,start_station_name = "03 - Rental Start Station Name" 
                   ,start_station_id = "03 - Rental Start Station ID"
                   ,end_station_name = "02 - Rental End Station Name" 
                   ,end_station_id = "02 - Rental End Station ID"
                   ,member_casual = "User Type"))


#Identifying the types of data present in each column

str(q1_2020)
str(q4_2019)
str(q3_2019)
str(q2_2019)

#Transforming the data that was different into the same data that is in the 2020 table

q4_2019 <-  mutate(q4_2019, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 
q3_2019 <-  mutate(q3_2019, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 
q2_2019 <-  mutate(q2_2019, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 

#Creating a new variable with all table columns

all_trips <- bind_rows(q2_2019, q3_2019, q4_2019, q1_2020)

#Deleting tables that had no values ​​or were not needed

all_trips <- all_trips %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng, birthyear, gender, "01 - Rental Details Duration In Seconds Uncapped", "05 - Member Details Member Birthday Year", "Member Gender", "tripduration"))

#Identifying each value in the table

colnames(all_trips)
nrow(all_trips)
dim(all_trips)
head(all_trips)
summary(all_trips)

#Checking if all usernames were correct
table(all_trips$member_casual)

#Changing the names to only have two types of customers

all_trips <-  all_trips %>% 
  mutate(member_casual = recode(member_casual
                                ,"Subscriber" = "member"
                                ,"Customer" = "casual"))


#Transforming and formatting new columns for different dates

all_trips$date <- as.Date(all_trips$started_at) 
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

#Creating a new column for the table that contains customers' counted times

all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)

#Inspecting table columns

str(all_trips)

#Converting the "ride_length" column from factor to numeric

is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)

#Creating a new variable as I will remove the bad data from the previous table

all_trips_v2 <- all_trips[!(all_trips$start_station_name == "HQ QR" | all_trips$ride_length<0),]

#Analyzing all values ​​in the "ride length" column

summary(all_trips_v2$ride_length)

#Comparing customer time

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

#Checking the average time of member customers versus casual customers

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

#Calculating the average travel time of customers per day

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

#Analyzing travel data by type and day of the week

all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%  
  summarise(number_of_rides = n()							 
  ,average_duration = mean(ride_length)) %>% 		
  arrange(member_casual, weekday)		

#Viewing the number of trips per passenger

all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

#Medium duration view

all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

#Then I create a new variable with a table of the three columns shown in the graph

counts <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

#Exporting the file to .csv

write.csv(counts, "Novo volume", row.names = FALSE)

```

## Preview result

### Visualization using RStudio with the ggplot package
<div align=center>
  <img src="https://github.com/CharlesFerreiraO/Projetos-de-estudo-de-caso/assets/149080159/a93ad188-f64a-43a2-8e44-914af8d827c8" width:"300px"/>
</div>


### Result visualization with Tableau
### Better visualization through Tableau
* https://public.tableau.com/app/profile/charles.ferreira/viz/EstudodecasoMdiadeduraodeusodebicicletasalugadas/Planilha1#1
<div align=center>
  <img src="https://github.com/CharlesFerreiraO/Projetos-de-estudo-de-caso/assets/149080159/f736d923-7654-4d5f-88c1-025d7b2d2436" width:"300px"/>
</div>



