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



