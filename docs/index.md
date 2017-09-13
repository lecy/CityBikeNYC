# R Shiny App for Comparing City Bike NYC Route Traffic

# Introduction

This study was inspired by the following projects:

[A Tale of Twenty-Two Million Citi Bike Rides: Analyzing the NYC Bike Share System (by Todd Schneider)](http://toddwschneider.com/posts/a-tale-of-twenty-two-million-citi-bikes-analyzing-the-nyc-bike-share-system/)

[Bike sharing usage in Hamburg (by Alex Kruse)](https://alexkruse.shinyapps.io/stadtrad/)

[Great Maps with ggplot2 (by Dr James Cheshire)](http://spatial.ly/2012/02/great-maps-ggplot2/)

[Visualizing running routes in Amsterdam (by Nadieh Bremer)](https://www.visualcinnamon.com/2014/03/running-paths-in-amsterdam-step-2.htm)l

[Visualizing Bike Sharing Networks](http://ramnathv.github.io/bikeshare/)

The goal of this study is to visualize bike patterns of NYC Citi Bike sharing. Analyzing various patterns 
may help urban policymakers to understand certain problems of using bikes based on time, gender, and
location. As a result, these problems might be solved more effectively, using data driven decisions.

Two simultanious maps are created in order to have an opportunity to compare data.

### Source of data:

This study analyses dataset from official [NYC Citi Bike website](https://www.citibikenyc.com/system-data)

Due to techical limitations, only one month was analyzed - January 2015. 
As a result, this study demonstrates results, based only on this specific month.
It must be admitted that patterns of bike sharing probably are different for other months, 
especially Summer ones. 

Additional visualization of similar projects can be found on the [main page](https://github.com/lecy/CityBikeNYC)

# Code

# Preparing and reading the inital dataset

```
Required packages:
library( geojsonio )
library( sp )
library( lubridate )
library( dplyr )
library( shiny )
library( shinythemes )
library( eeptools )
```
```
dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))
```

This folder contains usage statistics for one month of the NYC Citybike bike share system in January of 2015. It contains 285,552 unique trips from 44,073 users.

The dataset is available on was downloaded from the [public repository](https://s3.amazonaws.com/tripdata/index.html)

More information about the structure of "dat" can be [found here](https://github.com/lecy/CityBikeNYC/tree/master/DATA)

This is the example of basic analysis of data with dplyr: [Basic analysis](Bikes_Markdown.html)


# Creating the list of routes and background map.

The following data was used:

```
stations <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/STATIONS.rds")))
```
```
routes.list <- 
readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/ALL_ROUTES_LIST.rds")))
```
```
water <- 
geojson_read( "https://raw.githubusercontent.com/lecy/CityBikeNYC/master/DATA/nyc_water.geojson", what="sp" )
```

Detailed information about creating stations, the list of routes and the map can be found: 

[Plotting practice](https://github.com/lecy/CityBikeNYC/blob/master/SANDBOX/PlottingPractice.R)

[Recipe to map all routes](https://github.com/lecy/CityBikeNYC/blob/master/SANDBOX/Recipe_To_Map_All_Routes.md)


# Subseting and converting data for Shiny

For proper visualization of different variables (gender, time, day, age), we must subset our data.
For date we use lubridate package and starttime column, transforming it into year-month-day formatю
```
bike.date <- strptime( dat$starttime, format = "%m/%d/%Y" )  
```
Then, using function weekdays, we create "day.of.week", converting dates into days of a week. 
```
day.of.week <- weekdays( bike.date ) 
dat$day.of.week <- day.of.week
```
For transforming year of birth into age, we just use the following code, sutracting age year from 2017. 
```
age <- 2017 - dat$birth.year
```
Creating names for different age groups. 
```
rider.age.groups <- c("Younger than 20", "20-29", "30-39", "40-49", "50-59", "60-69", "70+" )
```
cut() allows to split data into different age groups. 
```
dat$age <- cut( age, breaks=c(0, 20, 30, 40, 50, 60, 70, 100), labels=rider.age.groups )
```
Summarize age with table()
```
table( dat$age )
```
Creating hours, using lubridate package and starttime. It allwows to drop all information besides hours
```
hours <- format(as.POSIXct(dat$starttime, format = "%m/%d/%Y %H:%M"), "%H")
```
Transforming hours into numeric
```
hours <- as.numeric( as.character( hours ))# transform 
```
Creating names labels for different time periods
```
commute.categories <- c("Middle of Night: 12am-5am", "Morning Exercise: 5am-7am", 
                      "Morning Commute: 7am-10am", "Lunch Ride: 10am-2pm",
                       "Afternoon Break: 2pm-4pm","Afternoon Commute: 4pm-7pm", 
                       "After Dinner Commute: 7pm-10pm","Late Night Commute: 10pm-12am" )
```
Again using cut() we actually "match" hours and time periods 
```
dat$time <- cut( hours, breaks=c(0, 5, 7, 10, 14, 16, 19, 22, 24), labels=commute.categories )
table( dat$time )
```

# Creating Shiny app
Any Shiny app consists of three parts - global, server, and user interface (ui). 

# GLOBAL

Combine steps into a function to test:
```
bike.trips <- dat
```
In this function we use bike trips as initial data (dat) and max.trips,  which creates (explained below) a list of all possible routes and  include all types of variables in it. 
Custom options for the map included. 
```
plotTrips <- function( bike.trips, max.trip.num, add.water=T, 
                       line.weight=5, station.size=0.5, background.color="black" )
{
```
trip count creates a dataframe a list of routes with their IDs 
```
trip.count <- as.data.frame( table( bike.trips$route.id ) )  
max.trips <- max( trip.count$Freq )
max.trips <- max( table( bike.trips$route.id, bike.trips$day.of.week ) )
```
Specifying the thickness of the bike ride line
```
trip.weight <- line.weight * ( trip.count$Freq / max.trip.num )
```
Specify geolocation coordinates
```
max.lat <- 40.77152
max.lon <- -73.95005
min.lat <- 40.68034
min.lon <- -74.01713
```
Specifiying limits  
```
dev.new()
par( mar=c(0,0,0,0), bg=background.color )
plot.new( )
plot.window( xlim=c(min.lon,max.lon), ylim=c(min.lat,max.lat) )
  
if( add.water )
  {
```

```
water <- 
geojson_read( "https://raw.githubusercontent.com/lecy/CityBikeNYC/master/DATA/nyc_water.geojson", what="sp" )
    
plot( water, col="slategrey", border=NA, add=T )
 }
```  
Visualize routes from the route list, matching t=it long and lat and regulating thickness of the line 
```
for( i in 1:nrow( trip.count ) )
  {
single.route <- routes.list[[ trip.count$Var1[i] ]]
lines( single.route$lon, single.route$lat, col="gray", lwd=trip.weight[i] )
    
  }
```
Visualising bike station, based on long/lat and coloring it 
```
points( stations$LON, stations$LAT, col="darkorange", pch=19, cex=station.size )
  
}
```
Creating a map
```
plotTrips( bike.trips=dat, max.trip.num=450 )
```

## SERVER 

This function will contain input and output, which is a specific feature for Shiny. 
```
my.server <- function(input, output) 
{
  
output$tripPlot <- renderPlot({  
``` 
We subset data in order to be able to use differen variables and pick any combination of gender, age, time, and day of week. 
```
dat.sub1 <- dat[ dat$day.of.week == input$day1 & dat$gender == input$gender1 &
                       dat$age == input$age1 & dat$time == input$time1 , ]
```
We also do this for the second map   
```
dat.sub2 <- dat[ dat$day.of.week == input$day2 & dat$gender == input$gender2 &
                       dat$age == input$age2 & dat$time == input$time2 , ]
    
max.trips <- max( c( table( dat.sub1$route.id ), table( dat.sub2$route.id ) ) )
```   
Similarly we subset data for gender  
```
selected.gender1 <- ifelse( input$gender1 == 1, "Male", "Female" )
selected.gender2 <- ifelse( input$gender2 == 1, "Male", "Female" )
```
Create a map with two columns
```
par( mfrow=c(1,2) )
```
Function Plot trips allows us to visualize bot maps
```
plotTrips( bike.trips=dat.sub1, max.trip.num=max.trips )
title( main=toupper(paste(input$day1,selected.gender1,input$age1,input$time1,sep=" : ")), line=-3, cex.main=1, col.main="white" )
plotTrips( bike.trips=dat.sub2, max.trip.num=max.trips )
title( main=toupper(paste(input$day2,selected.gender2,input$age2,input$time2,sep=" : ")), line=-3, cex.main=1, col.main="white" )
    
},   height = 800, width = 800 ) 
  
}
```

# USER INTERFACE 

Create interface part for Shiny app
```
my.ui <- fluidPage(
```  
Pick appropriate there; for example,
```
theme = shinytheme("slate"),
``` 
Application title
```
titlePanel("Citi Bike NYC Route Traffic"),
```  
Sidebar with a slider input for the number of bins
```
sidebarLayout(
    sidebarPanel(
      h2( helpText("First Map") ), 
```     
create inputs for the first map

For the day of the week we create input with different options, picking Monday as default.
```
      selectInput( inputId="day1", 
                   label="Select Day of Week", 
                   choices=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"),
                   selected="Monday"
      ),
```
For the gender we create input with different options, picking Male as default.
```
      selectInput( inputId="gender1", 
                   label="Select Female or Male", 
                   choices=c("Female"="2","Male"="1"),
                   selected="1"
      ), 
```
For the time of the day we create input with different options, picking 5-7 am as default
```
      selectInput( inputId="time1", 
                   label="Time of Day", 
                   choices = commute.categories,
                   selected="Morning Exercise: 5am-7am"
      ), 
```
For the age we create input with different options, picking M30-39 as default.
```
      selectInput( inputId="age1", 
                   label="Age of Rider", 
                   choices = rider.age.groups,
                   selected="30-39" 
      ),
```      
The same approach is used for the second map
```
      h2( helpText("Second Map") ),
      
      selectInput( inputId="day2", 
                   label="Select Day of Week", 
                   choices=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"),
                   selected="Monday"
      ),
      selectInput( inputId="gender2", 
                   label="Select Female or Male", 
                   choices=c("Female"="2","Male"="1"),
                   selected="2"
      ), 
      selectInput( inputId="time2", 
                   label="Time of Day", 
                   choices= commute.categories,
                   selected="Morning Exercise: 5am-7am" 
      ),
      selectInput( inputId="age2", 
                   label="Age of Rider", 
                   choices = rider.age.groups,
                   selected="30-39"
      )
    ),
```    
Show a plot of the generated distribution
```
    mainPanel(  plotOutput( "tripPlot" )  )
    
  )
)
```

# LAUNCH THE APP ! :)
```
shinyApp( ui = my.ui, server = my.server )
```




