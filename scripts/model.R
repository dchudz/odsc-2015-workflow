library(readr)
library(randomForest)
library(ggplot2)
library(scales)
source("src/metrics.R")
source("src/theme.R")
source("src/arg_helpers.R")
source("src/process_features.R")

args <- command_args()

output_file <- args[1]
train <- read_csv(args[2])
test <- read_csv(args[3])

# process features
train <- process_features(train)
test <- process_features(test)

# fit model
feature_names <- c("saledate", "YearMade", "HorsePower", "ProductGroupDesc")
rf <- randomForest(train[feature_names], train$SalePrice, ntree=10)

# make predictions
test$Predicted <- predict(rf, test[feature_names])

actual_predicted_plot <- ggplot(test) + 
  geom_point(aes(x=SalePrice, y=Predicted), alpha=.03) +
  ggtitle("Actual vs. Predicted Sale Price") +
  xlab("Actual Sale Price ($)") +
  ylab("Predicted Sale Price ($)") +
  scale_y_continuous(labels = comma, limits=range(test$SalePrice)) +
  scale_x_continuous(labels = comma, limits=range(test$SalePrice)) +
  coord_fixed()

print(output_file)
ggsave(filename = output_file, plot = actual_predicted_plot)
