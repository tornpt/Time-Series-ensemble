library(ggplot2)
library(gbm)
library(readxl)

xlsx_example <- readxl_example("Building N Consumption-python.xlsx")
data<-read_excel(xlsx_example)

data_2<-data
data<-data[ -c(1) ]

median<-mean(data$ConsumptionW)
w<-which(data$ConsumptionW==0)

data$ConsumptionW<-replace(data$ConsumptionW,w,median)
indexes = sample(1:nrow(data), 
                 size=0.8*nrow(data))

Trainingdataset <- data[indexes,]
Testingdataset <- data[-indexes,]
set.seed(150)

fit <- gbm(ConsumptionW~., data = Trainingdataset, n.trees = 5000)

model <- predict(fit, newdata = Testingdataset, n.trees = 5000)

Testingdataset$predicted<-model

sMAPE <-function(yTest, yHat) {
  mean(abs((yTest-yHat)/(abs(yTest)+abs(yHat))))*200
}
sMAPE(Testingdataset$ConsumptionW,Testingdataset$predicted)


