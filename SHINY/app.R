library( geojsonio )
library( sp )
library( lubridate )
library( dplyr )
library( shiny )
library( shinythemes )
library( eeptools )


dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))
stations <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/STATIONS.rds")))
routes.list <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/ALL_ROUTES_LIST.rds")))
water <- geojson_read( "https://raw.githubusercontent.com/lecy/CityBikeNYC/master/DATA/nyc_water.geojson", what="sp" )


# Create Day of Week Variable in Dat

bike.date <- strptime( dat$starttime, format = "%m/%d/%Y" ) 
day.of.week <- weekdays( bike.date ) # separated data by day
dat$day.of.week <- day.of.week

age <- 2017 - dat$birth.year

rider.age.groups <- c("Younger than 20", "20-29", "30-39", "40-49", "50-59", "60-69", "70+" )

dat$age <- cut( age, breaks=c(0, 20, 30, 40, 50, 60, 70, 100), labels=rider.age.groups )

table( dat$age )


hours <- format(as.POSIXct(dat$starttime, format = "%m/%d/%Y %H:%M"), "%H")

hours <- as.numeric( as.character( hours ))# transform 

commute.categories <- c("Middle of Night: 12am-5am", "Morning Exercise: 5am-7am", "Morning Commute: 7am-10am", 
                       "Lunch Ride: 10am-2pm","Afternoon Break: 2pm-4pm","Afternoon Commute: 4pm-7pm", 
                       "After Dinner Commute: 7pm-10pm","Late Night Commute: 10pm-12am" )
                       
dat$time <- cut( hours, breaks=c(0, 5, 7, 10, 14, 16, 19, 22, 24), labels=commute.categories )

table( dat$time )



# COMBINE STEPS INTO A FUNCTION
#
# to test:   bike.trips <- dat

plotTrips <- function( bike.trips, max.trip.num, add.water=T, 
                       line.weight=5, station.size=0.5, background.color="black" )
{

	trip.count <- as.data.frame( table( bike.trips$route.id ) )
	
	# max.trips <- max( trip.count$Freq )
	#max.trips <- max( table( bike.trips$route.id, bike.trips$day.of.week ) )
	trip.weight <- line.weight * ( trip.count$Freq / max.trip.num )

	max.lat <- 40.77152
	max.lon <- -73.95005
	min.lat <- 40.68034
	min.lon <- -74.01713

	# dev.new()
	par( mar=c(0,0,0,0), bg=background.color )
	plot.new( )
	plot.window( xlim=c(min.lon,max.lon), ylim=c(min.lat,max.lat) )

	if( add.water )
	{
		# library( geojsonio )
		# water <- geojson_read( "https://raw.githubusercontent.com/lecy/CityBikeNYC/master/DATA/nyc_water.geojson", what="sp" )

		plot( water, col="slategrey", border=NA, add=T )
	}


	for( i in 1:nrow( trip.count ) )
	{
	   single.route <- routes.list[[ trip.count$Var1[i] ]]
	   lines( single.route$lon, single.route$lat, col="gray", lwd=trip.weight[i] )

	}

	points( stations$LON, stations$LAT, col="darkorange", pch=19, cex=station.size )

}



plotTrips( bike.trips=dat, max.trip.num=450 )






## SERVER 
  
my.server <- function(input, output) 
{


  
  output$tripPlot <- renderPlot({  

    dat.sub1 <- dat[ dat$day.of.week == input$day1 & dat$gender == input$gender1 &
                       dat$age == input$age1 & dat$time == input$time1 , ]
                       
    dat.sub2 <- dat[ dat$day.of.week == input$day2 & dat$gender == input$gender2 &
                       dat$age == input$age2 & dat$time == input$time2 , ]
                              
                                     max.trips <- max( c( table( dat.sub1$route.id ), table( dat.sub2$route.id ) ) )

                  
                                     selected.gender1 <- ifelse( input$gender1 == 1, "Male", "Female" )
                                     selected.gender2 <- ifelse( input$gender2 == 1, "Male", "Female" )
                                                          
                                     par( mfrow=c(1,2) )
                                     plotTrips( bike.trips=dat.sub1, max.trip.num=max.trips )
                                     title( main=toupper(paste(input$day1,selected.gender1,input$age1,input$time1,sep=" : ")), line=-3, cex.main=1, col.main="white" )
                                     plotTrips( bike.trips=dat.sub2, max.trip.num=max.trips )
                                     title( main=toupper(paste(input$day2,selected.gender2,input$age2,input$time2,sep=" : ")), line=-3, cex.main=1, col.main="white" )
                                     
                                },   height = 800, width = 800 )  # 
  
}




### USER INTERFACE 

my.ui <- fluidPage(

  # theme = shinytheme("cyborg"),
  theme = shinytheme("slate"),

  # Application title
  titlePanel("Citi Bike NYC Route Traffic"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
  
    sidebarPanel(
    
      h2( helpText("First Map") ),
      
      selectInput( inputId="day1", 
                   label="Select Day of Week", 
                   choices=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"),
                   selected="Monday"
                 ),
      selectInput( inputId="gender1", 
                   label="Select Female or Male", 
                   choices=c("Female"="2","Male"="1"),
                   selected="1"
                 ), 
      # sliderInput( inputId="time1", 
      #              label="Time of Day", 
      #              min=0, max=24,
      #              value=9 
      #            ),
      selectInput( inputId="time1", 
                   label="Time of Day", 
                   choices = commute.categories,
                   selected="Morning Exercise: 5am-7am"
                 ),     
      selectInput( inputId="age1", 
                   label="Age of Rider", 
                   choices = rider.age.groups,
                   selected="30-39" 
                 ),

      
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

    # Show a plot of the generated distribution
    mainPanel(  plotOutput( "tripPlot" )  )
    
  )
)




### LAUNCH THE APP !

shinyApp( ui = my.ui, server = my.server )


