---
Title: "Time series using AirPassenger Data"
Output: Exploratory Data Analysis
Author: Kamal
---

# Timeseries using AirPassenger Data for R

Load required libraries
```
library(dplyr)
library(tseries)
```

Loading the Data Set
Take the AirPassenger dataset that comes with R
```
data(AirPassengers)
class(AirPassengers) #This tells you that the data series is in a time series format
start(AirPassengers) #This is the start of the time series
end(AirPassengers) #This is the end of the time series
frequency(AirPassengers) #The cycle of this time series is 12months in a year
summary(AirPassengers)
```

Detailed Metrics
```
plot(AirPassengers)
abline(reg=lm(AirPassengers~time(AirPassengers))) # This will fit in a line
cycle(AirPassengers) #This will print the cycle across years.
plot(aggregate(AirPassengers,FUN=mean)) #This will aggregate the cycles and display a year on year trend
boxplot(AirPassengers~cycle(AirPassengers)) #Box plot across months will give us a sense on seasonal effect
```
![plot of chunk AirPassenger data](/figures/Timeseries_AirPassenger1.PNG)
