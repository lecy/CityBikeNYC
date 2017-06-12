# Mapping NYC Citi Bike Routes



# Setup

Add this code to set global options. Always initialize all of your packages up-front.





# Load Data


```r
# Upload and analyze dataset
# bikes <- readRDS("bikes.rds")
bikes <- readRDS(gzcon(url("https://github.com/lecy/CityBikeNYC/raw/master/DATA/bikes.rds")))

str(bikes) # 285552 rows
```

```
## 'data.frame':	285552 obs. of  16 variables:
##  $ tripduration           : int  1346 363 346 182 969 496 152 1183 846 576 ...
##  $ starttime              : Factor w/ 36143 levels "1/1/2015 0:01",..: 1 2 3 3 4 5 5 6 7 8 ...
##  $ stoptime               : Factor w/ 36157 levels "1/1/2015 0:07",..: 11 2 4 1 9 5 3 15 10 8 ...
##  $ start.station.id       : int  455 434 491 384 474 512 498 405 450 160 ...
##  $ start.station.name     : Factor w/ 330 levels "1 Ave & E 15 St",..: 4 22 116 169 13 283 50 320 301 126 ...
##  $ start.station.latitude : num  40.8 40.7 40.7 40.7 40.7 ...
##  $ start.station.longitude: num  -74 -74 -74 -74 -74 ...
##  $ end.station.id         : int  265 482 505 399 432 383 474 174 488 174 ...
##  $ end.station.name       : Factor w/ 330 levels "1 Ave & E 15 St",..: 257 268 16 196 153 177 13 117 290 117 ...
##  $ end.station.latitude   : num  40.7 40.7 40.7 40.7 40.7 ...
##  $ end.station.longitude  : num  -74 -74 -74 -74 -74 ...
##  $ bikeid                 : int  18660 16085 20845 19610 20197 20788 19006 17640 15691 17837 ...
##  $ usertype               : Factor w/ 2 levels "Customer","Subscriber": 2 2 2 2 2 2 2 2 2 2 ...
##  $ birth.year             : int  1960 1963 1974 1969 1977 1969 1972 1985 1991 1991 ...
##  $ gender                 : int  2 1 1 1 1 2 1 2 1 1 ...
##  $ ID                     : chr  "455-265" "434-482" "491-505" "384-399" ...
```

```r
summary(bikes)
```

```
##   tripduration               starttime                stoptime     
##  Min.   :   60.0   1/21/2015 8:48 :    53   1/23/2015 8:54:    52  
##  1st Qu.:  334.0   1/23/2015 8:48 :    51   1/22/2015 9:02:    51  
##  Median :  504.0   1/20/2015 17:46:    47   1/15/2015 8:51:    47  
##  Mean   :  654.3   1/22/2015 8:40 :    47   1/22/2015 8:50:    47  
##  3rd Qu.:  772.0   1/23/2015 8:52 :    47   1/21/2015 8:55:    46  
##  Max.   :43023.0   1/5/2015 8:49  :    47   1/21/2015 8:52:    45  
##                    (Other)        :285260   (Other)       :285264  
##  start.station.id                start.station.name start.station.latitude
##  Min.   :  72.0   8 Ave & W 31 St         :  4157   Min.   :40.68         
##  1st Qu.: 308.0   Lafayette St & E 8 St   :  3186   1st Qu.:40.72         
##  Median : 417.0   E 43 St & Vanderbilt Ave:  3139   Median :40.74         
##  Mean   : 443.5   W 21 St & 6 Ave         :  2988   Mean   :40.74         
##  3rd Qu.: 492.0   8 Ave & W 33 St         :  2637   3rd Qu.:40.75         
##  Max.   :3002.0   E 17 St & Broadway      :  2542   Max.   :40.77         
##                   (Other)                 :266903                         
##  start.station.longitude end.station.id  
##  Min.   :-74.02          Min.   :  72.0  
##  1st Qu.:-74.00          1st Qu.: 307.0  
##  Median :-73.99          Median : 417.0  
##  Mean   :-73.99          Mean   : 440.3  
##  3rd Qu.:-73.98          3rd Qu.: 492.0  
##  Max.   :-73.95          Max.   :3002.0  
##                                          
##                  end.station.name  end.station.latitude
##  8 Ave & W 31 St         :  3319   Min.   :40.68       
##  W 41 St & 8 Ave         :  3224   1st Qu.:40.72       
##  E 43 St & Vanderbilt Ave:  3128   Median :40.74       
##  Lafayette St & E 8 St   :  3128   Mean   :40.74       
##  W 21 St & 6 Ave         :  2977   3rd Qu.:40.75       
##  E 17 St & Broadway      :  2929   Max.   :40.77       
##  (Other)                 :266847                       
##  end.station.longitude     bikeid            usertype        birth.year  
##  Min.   :-74.02        Min.   :14529   Customer  :  5628   Min.   :1899  
##  1st Qu.:-74.00        1st Qu.:16355   Subscriber:279924   1st Qu.:1967  
##  Median :-73.99        Median :18148                       Median :1977  
##  Mean   :-73.99        Mean   :18147                       Mean   :1975  
##  3rd Qu.:-73.98        3rd Qu.:19903                       3rd Qu.:1984  
##  Max.   :-73.95        Max.   :21690                       Max.   :1999  
##                                                            NA's   :5628  
##      gender           ID           
##  Min.   :0.000   Length:285552     
##  1st Qu.:1.000   Class :character  
##  Median :1.000   Mode  :character  
##  Mean   :1.162                     
##  3rd Qu.:1.000                     
##  Max.   :2.000                     
## 
```

