
# LOAD DATA

dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))
stations <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/STATIONS.rds")))
routes.list <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/ALL_ROUTES_LIST.rds")))


# COMBINE STEPS INTO A FUNCTION
#
# to test:   bike.trips <- dat

plotTrips <- function( bike.trips, add.water=F, 
                       save.png=TRUE, pixel.height=12000, pixel.width=8000, 
                       line.weight=40, station.size=8, background.color="black" )
{

	trip.count <- as.data.frame( table( bike.trips$route.id ) )
	
	max.trips <- max( trip.count$Freq )
	trip.weight <- line.weight * ( trip.count$Freq / max.trips )

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

	par( mar=c(0,0,0,0), bg=background.color )

	plot.new()
	plot.window( xlim=c(min.lon,max.lon), ylim=c(min.lat,max.lat) )

	if( add.water )
	{
		library( geojsonio )

		water <- geojson_read( "https://raw.githubusercontent.com/lecy/CityBikeNYC/master/DATA/nyc_water.geojson", what="sp" )

		plot( water, col="slategrey", border=NA, add=T )
	}


	for( i in 1:nrow( trip.count ) )
	{
	   single.route <- routes.list[[ trip.count$Var1[i] ]]
	   lines( single.route$lon, single.route$lat, col="gray", lwd=trip.weight[i] )

	}

	points( stations$LON, stations$LAT, col="darkorange", pch=19, cex=station.size )

	if( save.png )
	{
		dev.off()
		shell( png.name )
	}

}



plotTrips( bike.trips=dat, add.water=T, save.png=T )

plotTrips( bike.trips=dat, add.water=F, save.png=F, line.weight=5, station.size=1, background.color="white" )

plotTrips( bike.trips=dat, add.water=T, save.png=F, line.weight=5, station.size=1, background.color="black" )




# Subset rides by week day

library( lubridate )
library( dplyr )

bike.date <- strptime(dat$starttime, format = "%m/%d/%Y") 
bike.date.weekday <- weekdays(bike.date) # separated data by day
table(bike.date.weekday)

# So, we have: 
# Friday    Monday  Saturday    Sunday  Thursday   Tuesday Wednesday 
# 57829     38002     28080     26490     52905     38879     43367 

# Map by weekday

dat.mon <- dat[bike.date.weekday=="Monday",]
dat.tues <- dat[bike.date.weekday=="Tuesday",]
dat.wed <- dat[bike.date.weekday=="Wednesday",]
dat.thur <- dat[bike.date.weekday=="Thursday",]
dat.fri <- dat[bike.date.weekday=="Friday",]
dat.sat <- dat[bike.date.weekday=="Saturday",]
dat.sun <- dat[bike.date.weekday=="Sunday",]




par( mfrow=c(2,4) ) 

plotTrips( bike.trips=dat.mon, add.water=F, save.png=F, line.weight=2, station.size=0 )
title( main="MONDAY", col.main="white", line=-1 )
plotTrips( bike.trips=dat.tues, add.water=F, save.png=F, line.weight=2, station.size=0 )
title( main="TUESDAY", col.main="white", line=-1 )
plotTrips( bike.trips=dat.wed, add.water=F, save.png=F, line.weight=2, station.size=0 )
title( main="WEDNESDAY", col.main="white", line=-1 )
plotTrips( bike.trips=dat.thur, add.water=F, save.png=F, line.weight=2, station.size=0 )
title( main="THURSDAY", col.main="white", line=-1 )
plotTrips( bike.trips=dat.fri, add.water=F, save.png=F, line.weight=2, station.size=0 )
title( main="FRIDAY", col.main="white", line=-1 )
plotTrips( bike.trips=dat.sat, add.water=F, save.png=F, line.weight=2, station.size=0 )
title( main="SATURDAY", col.main="white", line=-1 )
plotTrips( bike.trips=dat.sun, add.water=F, save.png=F, line.weight=2, station.size=0 )
title( main="SUNDAY", col.main="white", line=-1 )



png( "weekdays.png", width=16000, height=8000 )

par( mfrow=c(2,4) )

plotTrips( bike.trips=dat.mon, add.water=F, save.png=F, line.weight=40, station.size=7 )
title( main="MONDAY", col.main="white", line=-15, cex.main=20  )
plotTrips( bike.trips=dat.tues, add.water=F, save.png=F, line.weight=40, station.size=7 )
title( main="TUESDAY", col.main="white", line=-15, cex.main=20  )
plotTrips( bike.trips=dat.wed, add.water=F, save.png=F, line.weight=40, station.size=7 )
title( main="WEDNESDAY", col.main="white", line=-15, cex.main=20  )
plotTrips( bike.trips=dat.thur, add.water=F, save.png=F, line.weight=40, station.size=7 )
title( main="THURSDAY", col.main="white", line=-15, cex.main=20  )
plotTrips( bike.trips=dat.fri, add.water=F, save.png=F, line.weight=40, station.size=7 )
title( main="FRIDAY", col.main="white", line=-15, cex.main=20  )
plotTrips( bike.trips=dat.sat, add.water=F, save.png=F, line.weight=40, station.size=7 )
title( main="SATURDAY", col.main="white", line=-15, cex.main=20 )
plotTrips( bike.trips=dat.sun, add.water=F, save.png=F, line.weight=40, station.size=7 )
title( main="SUNDAY", col.main="white", line=-15, cex.main=20  )

dev.off()

shell( "weekdays.png" )
