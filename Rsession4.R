acs<-read.table("http://jaredlander.com/data/acs_ny.csv", sep=",",header=TRUE,stringsAsFactors=FALSE)
#data frame can contain various data type but matrix contains only numerics
class(acs)
head(acs)

#add a conlume Income
acs$Income<-with(acs, FamilyIncome>=150000)
acsfiltered<-with(acs, FamilyIncome>=150000)
head(acsfiltered)

#add a line on the plot
library(ggplot2)
library(useful)
ggplot(acs,aes(x=FamilyIncome))+geom_density(fill="grey",color="grey")+geom_vline(xintercept=150000)+scale_x_continuous(label=multiple.dollar,limits=c(0,1000000))

#logistic regression using glm 
income1<-glm(Income~HouseCosts+NumWorkers+OwnRent+NumBedrooms+FamilyType,data=acs,family=binomial(link="logit"))
summary(income1)

#coefficient plot (a1,a2,a3,...  the dependent variable is more sentitive to the independent variale ownrentoutright)
library(coefplot)
coefplot(income1)

#
invlogit<-function(x) {1/(1+exp(-x))}
invlogit(income1$coefficients)
#p near to 1 means Familyincome is more than 15000, p near to 0 neans less than


#
ggplot(acs,aes(x=NumChildren))+geom_histogram(binwidth=1)
children1<-glm(NumChildren~FamilyIncome+FamilyType+OwnRent,data=acs,family=poisson(link="log"))
summary(children1)
coefplot(children1)



#survival analysis: Data used for survival analysis are different from most other data in that they are censored, meaning there is unknown information, typically about what happens to a subject after a given amount of time. 
library(survival)
head(bladder)
class(bladder)
bladder[1:5]
bladder[1:5,1:3]
bladder[100:105, ]
#
survObject<-with(bladder[100:105, ],Surv(stop, event))
class(survObject)
survObject
survObject[,1:2]

cox1<-coxph(Surv(stop, event)~rx+number+size+enum,data=bladder)
summary(cox1)
plot(survfit(cox1),xlab="Days",ylab="Survival Rate",conf.int=TRUE)
cox2<-coxph(Surv(stop, event)~strata(rx)+number+size+enum,data=bladder)
summary(cox2)
plot(survfit(cox2),xlab="Days",ylab="Survival Rate",conf.int=TRUE,col=1:2)

#add a legend
legend("bottomleft",legend=c(1,2),lty=1, col=1:2, text.col=1:2, title="rx")





#
housing <- read.table("http://www.jaredlander.com/data/housing.csv",sep = ",", header = TRUE,stringsAsFactors = FALSE)
names(housing) <- c("Neighborhood", "Class", "Units", "YearBuilt","SqFt", "Income", "IncomePerSqFt", "Expense","ExpensePerSqFt", "NetIncome", "Value","ValuePerSqFt", "Boro")

# eliminate some outliers
housing <- housing[housing$Units < 1000, ]
head(housing)

house1 <- lm(ValuePerSqFt ~ Units + SqFt + Boro, data=housing)
summary(house1)

library(coefplot)
coefplot(house1)
#the line around the dot means the standard deviation


plot(house1)
#Hit <Return> to see next plot
plot(house1,which = 1)
plot(house1,which = 2)

plot(house1, which=1, col=as.numeric(factor(house1$model$Boro)))
legend("topright", legend=levels(factor(house1$model$Boro)), pch=1,col=as.numeric(factor(levels(factor(house1$model$Boro)))),text.col=as.numeric(factor(levels(factor(house1$model$Boro)))),title="Boro")
#fitted value=expected value
#residual=fitted value-actual value, error= residual^2, sum errot =MSE, the coef is the one that minimize the MSE or error.



house2 <- lm(ValuePerSqFt ~ Units * SqFt + Boro, data=housing)
house3 <- lm(ValuePerSqFt ~ Units + SqFt * Boro + Class,data=housing)
house4 <- lm(ValuePerSqFt ~ Units + SqFt * Boro + SqFt*Class,data=housing)
house5 <- lm(ValuePerSqFt ~ Boro + Class, data=housing)

#Ways to compare models
multiplot(house1, house2, house3, house4, house5, pointSize=2)
anova(house1, house2, house3, house4, house5)
#WHICH ONE IS MORE USEFUL? STANDARD ERROR OR RSS? - IT DEPENDS.
AIC(house1, house2, house3, house4, house5)
BIC(house1, house2, house3, house4, house5)


data(diamonds)
head(diamonds)
# fit with a few different degrees of freedom
# the degrees of freedom must be greater than 1
# but less than the number of unique x values in the data
diaSpline1 <- smooth.spline(x=diamonds$carat, y=diamonds$price)
diaSpline2 <- smooth.spline(x=diamonds$carat, y=diamonds$price,df=2)
diaSpline3 <- smooth.spline(x=diamonds$carat, y=diamonds$price,df=10)
diaSpline4 <- smooth.spline(x=diamonds$carat, y=diamonds$price,df=20)
diaSpline5 <- smooth.spline(x=diamonds$carat, y=diamonds$price,df=50)
diaSpline6 <- smooth.spline(x=diamonds$carat, y=diamonds$price,df=100)

get.spline.info <- function(object){data.frame(x=object$x, y=object$y, df=object$df)}
library(plyr)
#combine results into one data.frame
splineDF <- ldply(list(diaSpline1, diaSpline2, diaSpline3, diaSpline4,diaSpline5, diaSpline6), get.spline.info)

g <- ggplot(diamonds, aes(x=carat, y=price)) + geom_point()
g + geom_line(data=splineDF,aes(x=x, y=y, color=factor(round(df, 0)), group=df))+scale_color_discrete("Degrees of \nFreedom")
g



#decision tree

# make vector of column names
creditNames <- c("Checking", "Duration", "CreditHistory", "Purpose","Job", "NumLiable", "Phone", "Foreign", "Credit")

# use read.table to read the file
# specify that headers are not included
# the col.names are from creditNames
theURL <- "http://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german/german.data"
credit <- read.table(theURL, sep=" ", header=FALSE,col.names=creditNames, stringsAsFactors=FALSE)

creditHistory <- c(A30="All Paid", A31="All Paid This Bank",A32="Up To Date", A33="Late Payment",A34="Critical Account")
purpose <- c(A40="car (new)", A41="car (used)",A42="furniture/equipment", A43="radio/television",A44="domestic appliances", A45="repairs", A46="education",A47="(vacation - does not exist?)", A48="retraining",A49="business", A410="others")



###########################



library(rpart)
creditTree <- rpart(Credit ~ CreditAmount + Age +CreditHistory + Employment, data=credit)
creditTree
library(rpart.plot)
rpart.plot(creditTree,extra=4)
creditTree