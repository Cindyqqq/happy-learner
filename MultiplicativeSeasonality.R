install.packages("Ecdat")
library(Ecdat)
data(AirPassengers)
timeserie_air = AirPassengers
plot(as.ts(timeserie_air))


install.packages("forecast")
library(forecast)
trend_air = ma(timeserie_air, order = 12, centre = T)
plot(as.ts(timeserie_air))
lines(trend_air)
plot(as.ts(trend_air))


detrend_air = timeserie_air / trend_air
plot(as.ts(detrend_air))


m_air = t(matrix(data = detrend_air, nrow = 12))
seasonal_air = colMeans(m_air, na.rm = T)
plot(as.ts(rep(seasonal_air,12)))


random_air = timeserie_air / (trend_air * seasonal_air)
plot(as.ts(random_air))


recomposed_air = trend_air*seasonal_air*random_air
plot(as.ts(recomposed_air))


ts_air = ts(timeserie_air, frequency = 12)
decompose_air = decompose(ts_air, "multiplicative")

plot(as.ts(decompose_air$seasonal))
plot(as.ts(decompose_air$trend))
plot(as.ts(decompose_air$random))
plot(decompose_air)



ts_test = ts(timeserie_air, frequency = 12)
stl_air = stl(ts_test, "periodic")
seasonal_stl_air   <- stl_beer$time.series[,1]
trend_stl_air     <- stl_beer$time.series[,2]
random_stl_air  <- stl_beer$time.series[,3]

plot(ts_test)
plot(as.ts(seasonal_stl_air))
plot(trend_stl_air)
plot(random_stl_air)
plot(stl_air)
