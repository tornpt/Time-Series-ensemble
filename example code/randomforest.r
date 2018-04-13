  library(readxl)
  library(randomForest)
  
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
  
  rf_model <- randomForest(ConsumptionW~., data = Trainingdataset,
        
                                              ntree = 1000, mtry = 5, nodesize = 5, importance = TRUE)
y_pred = predict(rf_model,newdata = Testingdataset)

Testingdataset$predicted<-y_pred

ggplot(Testingdataset, aes(x = as.Date(Time))) + 
  geom_line(aes(y = predicted), colour="black") + 
    ylab(label="Consumption(W)") + 
  xlab("
      time")


sMAPE <-function(yTest, yHat) {
  mean(abs((yTest-yHat)/(abs(yTest)+abs(yHat))))*200
}
sMAPE(Testingdataset$ConsumptionW,Testingdataset$predicted)

library(Metrics)


