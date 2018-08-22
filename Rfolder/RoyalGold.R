#import data
library(readxl)
RoyalGold <- read_excel("~/Downloads/RoyalGold.xlsm")
View(RoyalGold)


### a.What are the coordinates of the centroids for the significant sites and the insignificant sites?

#divide data by group
RG_sub1<-subset(RoyalGold,Group=='1')
RG_sub2<-subset(RoyalGold,Group=='2')

#calculate the centroid of each group
Coordinate1<-c(mean(RG_sub1$Calaverite),mean(RG_sub1$Sylvanite),mean(RG_sub1$Petzite))
Coordinate1
Coordinate2<-c(mean(RG_sub2$Calaverite),mean(RG_sub2$Sylvanite),mean(RG_sub2$Petzite))
Coordinate2

## Coordinate1 = (0.05484444,0.06340000,0.03726667); Coordinate2 = (0.03846667, 0.04664444, 0.03120000)


### e. Use the k-nearest neighbor technique to create a classifier for this data (with normalized inputs). What value of k seems to work best? How accurate is this procedure on the training and validation data sets?

##using Cross-Validation to find the best value of k

library(caret)
library(e1071)

#Transforming the dependent variable to a factor
RoyalGold$Group = as.factor(RoyalGold$Group)


#Partitioning the data into training and validation data
set.seed(123)
index = createDataPartition(RoyalGold$Group,p=0.8,list = F)
RGtrain = RoyalGold[index,]
RGvalidation = RoyalGold[-index,]

# Setting levels for both training and validation data
levels(RGtrain$Group)<-make.names(levels(factor(RGtrain$Group)))
levels(RGvalidation$Group)<-make.names(levels(factor(RGvalidation$Group)))

#train control
set.seed(123)
ctrl = trainControl(method = "repeatedcv", number = 5, repeats = 3, classProbs = TRUE, summaryFunction = twoClassSummary)

#run knn

model1 <- train(Group~. , data = RGtrain, method = "knn",preProcess = c("center","scale"),trControl = ctrl,metric = "ROC",tuneLength = 5)
model1

####The final value used for the model was k = 5.
