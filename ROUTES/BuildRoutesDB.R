

library( ggmap )





dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))

stations <- unique( dat[ c("start.station.id","start.station.name","start.station.latitude","start.station.longitude") ] )

nrow( stations )

names( stations ) <- c("ID","StationName","LAT","LON")

rownames( stations ) <- NULL

stations <- stations[ order( stations$ID ) , ]

head( stations )

saveRDS( stations, "BikeStations.RDS" )






MY_API_KEY <- "AIzaSyAu2DQfGX8AbmJDwIf4SZswYM7vlFFd4vc"

register_google( key=MY_API_KEY, account_type="premium", day_limit=110000 )

ggmap_credentials()







# Start Building Routes

dir.create( "ROUTES" )

setwd( "ROUTES" )


for( i in 1:330 )
{
  
  print( paste( "LOOP NUMBER", i ) )
  flush.console()
  
  routes <- list()
  
  for( j in 1:330 )
  {
    
     rt <- try( route( from=c(stations$LON[i], stations$LAT[i]), 
                  to=c(stations$LON[j], stations$LAT[j]), 
                  mode="bicycling",
                  structure="route" 
                 ) )
     
     route.name <- paste( "S.", stations$ID[i], "_to_S.", stations$ID[j], sep="" )
  
     routes[[j]] <- rt
  
     names(routes)[j] <- route.name

     print( paste( "I=", i, "J=", j ) )
     flush.console()
     
  }  # end of j loop

  id <- substr( 1000 + i, 2, 4 )
  
  list.name <- paste( "RoutesFromStation", id, ".rda", sep="" )
  
  save( routes, file=list.name )
  
}




# GOOGLE API DASHBOARD
#
# https://console.developers.google.com/apis/dashboard



setwd( "ROUTES" )

setwd( "DB" )

load( "RoutesFromStation204.rda" )

routes









file.names <- dir()

all.routes <- list()

for( i in 1:length(file.names) )
{

  load( file.names[i] )

  all.routes <- c( all.routes, routes )

}


saveRDS( all.routes, file="ALL_ROUTES_LIST.rds" )







### FIX ANY CASES THAT DIDN'T MAP CORRECTLY


table( unlist(lapply( all.routes, class )) )

route <- NULL
status <- NULL

for( i in 1:length(all.routes) )
{
    route[i] <- names( all.routes[i] )
    status[i] <- class( all.routes[[i]] )
}

success.log <- data.frame( route, status )

head( success.log )

nrow( success.log )

table( success.log$status )

these <- which( status == "try-error" )

route.names <- route[ these ]

route.names2 <- gsub( "S.", "", route.names )
from.to <- strsplit( route.names2, "_to_" )


for( i in 1:length(these) )
{
  
  print( paste( "ROUTE NAME:", route.names[i] ) )
  flush.console()

  from.id <- from.to[[i]][1]
  to.id <- from.to[[i]][2]

  from.station <- stations[ stations$ID == from.id , ]
  to.station <- stations[ stations$ID == to.id , ]

  rt <- try( route( from=c(from.station$LON, from.station$LAT), 
                  to=c(to.station$LON, to.station$LAT), 
                  mode="bicycling",
                  structure="route" 
                 ) )
     
     route.name <- route.names[i]

     if( names( all.routes[these[i]] ) == route.name )
     {
  
       all.routes[[these[i]]] <- rt

     } else( print("DOES NOT MATCH") )
  

  
}


table( unlist(lapply( all.routes, class )) )


saveRDS( all.routes, "ALL_ROUTES_LIST.rds" )








# ADD ROUTE ID TO EACH ROW OF DATA


for( i in 1:length(all.routes) )
{
    all.routes[[i]] <- cbind( all.routes[[i]], route=names(all.routes[i]) )
}

df <- do.call( rbind.data.frame, all.routes )

head( df )

saveRDS( df, file="ALL_ROUTES_DF.rds" )





# SAVE STATIONS LIST



dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))

keep.these.vars <- c("start.station.id","start.station.name","start.station.latitude","start.station.longitude")

stations <- unique( dat[ keep.these.vars ] )

nrow( stations )

names( stations ) <- c("ID","StationName","LAT","LON")

stations <- stations[ order( stations$ID ) , ]

rownames( stations ) <- NULL

head( stations )

saveRDS( stations, "STATIONS.rds")

