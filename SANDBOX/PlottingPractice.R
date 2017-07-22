

### LOAD DATA

dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/ALL_ROUTES_LIST.rds")))

d2 <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/ALL_ROUTES_DF.rds")))

stations <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/STATIONS.rds")))


route2 <- gsub( "S.", "", d2$route )
from.to <- strsplit( route2, "_to_" )

from.to.mat <- matrix( unlist( from.to ), ncol=2, byrow=T )

from.to.df <- as.data.frame( from.to.mat )

names( from.to.df ) <- c("from","to")

d2 <- cbind( d2, from.to.df )





### PLOTTING STATIONS

stations <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/STATIONS.rds")))

par( mar=c(0,0,0,0) )

plot( stations$LON, stations$LAT, col="darkred", pch=19, cex=0.3 )

text( stations$LON, stations$LAT, stations$ID, pos=3, cex=0.5, offset=0.2, col="gray30" )




library( ggmap )

nyc <- qmap( 'east village, ny', zoom = 13, color = 'bw' )

nyc + geom_point( aes(x = LON, y = LAT ), colour="darkred", data = stations )


map <- get_googlemap( center = 'east village, ny', zoom = 13, col="bw",
       style = 'style=feature:all|element:labels|visibility:off' )

ggmap( map, extent="device" )

myplot <- ggmap( map, extent="device" )

myplot + geom_point( aes(x = LON, y = LAT ), colour="darkred", size=0.7, data = stations )





### PLOTTING ALL POSSIBLE ROUTES



# this doesn't work - there are some false routes
# max.lat <- max( d2$lat )
# max.lon <- max( d2$lon )
# min.lat <- min( d2$lat )
# min.lon <- min( d2$lon )


max.lat <- max( stations$LAT )
max.lon <- max( stations$LON )
min.lat <- min( stations$LAT )
min.lon <- min( stations$LON )

# WHITE BACKGROUND

par( mar=c(0,0,0,0) )

plot( NA, NA, xlim=c(min.lon,max.lon), ylim=c(min.lat,max.lat) )

index <- 1:length( dat )

for( i in 1:length( dat ) )
{

   # sub.dat <- d2[ ]

   lines( dat[[i]]$lon, dat[[i]]$lat, col="gray" )

}

points( stations$LON, stations$LAT, col="darkred", pch=19, cex=0.5 )



# BLACK BACKGROUND

par( mar=c(0,0,0,0), bg="black" )

plot( NA, NA, xlim=c(min.lon,max.lon), ylim=c(min.lat,max.lat) )

index <- 1:length( dat )

for( i in 1:length( dat ) )
{

   # sub.dat <- d2[ ]

   lines( dat[[i]]$lon, dat[[i]]$lat, col="gray" )

}

points( stations$LON, stations$LAT, col="darkorange2", pch=19, cex=0.5 )






### IN GGMAP

library( ggmap )

# Get the map of Amsterdam from Google

nyc <- qmap( 'east village, ny', zoom = 13, color = 'bw' )


# Plot the map and the routes on top of that

d3 <- d2[ 1:10000 , ] smaller sample to test

nyc +
  geom_path( aes(x = lon, y = lat, group = factor(route) ), 
            colour="#1E2B6A", data = d3 )




### BETTER MAP

map <- get_googlemap( center = 'east village, ny', zoom = 13, col="bw",
       style = 'style=feature:all|element:labels|visibility:off' )

ggmap( map, extent="device" )

myplot <- ggmap( map, extent="device" )

myplot <- myplot + geom_path( aes(x = lon, y = lat, group = factor(route) ), 
            colour="#1E2B6A", data = d2 )
            
         myplot + geom_point( aes(x = LON, y = LAT ), colour="darkorange2", size=0.5, data = stations )

    