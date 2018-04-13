library(ggplot2)
library(gbm)
library(readxl)

xlsx_example <- readxl_example("Building N Consumption.xlsx")
data<-read_excel(xlsx_example)

new <- do.call( rbind , strsplit( as.character( data$Time ) , " " ) )

data$Time<-as.Date(new[,1])
data$Time<-as.numeric(data$Time)
data$hora<- new[,2]
new2<- do.call( rbind , strsplit( as.character( data$hora ) , ":" ) )


data$hora<-as.numeric(new2[,1])*60*60+as.numeric(new2[,2])*60+as.numeric(new2[,3])


indexes = sample(1:nrow(data), 
                 size=0.6*nrow(data))

Trainingdataset <- data[indexes,]
Testingdataset <- data[-indexes,]
set.seed(150)

fit <- gbm(`Consumption (W)`~., data = Trainingdataset, n.trees = 100000)

model <- predict(fit, newdata = Testingdataset, n.trees = 100000)

Testingdataset$predicted<-model

sMAPE <-function(yTest, yHat) {
  mean(abs((yTest-yHat)/(abs(yTest)+abs(yHat))))*200
}
sMAPE(Testingdataset$`Consumption (W)`,Testingdataset$predicted)