```r
names(bikes)
```

```
##  [1] "tripduration"            "starttime"              
##  [3] "stoptime"                "start.station.id"       
##  [5] "start.station.name"      "start.station.latitude" 
##  [7] "start.station.longitude" "end.station.id"         
##  [9] "end.station.name"        "end.station.latitude"   
## [11] "end.station.longitude"   "bikeid"                 
## [13] "usertype"                "birth.year"             
## [15] "gender"                  "ID"
```



# Attempt 1 (with dplyr)


Explain what you are trying to do here...



```r
# Deleting all columns besides start station lat and long
# Start station

start.station <- bikes %>% as_tibble() %>% 
  mutate(tripduration = NULL, starttime = NULL, stoptime = NULL, start.station.id = NULL,
         start.station.name = NULL, end.station.id = NULL, end.station.name = NULL, 
         end.station.latitude = NULL, end.station.longitude = NULL, bikeid = NULL, usertype = NULL, 
         birth.year = NULL, gender = NULL)
head(start.station, 10)
```

```
## # A tibble: 10 × 3
##    start.station.latitude start.station.longitude      ID
##                     <dbl>                   <dbl>   <chr>
## 1                40.75002               -73.96905 455-265
## 2                40.74317               -74.00366 434-482
## 3                40.74096               -73.98602 491-505
## 4                40.68318               -73.96596 384-399
## 5                40.74517               -73.98683 474-432
## 6                40.75007               -73.99839 512-383
## 7                40.74855               -73.98808 498-474
## 8                40.73932               -74.00812 405-174
## 9                40.76227               -73.98788 450-488
## 10               40.74824               -73.97831 160-174
```

```r
# Deleting all columns besides end station lat and long
# End station

end.station <- bikes %>% as_tibble() %>% 
  mutate(tripduration = NULL, starttime = NULL, stoptime = NULL, start.station.id = NULL,
         start.station.name = NULL, start.station.latitude = NULL, start.station.longitude = NULL, 
         end.station.id = NULL, end.station.name = NULL, bikeid = NULL, usertype = NULL, 
         birth.year = NULL, gender = NULL)
head(end.station, 10)
```

```
## # A tibble: 10 × 3
##    end.station.latitude end.station.longitude      ID
##                   <dbl>                 <dbl>   <chr>
## 1              40.72229             -73.99148 455-265
## 2              40.73936             -73.99932 434-482
## 3              40.74901             -73.98848 491-505
## 4              40.68852             -73.96476 384-399
## 5              40.72622             -73.98380 474-432
## 6              40.73524             -74.00027 512-383
## 7              40.74517             -73.98683 498-474
## 8              40.73818             -73.97739 405-174
## 9              40.75646             -73.99372 450-488
## 10             40.73818             -73.97739 160-174
```

