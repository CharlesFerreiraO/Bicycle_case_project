#Criando novas variáveis

q2_2019 <- Divvy_Trips_2019_Q2
q3_2019 <- Divvy_Trips_2019_Q3
q4_2019 <- Divvy_Trips_2019_Q4
q1_2020 <- Divvy_Trips_2020_Q1

#Consultando o nome das colunas das tabelas

colnames(q3_2019)
colnames(q4_2019)
colnames(q2_2019)
colnames(q1_2020)

#Renomeando as colunas das tabelas para serem mais fáceis de trabalhar

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


#Identificando os tipos de dados presentes em cada coluna

str(q1_2020)
str(q4_2019)
str(q3_2019)
str(q2_2019)

#Tranformando os dados que estavam diferentes nos mesmos dados que estavam na tabela de 2020

q4_2019 <-  mutate(q4_2019, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 
q3_2019 <-  mutate(q3_2019, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 
q2_2019 <-  mutate(q2_2019, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 

#Criando uma nova variável com todas colunas das tabelas

all_trips <- bind_rows(q2_2019, q3_2019, q4_2019, q1_2020)

# Excluíndo as tabelas que estavam sem valores ou que não eram necessárias

all_trips <- all_trips %>%  
  select(-c(start_lat, start_lng, end_lat, end_lng, birthyear, gender, "01 - Rental Details Duration In Seconds Uncapped", "05 - Member Details Member Birthday Year", "Member Gender", "tripduration"))

#Identificando cada valor da tabela

colnames(all_trips)
nrow(all_trips)
dim(all_trips)
head(all_trips)
summary(all_trips)

#Verificando se todos os nomes de usuários estavam corretos
table(all_trips$member_casual)

#Mudando os nomes para ficarem somente com dois tipos de clientes

all_trips <-  all_trips %>% 
  mutate(member_casual = recode(member_casual
                                ,"Subscriber" = "member"
                                ,"Customer" = "casual"))


#Transformando e formatando novas colunas para as diferentes datas

all_trips$date <- as.Date(all_trips$started_at) 
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

#Criando uma nova coluna para a tabela que contenha tempos contados dos clientes

all_trips$ride_length <- difftime(all_trips$ended_at,all_trips$started_at)

#Inspecionando as colunas das tabelas

str(all_trips)

#Convertendo a coluna "ride_length" de fator para númerico

is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)

#Criando uma nova variável já que irei remover os dados ruins da tabela anterior

all_trips_v2 <- all_trips[!(all_trips$start_station_name == "HQ QR" | all_trips$ride_length<0),]

#Analisando todos os valores da coluna "ride_length"

summary(all_trips_v2$ride_length)

#Comparando clientes membros e casuais

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)

#Verificando o tempo médio dos clientes membros versus os casuais

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

#Calculando o tempo médio de viagem dos clientes por dia

aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

#Analisando os dados de viagem por tipo e dia da semana

all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%
  group_by(member_casual, weekday) %>%  
  summarise(number_of_rides = n()							 
  ,average_duration = mean(ride_length)) %>% 		
  arrange(member_casual, weekday)		

#Visualizando o número de viagens por passageiros

all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

#Visualização de duração média

all_trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

#Depois crio uma nova variável com uma tabela de das três colunas apresentadas no gráfico

counts <- aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

#Exportando o arquivo para .csv

write.csv(counts, "Novo volume", row.names = FALSE)