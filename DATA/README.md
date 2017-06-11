# Data

This folder contains usage statistics for one month of the NYC Citybike bike share system in January of 2015. The dataset is available on was downloaded from the public repository: https://s3.amazonaws.com/tripdata/index.html 

# Data Dictionary

•	Trip Duration (seconds)  
•	Start Time and Date  
•	Stop Time and Date  
•	Start Station Name  
•	End Station Name  
•	Station ID  
•	Station Lat/Long  
•	Bike ID  
•	User Type (Customer = 24-hour pass or 7-day pass user; Subscriber = Annual Member)  
•	Gender (Zero=unknown; 1=male; 2=female)  
•	Year of Birth  


# Load Data

```r


dat <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))




> head( dat )
  tripduration     starttime      stoptime start.station.id      start.station.name start.station.latitude start.station.longitude
1         1346 1/1/2015 0:01 1/1/2015 0:24              455         1 Ave & E 44 St               40.75002               -73.96905
2          363 1/1/2015 0:02 1/1/2015 0:08              434         9 Ave & W 18 St               40.74317               -74.00366
3          346 1/1/2015 0:04 1/1/2015 0:10              491    E 24 St & Park Ave S               40.74096               -73.98602
4          182 1/1/2015 0:04 1/1/2015 0:07              384 Fulton St & Waverly Ave               40.68318               -73.96596
5          969 1/1/2015 0:05 1/1/2015 0:21              474         5 Ave & E 29 St               40.74517               -73.98683
6          496 1/1/2015 0:07 1/1/2015 0:15              512         W 29 St & 9 Ave               40.75007               -73.99839
  end.station.id            end.station.name end.station.latitude end.station.longitude bikeid   usertype birth.year gender      ID
1            265    Stanton St & Chrystie St             40.72229             -73.99148  18660 Subscriber       1960      2 455-265
2            482             W 15 St & 7 Ave             40.73936             -73.99932  16085 Subscriber       1963      1 434-482
3            505             6 Ave & W 33 St             40.74901             -73.98848  20845 Subscriber       1974      1 491-505
4            399 Lafayette Ave & St James Pl             40.68852             -73.96476  19610 Subscriber       1969      1 384-399
5            432           E 7 St & Avenue A             40.72622             -73.98380  20197 Subscriber       1977      1 474-432
6            383  Greenwich Ave & Charles St             40.73524             -74.00027  20788 Subscriber       1969      2 512-383




> lapply( dat, class )

$tripduration
[1] "integer"

$starttime
[1] "factor"

$stoptime
[1] "factor"

$start.station.id
[1] "integer"

$start.station.name
[1] "factor"

$start.station.latitude
[1] "numeric"

$start.station.longitude
[1] "numeric"

$end.station.id
[1] "integer"

$end.station.name
[1] "factor"

$end.station.latitude
[1] "numeric"

$end.station.longitude
[1] "numeric"

$bikeid
[1] "integer"

$usertype
[1] "factor"

$birth.year
[1] "integer"

$gender
[1] "integer"

$ID
[1] "character"

```
