library(readr)
library(randomForest)
library(ggplot2)
library(scales)
source("src/metrics.R")
source("src/theme.R")

train <- read_csv("working/train_test_split/train.csv")
test <- read_csv("working/train_test_split/test.csv")

train <- process_features(train)
test <- process_features(test)

feature_names <- c("saledate", "YearMade", "HorsePower", "ProductGroupDesc")
rf <- randomForest(train[feature_names], train$SalePrice, ntree=10)

test$Predicted <- predict(rf, test[feature_names])
test_mae <- mae$Evaluate(test$SalePrice, test$Predicted)

ggplot(test) + 
  geom_point(aes(x=SalePrice, y=Predicted), alpha=.03) +
  ggtitle(sprintf("Test Set MAE: %s", comma_format(digits=3)(test_mae))) +
  xlab("Actual Sale Price ($)") +
  ylab("Predicted Sale Price ($)") +
  scale_y_continuous(labels = comma, limits=range(test$SalePrice)) +
  scale_x_continuous(labels = comma, limits=range(test$SalePrice)) +
  coord_fixed()



