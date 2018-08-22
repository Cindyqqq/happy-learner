#Predicting the stock price of Alibaba

library(readr)
BABA <- read_csv("~/Downloads/BABA.csv")
BAbest<- auto.arima(x=BABA$Close)
BAbest
predict(BAbest, n.ahead=5, se.fit=TRUE)
library(forecast)
theForecast <- forecast(object=BAbest, h=5)
plot(theForecast)