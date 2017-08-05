




dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))
stations <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/STATIONS.rds")))
routes.list <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/ALL_ROUTES_LIST.rds")))



# count number of trips on each route

countTrips <- function( bike.trip.dat )
{


  route.id <- NULL

  for( i in 1:nrow( bike.trip.dat ) )
  {
    id1 <- bike.trip.dat$start.station.id[i]
    id2 <- bike.trip.dat$end.station.id[i]


    if( id1 > id2 ){  route.id[i] <- paste( "S.", id2, "_to_S.", id1, sep="" ) } 
    if( id1 <= id2 ){  route.id[i] <- paste( "S.", id1, "_to_S.", id2, sep="" ) }

  }

  trip.count <- as.data.frame( table( route.id ) )

  return( trip.count )
}


trip.count <- countTrips( bike.trip.dat=dat )

tc <- trip.count[ 1:100 , ]


# create a plot

plotTrips <- function( trip.count, add.water=F, save.png=TRUE, pixel.height=12000, pixed.width=8000 )
{

	max.trips <- max( trip.count$Freq )
	trip.weight <- 40 * ( trip.count$Freq / max.trips )

	max.lat <- 40.77152
	max.lon <- -73.95005
	min.lat <- 40.68034
	min.lon <- -74.01713

	if( save.png )
	{
		png.name <- paste( format(Sys.time(), "%b %d %X"), ".png", sep="" )
		png.name <- gsub( ":", "_", png.name )
		png.name <- gsub( " ", "_", png.name )

		png( png.name, width=pixel.width, height=pixel.height )
	}

	par( mar=c(0,0,0,0), bg="black" )

	plot.new()
	plot.window( xlim=c(min.lon,max.lon), ylim=c(min.lat,max.lat) )

	if( add.water=T )
	{
		library(tigris)

		ny <- counties( state="NY" )
		nyc <- ny[ ny$GEOID %in% c(36061,36081,36005,36047) , ]

		manhattan.water <- area_water( state="NY", county="061" )
		queens.water <- area_water( state="NY", county="081" )
		bronx.water <- area_water( state="NY", county="005" )
		brooklyn.water <- area_water( state="NY", county="047" )

		water <- rbind(manhattan.water,queens.water,bronx.water,brooklyn.water)

		plot( water, col="slategrey", border=NA, add=T )
	}


	for( i in 1:nrow( trip.count ) )
	{
	   single.route <- routes.list[[ trip.count$route.id[i] ]]
	   lines( single.route$lon, single.route$lat, col="white", lwd=trip.weight[i] )

	}

	points( stations$LON, stations$LAT, col="darkorange", pch=19, cex=8 )

	if( save.png )
	{
		dev.off()
		shell( png.name )
	}

}






plotTrips( trip.count=trip.count, add.water=T )



