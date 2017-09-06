# CityBikeNYC

Visualizing NYC CityBike data.



### Shiny App to Compare Route Traffic by Population Segment and Time

```r
install.packages( c("geojsonio","sp","lubridate","dplyr","shiny","shinythemes","eeptools") )

library( shiny )
runGitHub( repo="CityBikeNYC", username="lecy", subdir = "SHINY" )
```

![](./ASSETS/shiny_app_screenshot.png)

<br>
<br>





### Static Maps

```r

# LOAD DATA

dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))
stations <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/STATIONS.rds")))
routes.list <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/ALL_ROUTES_LIST.rds")))


# COMBINE STEPS INTO A FUNCTION

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



```


![](./ASSETS/Aug_05_12_25_05_AM.png)

<br>
<br>

```r

png( "weekdays.png", width=16000, height=12000 )

par( mfrow=c(2,4) )

plotTrips( bike.trips=dat.mon, add.water=F, save.png=F, line.weight=40, station.size=8 )
title( main="MONDAY", col.main="white", line=-20, cex.main=30  )
plotTrips( bike.trips=dat.tues, add.water=F, save.png=F, line.weight=40, station.size=8 )
title( main="TUESDAY", col.main="white", line=-20, cex.main=30  )
plotTrips( bike.trips=dat.wed, add.water=F, save.png=F, line.weight=40, station.size=8 )
title( main="WEDNESDAY", col.main="white", line=-20, cex.main=30 )
plotTrips( bike.trips=dat.thur, add.water=F, save.png=F, line.weight=40, station.size=8 )
title( main="THURSDAY", col.main="white", line=-20, cex.main=30 )
plotTrips( bike.trips=dat.fri, add.water=F, save.png=F, line.weight=40, station.size=8 )
title( main="FRIDAY", col.main="white", line=-20, cex.main=30 )
plotTrips( bike.trips=dat.sat, add.water=F, save.png=F, line.weight=40, station.size=8 )
title( main="SATURDAY", col.main="white", line=-20, cex.main=30 )
plotTrips( bike.trips=dat.sun, add.water=F, save.png=F, line.weight=40, station.size=8 )
title( main="SUNDAY", col.main="white", line=-20, cex.main=30  )

dev.off()

shell( "weekdays.png" )


```

![](./ASSETS/weekdays.png)


<br>
<br>

### Inspiration drawn from the following blogs:

http://flowingdata.com/2014/02/05/where-people-run/

http://barsukov.net/visualisation/2014/07/25/endomondo/

https://www.visualcinnamon.com/2014/03/running-paths-in-amsterdam-step-2.html

http://toddwschneider.com/posts/a-tale-of-twenty-two-million-citi-bikes-analyzing-the-nyc-bike-share-system/

https://tbaldw.in/citibike-trips/

https://www.r-bloggers.com/nyc-citi-bike-visualization-a-hint-of-future-transportation/

http://ramnathv.github.io/bikeshare/

![alt](ASSETS/DC-feature.png)

![alt](ASSETS/examples.png)

![alt](ASSETS/copenhagen.png)

![alt](ASSETS/most_popular_bike_routes.png)


[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/nZx8QLXk3Ls/0.jpg)](https://www.youtube.com/watch?v=nZx8QLXk3Ls)
