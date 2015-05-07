library(readr)

train <- read_csv("working/train_test_split//train.csv")
test <- read_csv("working/train_test_split//test.csv")

nrow(train)

library(ggplot2)
library(dplyr)
train$saledate <- as.Date(train$saledate, "%m/%d/%Y")
train$saledate <- as.double(train$saledate)
train$ProductGroupDesc <- as.factor(train$ProductGroupDesc)


library(randomForest)

feature_names <- c("saledate", "YearMade", "HorsePower", "ProductGroupDesc")

install.packages("xgboost")
library(xgboost)
print("training xgboost with sparseMatrix")
bst <- xgboost(data = train[feature_names], label = train$saledate, max.depth = 2, eta = 1, nround = 2, nthread = 2)

rf <- randomForest(train[feature_names], train$SalePrice, ntree=10)
?randomForest


summary(train[feature_names])
summary(train$SalePrice)

qplot(train$ProductGroupDesc)

train$SalePrice %>% qplot

?as.Date
