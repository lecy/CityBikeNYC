library( geojsonio )
library( sp )
library( lubridate )
library( dplyr )
library( shiny )
library( shinythemes )


dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))
stations <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/STATIONS.rds")))
routes.list <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/ALL_ROUTES_LIST.rds")))
water <- geojson_read( "https://raw.githubusercontent.com/lecy/CityBikeNYC/master/DATA/nyc_water.geojson", what="sp" )


# Create Day of Week Variable in Dat

bike.date <- strptime( dat$starttime, format = "%m/%d/%Y" ) 
day.of.week <- weekdays( bike.date ) # separated data by day
dat$day.of.week <- day.of.week








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
  
                                     dat.sub1 <- dat[ dat$day.of.week == input$day1 & dat$gender == input$gender1 , ]
                                     dat.sub2 <- dat[ dat$day.of.week == input$day2 & dat$gender == input$gender2 , ]
                                     
                                     max.trips <- max( c( table( dat.sub1$route.id ), table( dat.sub2$route.id ) ) )
                                     
                                     selected.gender1 <- ifelse( input$gender1 == 1, "Male", "Female" )
                                     selected.gender2 <- ifelse( input$gender2 == 1, "Male", "Female" )
                                     
                                     par( mfrow=c(1,2) )
                                     plotTrips( bike.trips=dat.sub1, max.trip.num=max.trips )
                                     title( main=toupper(paste(input$day1,selected.gender1,sep=":")), line=-3, cex.main=2, col.main="white" )
                                     plotTrips( bike.trips=dat.sub2, max.trip.num=max.trips )
                                     title( main=toupper(paste(input$day2,selected.gender2,sep=":")), line=-3, cex.main=2, col.main="white" )
                                   
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
                   selected="Male"
                 ), 
      sliderInput( inputId="time1", 
                   label="Time of Day", 
                   min=0, max=24,
                   value=c(7,9) 
                 ),
      selectInput( inputId="age1", 
                   label="Age of Rider", 
                   choices=c("Really Old","Boomer","Millenial"),
                   selected="Millenial" 
                 ),

      
      h2( helpText("Second Map") ),
      
      selectInput( inputId="day2", 
                   label="Select Day of Week", 
                   choices=c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"),
                   selected="Sunday"
                 ),
      selectInput( inputId="gender2", 
                   label="Select Female or Male", 
                   choices=c("Female"="2","Male"="1"),
                   selected="Male"
                 ), 
      sliderInput( inputId="time2", 
                   label="Time of Day", 
                   min=0, max=24,
                   value=c(7,9) 
                 ),
      selectInput( inputId="age2", 
                   label="Age of Rider", 
                   choices=c("Really Old","Boomer","Millenial"),
                   selected="Millenial" 
                 )
    ),

    # Show a plot of the generated distribution
    mainPanel(  plotOutput( "tripPlot" )  )
    
  )
)




### LAUNCH THE APP !

shinyApp( ui = my.ui, server = my.server )


