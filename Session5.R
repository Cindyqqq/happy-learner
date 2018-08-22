#session 5
# load the World Bank API package

library(WDI)
# pull the data
gdp <- WDI(country=c("US", "CA", "GB", "DE", "CN", "JP", "SG", "IL"),indicator=c("NY.GDP.PCAP.CD", "NY.GDP.MKTP.CD"),start=1960, end=2011)
# give it good names
names(gdp) <- c("iso2c", "Country", "Year", "PerCapGDP", "GDP")
head(gdp)

library(ggplot2)
library(scales)
# per capita GDP
ggplot(gdp, aes(Year, PerCapGDP, color=Country, linetype=Country)) + geom_line() + scale_y_continuous(label=dollar)

library(useful)
# absolute GDP
ggplot(gdp, aes(Year, GDP, color=Country, linetype=Country)) + geom_line() + scale_y_continuous(label=multiple_format(extra=dollar,multiple="M"))


# get US data
us <- gdp$PerCapGDP[gdp$Country == "United States"]
# convert it to a time series
us <- ts(us, start=min(gdp$Year), end=max(gdp$Year))
us


plot(us, ylab="Per Capita GDP", xlab="Year")

acf(us)
pacf(us)


x <- c(1 , 4 , 8 , 2 , 6 , 6 , 5 , 3)
# one diff
diff(x, differences=1)

# two iterative diffs
diff(x, differences=2)

# equivalent to one diff
diff(x, lag=1)

# diff elements that are two indices apart
diff(x, lag=2)


library(forecast)
ndiffs(x=us)

plot(diff(us, 2))

usBest <- auto.arima(x=us)
usBest

acf(usBest$residuals)
pacf(usBest$residuals)

coef(usBest)

# predict 5 years into the future and include the standard error
predict(usBest, n.ahead=5, se.fit=TRUE)

# make a prediction for 5 years out
theForecast <- forecast(object=usBest, h=5)
# plot it
plot(theForecast)


# load reshape2
library(reshape2)
# cast the data.frame to wide format
gdpCast <- dcast(Year ~ Country,data=gdp[, c("Country", "Year", "PerCapGDP")],value.var="PerCapGDP")
head(gdpCast)


# remove first 10 rows since Germany did not have
# convert to time series
gdpTS <- ts(data=gdpCast[, -1], start=min (gdpCast$Year),end=max(gdpCast$Year))

# build a plot and legend using base graphics
plot(gdpTS, plot.type="single", col=1:8)
legend("topleft", legend=colnames(gdpTS), ncol=2, lty=1,col=1:8, cex=.9)

gdpTS <- gdpTS[, which(colnames(gdpTS) != "Germany")]

numDiffs <- ndiffs(gdpTS)
numDiffs


gdpDiffed <- diff(gdpTS, differences=numDiffs)
plot(gdpDiffed, plot.type="single", col=1:7)
legend("bottomleft", legend=colnames(gdpDiffed), ncol=2, lty=1,col=1:7, cex=.9)


library(vars)
# fit the model
gdpVar <- VAR(gdpDiffed, lag.max=12)
# chosen order
gdpVar$p


# names of each of the models
names(gdpVar$varresult)

# each model is actually an lm object
class(gdpVar$varresult$Canada)

class(gdpVar$varresult$Japan)

# each model has its own coefficients
head(coef(gdpVar$varresult$Canada))

head(coef(gdpVar$varresult$Japan))

library(coefplot)
coefplot(gdpVar$varresult$Canada)
coefplot(gdpVar$varresult$Japan)

predict(gdpVar, n.ahead=5)




library(quantmod)
load("data/att.rdata")

library(quantmod)
att <- getSymbols("T", auto.assign=FALSE)

library(xts)
# show data
head(att)

plot(att)


chartSeries(att)
addBBands()
addMACD(32, 50, 12)

attClose <- att$T.Close
class(attClose)

head(attClose)


library(rugarch)
attSpec <- ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(1, 1)), mean.model=list(armaOrder=c(1, 1)), distribution.model="std")

attGarch <- ugarchfit(spec=attSpec, data=attClose)
attGarch

# attGarch is an S4 object so its slots are accessed by @
# the slot fit is a list, its elements are accessed by the dollar sign
plot(attGarch@fit$residuals, type="l")
plot(attGarch, which=10)


# ARMA(1,1)
attSpec1 <- ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(1, 1)), mean.model=list(armaOrder=c(1, 1)), distribution.model="std")
# ARMA(0,0)
attSpec2 <- ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(1, 1)), mean.model=list(armaOrder=c(0, 0)), distribution.model="std")
# ARMA(0,2)
attSpec3 <- ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(1, 1)), mean.model=list(armaOrder=c(0, 2)), distribution.model="std")
# ARMA(1,2)
attSpec4 <- ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(1, 1)), mean.model=list(armaOrder=c(1, 2)), distribution.model="std")