```r
# Merge data (long and lat columns for start and end station by id)
bikes.merged <- merge(start.station, end.station, by="ID")
head(bikes.merged, 10)
```

```
##         ID start.station.latitude start.station.longitude
## 1  116-116               40.74178                -74.0015
## 2  116-116               40.74178                -74.0015
## 3  116-116               40.74178                -74.0015
## 4  116-116               40.74178                -74.0015
## 5  116-116               40.74178                -74.0015
## 6  116-116               40.74178                -74.0015
## 7  116-116               40.74178                -74.0015
## 8  116-116               40.74178                -74.0015
## 9  116-116               40.74178                -74.0015
## 10 116-116               40.74178                -74.0015
##    end.station.latitude end.station.longitude
## 1              40.74178              -74.0015
## 2              40.74178              -74.0015
## 3              40.74178              -74.0015
## 4              40.74178              -74.0015
## 5              40.74178              -74.0015
## 6              40.74178              -74.0015
## 7              40.74178              -74.0015
## 8              40.74178              -74.0015
## 9              40.74178              -74.0015
## 10             40.74178              -74.0015
```

```r
head(table(table(bikes.merged$ID)), 10)
```

```
## 
##     1     4     9    16    25    36    49    64    81   100 
## 12932  6848  4400  3182  2355  1899  1543  1264  1162   983
```

```r
# 1       4     9    16     25    36    49    64    81    100 
# 12932  6848  4400  3182  2355  1899  1543  1264  1162   983




# Group and summarize data 
bikes.merged1 <- bikes.merged %>%
  group_by(ID) %>%
  summarise(n = n())




# unique(bikes.merged1)
# ID     n
# <chr> <int>
# 1  116-116   400
# 2  116-127   100
# 3  116-128     1
# 4  116-147    16
# 5  116-151    16
# 6  116-153   169
# 7  116-157     1
# 8  116-160     9
# 9  116-167     1
# 10 116-168  1600
# ... with 44,063 more rows
```







# Attempt 2 (with dplyr)

Explain what you are trying to do here...

Another approach - not to merge two dataframes, but create the only one with dplyr.






```r
stations <- bikes %>% as_tibble() %>% 
  mutate(tripduration = NULL, starttime = NULL, stoptime = NULL, start.station.id = NULL,
         start.station.name = NULL, end.station.id = NULL, end.station.name = NULL, bikeid = NULL, usertype = NULL, 
         birth.year = NULL, gender = NULL)

head(stations, 10)
```

```
## # A tibble: 10 × 5
##    start.station.latitude start.station.longitude end.station.latitude
##                     <dbl>                   <dbl>                <dbl>
## 1                40.75002               -73.96905             40.72229
## 2                40.74317               -74.00366             40.73936
## 3                40.74096               -73.98602             40.74901
## 4                40.68318               -73.96596             40.68852
## 5                40.74517               -73.98683             40.72622
## 6                40.75007               -73.99839             40.73524
## 7                40.74855               -73.98808             40.74517
## 8                40.73932               -74.00812             40.73818
## 9                40.76227               -73.98788             40.75646
## 10               40.74824               -73.97831             40.73818
## # ... with 2 more variables: end.station.longitude <dbl>, ID <chr>
```

```r
bikes2 <- stations %>%
  group_by(ID) %>%
  summarise(n = n())


# A tibble: 44,073 × 2
# ID     n
# <chr> <int>
#  1  116-116    20
# 2  116-127    10
# 3  116-128     1
# 4  116-147     4
# 5  116-151     4
# 6  116-153    13
# 7  116-157     1
# 8  116-160     3
# 9  116-167     1
# 10 116-168    40
# ... with 44,063 more rows





head(table(table(stations$ID)), 10)
```

```
## 
##     1     2     3     4     5     6     7     8     9    10 
## 12932  6848  4400  3182  2355  1899  1543  1264  1162   983
```

```r
# 1       4     9    16     25    36    49    64    81    100 
# 12932  6848  4400  3182  2355  1899  1543  1264  1162   983 
```


So, situation is different, answers are different - in the first approach we have observations, 
which are square rooted. 

Which of options is correct? 

Based on Environment, it looks like the second approach is correct. 
