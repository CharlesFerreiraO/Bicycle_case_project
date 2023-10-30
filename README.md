# Case study project

# Scenario

I'm a junior data analyst where I'm part of a marketing team for a bike rental company and I've been given the role of figuring out customers' average time on bikes


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

Depois criei uma nova variável como segunda versão para remover alguns dados ruim que apresentavam.

Fiz resumo da nova variável específica da coluna para se ter uma noção dos resultados da "ride_length".

Os agreguei e fiz uma comparação nos dados das colunas "ride_length" e "member_casual". Para saber a comparação de tempo entre os membros.

Por fim fiz a função "ggplot" para mostrar um gráfico que mostrasse quais membros mais usam as bicicletas, e quais dias da semana elas mais são usadas. Mostrando que os clientes membros usam mais do que os clientes casuais.
