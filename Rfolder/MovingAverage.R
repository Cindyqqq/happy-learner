#a
library(ggplot2)
ggplot(SmallBusiness,aes(x=Year,y=Sales))+geom_point()+geom_smooth(method="lm")+labs(x="Year",y="Sales")

#b
#calculate the 2-period and 4-period moving average
install.packages("TTR")
library(TTR)
x<-SmallBusiness[2]
sma.2 <-SMA(x, n=2)
sma.2
sma.4 <-SMA(x, n=4)
sma.4

#add the moving average to the data table
SmallBusiness[3]<-sma.2
SmallBusiness[4]<-sma.4
SmallBusiness

#plot
library(ggplot2)
ggplot(SmallBusiness, aes(x = Year)) + 
  geom_line(aes(y = Sales, colour="Sales_original")) + 
  geom_line(aes(y = V3, colour = "Sales_ma2p")) + 
  geom_line(aes(y = V4, colour = "Sales_ma4p"))+
  scale_colour_manual("", 
                      breaks = c("Sales_original", "Sales_ma2p", "Sales_ma4p"),
                      values = c("Sales_original"="green", "Sales_ma2p"="red", 
                                 "Sales_ma4p"="blue")) 
