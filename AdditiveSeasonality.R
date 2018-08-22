# change the additive to multiplative -- log


install.packages("fpp")
library(fpp)
data(ausbeer)
timeserie_beer = tail(head(ausbeer, 17*4+2),17*4-4)
plot(as.ts(timeserie_beer))

#To detect the underlying trend, we smoothe the time series using the “centred moving average“. 
install.packages("forecast")
library(forecast)
trend_beer = ma(timeserie_beer, order = 4, centre = T)
plot(as.ts(timeserie_beer))
lines(trend_beer)
plot(as.ts(trend_beer))

#Removing the previously calculated trend from the time series will result into a new time series that clearly exposes seasonality.
detrend_beer = timeserie_beer - trend_beer
plot(as.ts(detrend_beer))


m_beer = t(matrix(data = detrend_beer, nrow = 4))
seasonal_beer = colMeans(m_beer, na.rm = T)
plot(as.ts(rep(seasonal_beer,16)))

#Random = Time series – Seasonal –Trend
random_beer = timeserie_beer - trend_beer - seasonal_beer
plot(as.ts(random_beer))


#predict 1973 Q3
theForecast <- forecast(object=timeserie_beer, h=1)
theForecast




recomposed_beer = trend_beer+seasonal_beer+random_beer
plot(as.ts(recomposed_beer))

### easier way to decompose --

ts_beer = ts(timeserie_beer, frequency = 4)
decompose_beer = decompose(ts_beer, "additive")

plot(as.ts(decompose_beer$seasonal))
plot(as.ts(decompose_beer$trend))
plot(as.ts(decompose_beer$random))
plot(decompose_beer)

# excercise
ba <- ts(BABA_2, start=min(BABA_2$Date), end=max(BABA_2$Date))



ts_beer = ts(timeserie_beer, frequency = 4)
stl_beer = stl(ts_beer, "periodic")
seasonal_stl_beer   <- stl_beer$time.series[,1]
trend_stl_beer     <- stl_beer$time.series[,2]
random_stl_beer  <- stl_beer$time.series[,3]

plot(ts_beer)
plot(as.ts(seasonal_stl_beer))
plot(trend_stl_beer)
plot(random_stl_beer)
plot(stl_beer)