attGarch1 <- ugarchfit(spec=attSpec1, data=attClose)
attGarch2 <- ugarchfit(spec=attSpec2, data=attClose)
attGarch3 <- ugarchfit(spec=attSpec3, data=attClose)
attGarch4 <- ugarchfit(spec=attSpec4, data=attClose)

infocriteria(attGarch1)

infocriteria(attGarch2)

infocriteria(attGarch3)

infocriteria(attGarch4)

attPred <- ugarchboot(attGarch, n.ahead=50, method=c("Partial", "Full") [1])
plot(attPred, which=2)

# diff the logs, drop the first one which is now NA
attLog <- diff(log(attClose))[-1]
# build the specification
attLogSpec <- ugarchspec(variance.model=list(model="sGARCH", garchOrder=c(1, 1)), mean.model=list(armaOrder=c(1, 1)), distribution.model="std")
# fit the model
attLogGarch <- ugarchfit(spec=attLogSpec, data=attLog)
infocriteria(attLogGarch)













wineUrl <- 'http://archive.ics.uci.edu/ml/machine-learning-databases/wine/wine.data'
wine <- read.table(wineUrl, header=FALSE, sep=',', stringsAsFactors=FALSE, col.names=c('Cultivar', 'Alcohol', 'Malic.acid','Ash', 'Alcalinity.of.ash','Magnesium', 'Total.phenols','Flavanoids', 'Nonflavanoid.phenols','Proanthocyanin', 'Color.intensity','Hue', 'OD280.OD315.of.diluted.wines','Proline'))
head(wine)

wineTrain <- wine[, which(names(wine) != "Cultivar")]

set.seed(278613)
wineK3 <- kmeans(x=wineTrain, centers=3)

wineK3

library(useful)
plot(wineK3, data=wineTrain)


plot(wineK3, data=wine, class="Cultivar")

set.seed(278613)
wineK3N25 <- kmeans(wineTrain, centers=3, nstart=25)
# see the cluster sizes with 1 start
wineK3$size


# see the cluster sizes with 25 starts
wineK3N25$size


wineBest <- FitKMeans(wineTrain, max.clusters=20, nstart=25, seed=278613)
wineBest

PlotHartigan(wineBest)

table(wine$Cultivar, wineK3N25$cluster)

plot(table(wine$Cultivar, wineK3N25$cluster), main="Confusion Matrix for Wine Clustering", xlab="Cultivar", ylab="Cluster")

library(cluster)
theGap <- clusGap(wineTrain, FUNcluster=pam, K.max=20)
gapDF <- as.data.frame(theGap$Tab)
gapDF



# logW curves
ggplot(gapDF, aes(x=1:nrow(gapDF))) + geom_line(aes(y=logW), color="blue") + geom_point(aes(y=logW), color="blue") + geom_line(aes(y=E.logW), color="green") + geom_point(aes(y=E.logW), color="green") + labs(x="Number of Clusters")

# gap curve
ggplot(gapDF,aes(x=1:nrow(gapDF))) + geom_line(aes(y=gap), color="red") + geom_point(aes(y=gap), color="red") + geom_errorbar(aes(ymin=gap-SE.sim, ymax=gap+SE.sim), color="red") + labs(x="Number of Clusters", y="Gap")


indicators <- c("BX.KLT.DINV.WD.GD.ZS", "NY.GDP.DEFL.KD.ZG","NY.GDP.MKTP.CD", "NY.GDP.MKTP.KD.ZG","NY.GDP.PCAP.CD", "NY.GDP.PCAP.KD.ZG","TG.VAL.TOTL.GD.ZS")
library(WDI)

# pull info on these indicators for all countries in our list
# not all countries have information for every indicator
# some countries do not have any data
wbInfo <- WDI(country="all", indicator=indicators, start=2011,end=2011, extra=TRUE)
# get rid of aggregated info
wbInfo <- wbInfo[wbInfo$region != "Aggregates", ]
# get rid of countries where all the indicators are NA
wbInfo <- wbInfo[which(rowSums(!is.na(wbInfo[, indicators])) > 0), ]
# get rid of any rows where the iso is missing
wbInfo <- wbInfo[!is.na(wbInfo$iso2c), ]


# set rownames so we know the country without using that for clustering
rownames(wbInfo) <- wbInfo$iso2c
# refactorize region, income and lending
# this accounts for any changes in the levels
wbInfo$region <- factor(wbInfo$region)
wbInfo$income <- factor(wbInfo$income)
wbInfo$lending <- factor(wbInfo$lending)


# find which columns to keep
# not those in this vector
keep.cols <- which(!names(wbInfo) %in% c("iso2c", "country", "year","capital", "iso3c"))
# fit the clustering
wbPam <- pam(x=wbInfo[, keep.cols], k=12,keep.diss=TRUE, keep.data=TRUE)

# show the medoid observations
wbPam$medoids

plot(wbPam, which.plots=2, main="")

download.file(url="http://jaredlander.com/data/worldmap.zip",destfile="data/worldmap.zip", method="curl")
unzip(zipfile="data/worldmap.zip", exdir="data")


