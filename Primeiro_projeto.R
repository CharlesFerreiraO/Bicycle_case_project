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