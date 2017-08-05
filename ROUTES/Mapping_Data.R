dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))
stations <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/STATIONS.rds")))
routes.list <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/ALL_ROUTES_LIST.rds")))


# create a bounding box using station locations

max.lat <- max( stations$LAT )
max.lon <- max( stations$LON )
min.lat <- min( stations$LAT )
min.lon <- min( stations$LON )


# uses the list version of routes

png( "january_bike_routes.png", width = 800, height = 1200 )

par( mar=c(0,0,0,0) )

plot( NA, NA, xlim=c(min.lon,max.lon), ylim=c(min.lat,max.lat), bty="n", 
      yaxt="n", xaxt="n" )

for( i in 1:nrow( dat ) )
{

   route.id <- paste( "S.", dat$start.station.id[i], "_to_S.", dat$end.station.id[i], sep="" )
   single.route <- routes.list[[ route.id ]]
   lines( single.route$lon, single.route$lat, col=gray( level=0.5, alpha=0.1 ), lwd=1 )

}

points( stations$LON, stations$LAT, col="darkred", pch=19, cex=3 )

dev.off()




dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))
stations <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/STATIONS.rds")))
routes.list <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/ALL_ROUTES_LIST.rds")))

# create a bounding box using station locations

max.lat <- max( stations$LAT )
max.lon <- max( stations$LON )
min.lat <- min( stations$LAT )
min.lon <- min( stations$LON )


d <- dat
dat <- dat[ sample( 1:nrow(dat), 10000 ]

dat.men <- dat[ dat$gender == 1 , ]
dat.women <- dat[ dat$gender == 2 , ]


png( "by_gender.png", width = 1600, height = 1200 )

par( mfrow=c(1,2), mar=c(0,0,0,0) )  # two plots on one, no margins

plot( NA, NA, xlim=c(min.lon,max.lon), ylim=c(min.lat,max.lat), bty="n", 
      yaxt="n", xaxt="n", main="Bike Routes of Men" )

for( i in 1:nrow( dat.men ) )
{

   route.id <- paste( "S.", dat.men$start.station.id[i], "_to_S.", dat.men$end.station.id[i], sep="" )
   single.route <- routes.list[[ route.id ]]
   lines( single.route$lon, single.route$lat, col=gray( level=0.5, alpha=0.05 ), lwd=1 )

}

points( stations$LON, stations$LAT, col="darkred", pch=19, cex=1 )


plot( NA, NA, xlim=c(min.lon,max.lon), ylim=c(min.lat,max.lat), bty="n", 
      yaxt="n", xaxt="n", main="Bike Routes of Women" )

for( i in 1:nrow( dat.women ) )
{

   route.id <- paste( "S.", dat.women$start.station.id[i], "_to_S.", dat.women$end.station.id[i], sep="" )
   single.route <- routes.list[[ route.id ]]
   lines( single.route$lon, single.route$lat, col=gray( level=0.5, alpha=0.05 ), lwd=1 )

}

points( stations$LON, stations$LAT, col="darkred", pch=19, cex=1 )


dev.off()



dat.sub <- dat[ dat$birth.year > 1980 & dat$birth.year < 2000 , ] # millenials







### ADD BACKGROUND

library(tigris)
library(sp)
library( grDevices )


ny <- counties( state="NY" )

# New York County: 36061
# Queens: 36081
# Bronx: 36005
# Brooklyn: 36047
# Staten Island: 36085

manhattan.water <- area_water( state="NY", county="061" )
queens.water <- area_water( state="NY", county="081" )
bronx.water <- area_water( state="NY", county="005" )
brooklyn.water <- area_water( state="NY", county="047" )
# staten.water <- area_water( state="NY", county="085" )


nyc <- ny[ ny$GEOID %in% c(36061,36081,36005,36047) , ]


par( mar=c(0,0,0,0), bg=adjustcolor( "lightblue", alpha.f=0.2) )
plot( nyc, border=NA, col="white", xlim=c(-74.027,-73.94377), ylim=c(40.67611,40.77737 ) )
plot( manhattan.water, col=adjustcolor( "lightblue", alpha.f=0.2), border=NA, add=T )
plot( queens.water, col=adjustcolor( "lightblue", alpha.f=0.2), border=NA, add=T )
plot( bronx.water, col=adjustcolor( "lightblue", alpha.f=0.2), border=NA, add=T )
plot( brooklyn.water, col=adjustcolor( "lightblue", alpha.f=0.2), border=NA, add=T )




dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))
stations <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/STATIONS.rds")))
routes.list <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/ALL_ROUTES_LIST.rds")))


# for testing - plot only a sample

d <- dat
dat <- dat[ sample( 1:nrow(dat), 10000 ) , ]


# create a bounding box using station locations

max.lat <- max( stations$LAT )
max.lon <- max( stations$LON )
min.lat <- min( stations$LAT )
min.lon <- min( stations$LON )


# uses the list version of routes

png( "with_background_lavender.png", width = 800, height = 1200 )

par( mar=c(0,0,0,0), bg="lavender" )  # bg="aliceblue"
plot( nyc, border=NA, col="white", xlim=c(-74.027,-73.94377), ylim=c(40.67611,40.77737 ) )
plot( manhattan.water, col="lavender", border=NA, add=T )
plot( queens.water, col="lavender", border=NA, add=T )
plot( bronx.water, col="lavender", border=NA, add=T )
plot( brooklyn.water, col="lavender", border=NA, add=T )



# plot( NA, NA, xlim=c(min.lon,max.lon), ylim=c(min.lat,max.lat), bty="n", 
#       yaxt="n", xaxt="n" )

for( i in 1:nrow( dat ) )
{

   route.id <- paste( "S.", dat$start.station.id[i], "_to_S.", dat$end.station.id[i], sep="" )
   single.route <- routes.list[[ route.id ]]
   lines( single.route$lon, single.route$lat, col=gray( level=0.5, alpha=0.1 ), lwd=1 )

}

points( stations$LON, stations$LAT, col="darkred", pch=19, cex=1 )

dev.off()

dat <- d   # return dataset to full sample






### HIGH RES

dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))
stations <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/STATIONS.rds")))
routes.list <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/ALL_ROUTES_LIST.rds")))


# create a bounding box using station locations

max.lat <- max( stations$LAT )
max.lon <- max( stations$LON )
min.lat <- min( stations$LAT )
min.lon <- min( stations$LON )

d <- dat

# dat <- d

dat <- dat[ sample( 1:nrow(dat), 10000 ) , ]

# uses the list version of routes

# pdf( "test.pdf", height=12, width=8 )

png( "test.png", width = 8000, height = 12000 )

par( mar=c(0,0,0,0) )

plot( NA, NA, xlim=c(min.lon,max.lon), ylim=c(min.lat,max.lat), bty="n", 
      yaxt="n", xaxt="n" )

for( i in 1:nrow( dat ) )
{

   this.route <- paste( "S.", dat$start.station.id[i], "_to_S.", dat$end.station.id[i], sep="" )
   lines( routes.list[[this.route]]$lon, routes.list[[this.route]]$lat, 
          col=gray( 0.5, 0.05), lwd=10 )

}

points( stations$LON, stations$LAT, col="darkred", pch=19, cex=3 )

dev.off()