library(maptools)
world <- readShapeSpatial("data/world_country_admin_boundary_shapefile_with_fips_codes.shp")
head(world@data)


library(dplyr)
world@data$FipsCntry <- as.character(
    +     recode(world@data$FipsCntry,
                 +            AU="AT", AS="AU", VM="VN", BM="MM", SP="ES",
                 +            PO="PT", IC="IL", SF="ZA", TU="TR", IZ="IQ",
                 +            UK="GB", EI="IE", SU="SD", MA="MG", MO="MA",
                 +            JA="JP", SW="SE", SN="SG"))

# make an id column using the rownames
world@data$id <- rownames(world@data)
# convert into a data.frame
library(broom)
world.df <- tidy(world, region="id")
head(world.df)


world.df <- left_join(world.df,
                      +                       world@data[, c("id", "CntryName", "FipsCntry")],
                      +                       by="id")
head(world.df)


clusterMembership <- data.frame(FipsCntry=names(wbPam$clustering),
                                +                                 Cluster=wbPam$clustering,
                                +                                 stringsAsFactors=FALSE)
head(clusterMembership)


world.df <- left_join(world.df, clusterMembership, by="FipsCntry")
world.df$Cluster <- as.character(world.df$Cluster)
world.df$Cluster <- factor(world.df$Cluster, levels=1:12)


ggplot() +
    +     geom_polygon(data=world.df, aes(x=long, y=lat, group=group,
                                          +                                     fill=Cluster, color=Cluster)) +
    +     labs(x=NULL, y=NULL) + coord_equal() +
    +     theme(panel.grid.major=element_blank(),
                +           panel.grid.minor=element_blank(),
                +           axis.text.x=element_blank(), axis.text.y=element_blank(),
                +           axis.ticks=element_blank(), panel.background=element_blank())

wbPam$clusinfo




wineH <- hclust(d=dist(wineTrain))
plot(wineH)



# calculate distance
keep.cols <- which(!names(wbInfo) %in% c("iso2c", "country", "year","capital", "iso3c"))
wbDaisy <- daisy(x=wbInfo[, keep.cols])

wbH <- hclust(wbDaisy)
plot(wbH)


wineH1 <- hclust(dist(wineTrain), method="single")
wineH2 <- hclust(dist(wineTrain), method="complete")
wineH3 <- hclust(dist(wineTrain), method="average")
wineH4 <- hclust(dist(wineTrain), method="centroid")

plot(wineH1, labels=FALSE, main="Single")
plot(wineH2, labels=FALSE, main="Complete")
plot(wineH3, labels=FALSE, main="Average")
plot(wineH4, labels=FALSE, main="Centroid")


# plot the tree
plot(wineH)
# split into 3 clusters
rect.hclust(wineH, k=3, border="red")
# split into 13 clusters
rect.hclust(wineH, k=13, border="blue")


# plot the tree
plot(wineH)
# split into 3 clusters
rect.hclust(wineH, h=200, border="red")
# split into 13 clusters
rect.hclust(wineH, h=800, border="blue")















library(caret)
ctrl <- trainControl(method = "repeatedcv",repeats=3,number=5,summaryFunction=defaultSummary,allowParallel=TRUE)

gamGrid <- data.frame(select=c(TRUE, TRUE, FALSE, FALSE),method = c('GCV.Cp', 'REML', 'GCV.Cp', 'REML'),stringsAsFactors=FALSE)
gamGrid


acs <- tibble::as_tibble(read.table("http://jaredlander.com/data/acs_ny.csv",sep=",", header=TRUE, stringsAsFactors=FALSE))


library(plyr)
library(dplyr)
acs <- acs %>% mutate(Income=factor(FamilyIncome >= 150000,levels=c(FALSE, TRUE),labels=c('Below', 'Above')))


acsFormula <- Income ~ NumChildren +
    +     NumRooms + NumVehicles + NumWorkers + OwnRent +
    +     ElectricBill + FoodStamp + HeatingFuel

ctrl <- trainControl(method="repeatedcv",repeats=2,number=5,summaryFunction=twoClassSummary,classProbs=TRUE,allowParallel=FALSE)


boostGrid <- expand.grid(nrounds=100,max_depth=c(2, 6, 10),eta=c(0.01, 0.1),gamma=c(0),colsample_bytree=1,min_child_weight=1,subsample=0.7)


set.seed(73615)
boostTuned <- train(acsFormula, data=acs,method="xgbTree",metric="ROC",trControl=ctrl, tuneGrid=boostGrid, nthread=4)

boostTuned$results %>% arrange(ROC)


xgb.plot.multi.trees(boostTuned$finalModel,feature_names=boostTuned$coefnames)

acsNew <- read.table('http://www.jaredlander.com/data/acsNew.csv',header=TRUE, sep=',', stringsAsFactors=FALSE)

predict(boostTuned, newdata=acsNew, type='raw') %>% head




















































































