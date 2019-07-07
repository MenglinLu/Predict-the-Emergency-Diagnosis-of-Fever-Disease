library(readr)
library(dplyr)
data <- read.csv('C:/Users/lenovo/Desktop/datathon4/data_final.csv')[, -8]
data$sex <- as.factor(data$sex)
data$antibiotic_flag <- as.factor(data$antibiotic_flag)
data$infection <- as.factor(data$infection)
data$baso <- as.numeric(data$baso)

# split data into training set and validation set
train.data <- data[sample(1436, 1077), ]
valid.data <- anti_join(data, train.data)

# use cross validation
# use 10-fold 
library(caret)
set.seed(1234)
data.rf <- train.data
folds <- createFolds(y = data.rf$infection, k=5)
aucsum <- 0
impresult <- as.data.frame(colnames(train.data))
colnames(impresult) <- 'var'
impresult$var <- as.character(impresult$var)
for (i in 1:5){
  fold.test <- data.rf[folds[[i]], ]
  fold.train <- data.rf[-folds[[i]], ]
  rf <- randomForest(infection ~ .
                     , data = fold.train, ntree=420, proximity=TRUE,importance=TRUE)  
  # importance(rf)
  a <- as.data.frame(importance(rf))[, -c(1, 2)]
  a$var <- rownames(a)
  impresult <- merge(impresult, a, by = 'var')
  # varImpPlot(rf, n.var = 20, main = 'Variable importance, Random Forest')
  fold.test$pred2 <- predict(rf, fold.test, type = 'prob')
  rocobj1 <- plot.roc(fold.test$infection,
                      fold.test$pred2[, 2],
                      percent=TRUE,ci=TRUE,col="#1c61b6"
                      #, print.auc=TRUE
                      )
  
  pred3 <- predict(rf, fold.test, type = 'prob')
  z <- table(predict(rf, fold.test), fold.test$infection)
  q <- sum(diag(z))/sum(z)
  aucsum <- aucsum + rocobj1$auc
}
auc.rt <- aucsum/5

impresult$meanAccuracy <- rowMeans(as.matrix(impresult[, c(2, 4, 6, 8, 10)], na.rm = FALSE, dims = 1))
impresult$meanGini <- rowMeans(as.matrix(impresult[, c(3, 5, 7, 9, 11)], na.rm = FALSE, dims = 1))
impresult <- impresult[order(impresult$meanAccuracy, decreasing = T), ]
a <- impresult
rownames(a) <- a[, 1]

# plot variable importance
ggplot(data = a, mapping = aes(x = reorder(row.names(a), meanAccuracy), y = meanAccuracy)) + 
  geom_bar(stat= 'identity') +              
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1), plot.margin = unit(c(1,1,1,1),"cm")) +
  xlab('variable') +
  ylab('Variable importance(Accuracy)')

# test on validation dataset
# final model
set.seed(1234)
data.rf <- train.data[, names(train.data) %in% c('antibiotic_flag') == F]
data.rf$infection <- as.factor(data.rf$infection)
rf <- randomForest(infection ~ .
                   , data = data.rf, ntree=420, proximity=TRUE,importance=TRUE) 

set.seed(1234)
valid.rf <- valid.data[, names(valid.data) %in% c('antibiotic_flag') == F]
valid.rf$infection <- as.factor(valid.rf$infection)

valid.rf$pred2 <- predict(rf, valid.rf, type = 'prob')
rocobj1 <- plot.roc(valid.rf$infection,
                    valid.rf$pred2[, 2],
                    percent=TRUE,ci=TRUE,col="#1c61b6")
rocobj1$auc
rocobj1$ci
# AUC on validate dataset was 69.09%(63.61%-74.57%)


############################
############################
##### secondary outcome#####
############################
############################

data <- read.csv('C:/Users/lenovo/Desktop/datathon4/data_final.csv')[, -8]
data$sex <- as.factor(data$sex)
data$antibiotic_flag <- as.factor(data$antibiotic_flag)
data$infection <- as.factor(data$infection)
data$baso <- as.numeric(data$baso)

# split data into training set and validation set
train.data <- data[sample(1436, 1077), ]
valid.data <- anti_join(data, train.data)

# use cross validation
# use 10-fold 
library(caret)
set.seed(1234)
data.rf <- train.data[, names(train.data) %in% c('infection') == F]
folds <- createFolds(y = data.rf$antibiotic_flag, k=5)
aucsum <- 0
impresult <- as.data.frame(colnames(data.rf))
colnames(impresult) <- 'var'
impresult$var <- as.character(impresult$var)
for (i in 1:5){
  fold.test <- data.rf[folds[[i]], ]
  fold.train <- data.rf[-folds[[i]], ]
  rf <- randomForest(antibiotic_flag ~ .
                     , data = fold.train, ntree=300, proximity=TRUE,importance=TRUE)  
  # importance(rf)
  a <- as.data.frame(importance(rf))[, -c(1, 2)]
  a$var <- rownames(a)
  impresult <- merge(impresult, a, by = 'var')
  # varImpPlot(rf, n.var = 20, main = 'Variable importance, Random Forest')
  fold.test$pred2 <- predict(rf, fold.test, type = 'prob')
  rocobj1 <- plot.roc(fold.test$antibiotic_flag,
                      fold.test$pred2[, 2],
                      percent=TRUE,ci=TRUE,col="#1c61b6"
                      #, print.auc=TRUE
  )
  
  pred3 <- predict(rf, fold.test, type = 'prob')
  z <- table(predict(rf, fold.test), fold.test$antibiotic_flag)
  q <- sum(diag(z))/sum(z)
  aucsum <- aucsum + rocobj1$auc
}
auc.rt <- aucsum/5

impresult$meanAccuracy <- rowMeans(as.matrix(impresult[, c(2, 4, 6, 8, 10)], na.rm = FALSE, dims = 1))
impresult$meanGini <- rowMeans(as.matrix(impresult[, c(3, 5, 7, 9, 11)], na.rm = FALSE, dims = 1))
impresult <- impresult[order(impresult$meanAccuracy, decreasing = T), ]
a <- impresult
rownames(a) <- a[, 1]

# plot variable importance
ggplot(data = a, mapping = aes(x = reorder(row.names(a), meanAccuracy), y = meanAccuracy)) + 
  geom_bar(stat= 'identity') +              
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1), plot.margin = unit(c(1,1,1,1),"cm")) +
  xlab('variable') +
  ylab('Variable importance(Accuracy)')

# test on validation dataset
# final model
set.seed(1234)
data.rf <- train.data[, names(train.data) %in% c('infection') == F]
data.rf$antibiotic_flag <- as.factor(data.rf$antibiotic_flag)
rf <- randomForest(antibiotic_flag ~ .
                   , data = data.rf, ntree=200, proximity=TRUE,importance=TRUE) 
valid.rf <- valid.data[, names(valid.data) %in% c('infection') == F]
valid.rf$antibiotic_flag <- as.factor(valid.rf$antibiotic_flag)

valid.rf$pred2 <- predict(rf, valid.rf, type = 'prob')
rocobj1 <- plot.roc(valid.rf$antibiotic_flag,
                    valid.rf$pred2[, 2],
                    percent=TRUE,ci=TRUE,col="#1c61b6")
rocobj1$auc
rocobj1$ci
# AUC on validate dataset was 68.48%(53.67%-83.29%)