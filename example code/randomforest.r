  library(readxl)
  library(randomForest)
  
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
  
  set.seed(1234)
  
  rf_model <- randomForest(`Consumption (W)`~., data = Trainingdataset,
                           ntree = 1000, mtry = 3, nodesize = 5, importance = TRUE)
y_pred = predict(regressor,newdata = Testingdataset)

Testingdataset$predicted<-y_pred

ggplot(Testingdataset, aes(x = as.Date(Time))) + 
  geom_line(aes(y = predicted), colour="black") + 
    ylab(label="Consumption(W)") + 
  xlab("
      time")


sMAPE <-function(yTest, yHat) {
  mean(abs((yTest-yHat)/(abs(yTest)+abs(yHat))))*200
}
sMape(Testingdataset$)
