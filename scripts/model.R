library(readr)
library(randomForest)
source("src/arg_helpers.R")
source("src/process_features.R")

args <- command_args()

train <- read_csv(args[1])
test <- read_csv(args[2])
output_file <- args[3]

# process features
train <- process_features(train)
test <- process_features(test)

# fit model
feature_names <- c("saledate", "YearMade", "HorsePower", "ProductGroupDesc")
rf <- randomForest(train[feature_names], train$SalePrice, ntree=10)

# make predictions
test$Predicted <- predict(rf, test[feature_names])

write_csv(test[c("SalePrice", "Predicted", feature_names)], output_file)
