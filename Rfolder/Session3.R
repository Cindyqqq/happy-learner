
#for loop
for (i in 1:10) {print(i)}

x<-12
print(x)
x<-c(1,2,3)
print(x)

#function
print(1:10)

#vector
#{1,2,3...}
#{"a","b"...}
#{"a", a, ...}
#"a"-character  a-variable

fruit <- c("apple","banana","pomegrante")
fruitlength <-rep(NA,length(fruit))
?rep
fruitlength

?names
names(fruitlength)<-fruit
fruitlength

#using for loop
for(a in fruit) {fruitlength[a]<-nchar(a)}
fruitlength

#using function
fruit
a
fruitlength2 <- nchar(fruit)
names(fruitlength2)<-fruit
fruitlength


identical(fruitlength,fruitlength2)


#while loop
x<-2
while(x<=5) {print(x)
  x<-x+1}


for(i in 1:10) { 
  if(i == 3)  {
    break
  }
  print(i)
}



##
x <- sample(x=1:100,size=100,replace=TRUE)
x
mean(x)
x[12]<-NA
mean(x)
x[12]<-NULL


y<-x
y[sample(x=1:100,size=20,replace=FALSE)] <-NA
y
mean(y)
#remove NAs
mean(y,na.rm=TRUE)

grades <- c(90,90,100,100)
weights <- c(0.2,0.5,0.2,0.1)
mean(grades)
weighted.mean(x=grades,w=weights)




x<-sample(x=1:100,size=100,replace=TRUE)
var(x)
z<-sum((x-mean(x))^2)/(length(x)-1)
z
identical(z,var(x))

sd(x)
u<-sqrt(var(x))
u
identical(u,sd(x))


summary(x)
quantile(x)
quantile(x,probs=c(0.25,0.75))
quantile(x,probs=c(0.1,0.9))


cor(economics$pce, economics$psavert)
cor(economics[,c(2,4:6)])

install.packages("GGally")
library(GGally)
GGally::ggpairs(economics[, c(2, 4:6)])

library(reshape2)
library(scales)
#build the correlation matrix
econCor<-cor(economics[,c(2,4:6)])
econMelt <- melt(econCor, varnames=c("x", "y"), value.name="Correlation")
econMelt <- econMelt[order(econMelt$Correlation), ]
econMelt



install.packages("UsingR")
library("UsingR")
data(father.son,package='UsingR')
library(ggplot2)
head(father.son)
ggplot(father.son,aes(x=fheight,y=sheight))+geom_point()+geom_smooth(method="lm")+labs(x="Fathers",y="Sons")
#To actually calculate a regression, use the lm function
heightsLM<-lm(sheight~fheight,data=father.son)
heightsLM
summary(heightsLM)


#2ways to see the model is good or bad
#Rsuare-large
#sd for the parameter-small
#what is degree of freedom?


housing <- read.table("http://www.jaredlander.com/data/housing.csv",
                      sep=",",header=TRUE,
                      stringsAsFactors=FALSE)
names(housing)<-  c("Neighborhood",  "Class",  "Units",  "YearBuilt",
                    "SqFt",  "Income",  "IncomePerSqFt",  "Expense",
                    "ExpensePerSqFt",  "NetIncome",  "Value",
                    "ValuePerSqFt",  "Boro")
head(housing)

house1 <- lm(ValuePerSqFt ~ Units + SqFt + Boro, data=housing)
summary(house1)

#what is p value?

install.packages("coefplot")
library("coefplot")
coefplot(house1)
coefplot(house1, sort='mag') + scale_x_continuous(limits=c(-.25, .1))  

?predict
predict(house1)
