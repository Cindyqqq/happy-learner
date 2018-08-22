i<-5
is.integer(i)
i<-5L
is.integer(i)
class(2*2L)
class(6L/2L)
class(6L*2L)
?factor
x<-"data"
y<-"3"
x
y


## FACTOR
x<-factor("data")
y<-factor("3")
x
y
class(x)
y<-"akdfbacjd"
nchar(y)
data1<-as.Date("2018-06-28")
class(data1)
?as.Date
data2<-as.POSIXct("2018-09-28 9:55")
data2
class(data2)
as.numeric(data2)
is.logical(y)
?is.logical
j<-TRUE
class(j)
2 == 3
2!= 3

## Vector
x<-c(1,2,3,4,5,6,7,8,9,10)#c:combine
class(x)
u<-c("s","r")
class(u)
x*3
x-3
2:-2
x<-1:10
y<--5:4
x/y
class(Inf)
length(x)
length(x+y)
x+c(1,2) # 1+1,2+2,3+1,4+2...
x+c(1,2,3)
x<5
z<-(x<5)
class(z)
x*z # a good way to filter data
x<y
any(x<y)
all(x>y)
nchar(y)
x[3]
c<-3
x[c]
x[1:3] #different from that in python
x[c(1,6)] # ?
apropos("mea") #when you forget the function
mean(x)
z<-c(1,2,NA,4)
z
class(z)
class(NA)
length(z)#4,mean=NA
z<-c(1,2,NULL,4) # NULL is different from NA,NA is not assigned
length(z)#3



## advanced data structure
x<-1:10
y<--5:4
q<-c("Hockey","Football","Baseball","Curling","Rugby","Lacrosse","Basketball","Tennis","Cricket","Soccer")
theDF<-data.frame(x,y,q)
theDF
theDF<-data.frame(First=x,Second=y,Sports=q)
theDF
nrow(theDF)
ncol(theDF)
dim(theDF)
names(theDF)
head(theDF,n=2)
tail(theDF,n=2)
theDF[3,2]
theDF[3,1:3]
theDF[c(3,5),2]
class(theDF[c(3,5),2])
class(theDF[3,1:3])

## the differene between vector and data.frame: the vector contains only numeric, but the data.frame contains all types

##LIST Alistcan contain allnumerics orcharacters or a mix of the two ordata.frames or, recursively, otherlists.
list()

##Matrix



theUrl  <- "http://www.jaredlander.com/data/TomatoFirst.csv"
class(theUrl)
tomato <-read.table(file=theUrl, header=TRUE, sep=",")
tomato

data() # embedded datasets


##PLOTTING
install.packages("ggplot2")
data(diamonds,package='ggplot2')
head(diamonds)
library(ggplot2)
hist(diamonds$carat,main="Carat Histogram",xlab="Carat") #histogram
hist(diamonds$carat,main="Carat Histogram",xlab="c")
plot(price~carat,data = diamonds) #scatter plot
plot(price~carat,data = diamonds, main="test",xlab="carat",ylab="price")

ggplot(data=diamonds)+geom_histogram(aes(x=carat))
ggplot(data=diamonds)+geom_histogram(aes(x=carat),fill="grey50",bins = 10)
g<-ggplot(diamonds,aes(x=carat,y=price))
class(g)
g+geom_point(aes(color=color)) #color the dots
g+geom_point(aes(color=color))+facet_wrap(~color)

