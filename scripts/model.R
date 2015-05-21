library(readr)
library(randomForest)
source("src/arg_helpers.R")
source("src/process_features.R")
source("src/source_eval.R")
source("src/models.R")

set.seed(0)

args <- command_args_unless_interactive(c("input/train.csv", "input/test.csv", "rf_2_trees", "working/rf_2_trees/test_predictions.csv"))

print("args is:")
print(args)

train <- read_csv(args[1])
test <- read_csv(args[2])
model_name <- args[3]
output_file <- ensure_parent_directory_exists(args[4])

model <- source_eval("src/models.R", models[[model_name]])

# process features
train <- process_features(train)
test <- process_features(test)


# fit model
feature_names <- c("SaleDate", "YearMade", "HorsePower", "ProductGroupDesc")

fitted <- model$fit(train, "SalePrice", feature_names)
  
# make predictions
test$Predicted <- model$predict(fitted, test)

write.csv(test, output_file, row.names=FALSE)
