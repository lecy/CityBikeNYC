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
```
