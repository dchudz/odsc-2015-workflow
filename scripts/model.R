library(readr)
library(randomForest)
source("src/arg_helpers.R")
source("src/process_features.R")

args <- command_args_unless_interactive(c("input/train.csv", "input/test.csv", "working/test_predictions.csv"))

train <- read_csv(args[1])
test <- read_csv(args[2])
output_file <- args[3]

# process features
train <- process_features(train)
test <- process_features(test)

# fit model
feature_names <- c("saledate", "YearMade", "HorsePower", "ProductGroupDesc")
rf <- randomForest(train[feature_names], train$SalePrice, ntree=2, mtry=4)


# make predictions
test$Predicted <- predict(rf, test[feature_names])

write_csv(test[c("SalePrice", "Predicted", feature_names)], output_file)
