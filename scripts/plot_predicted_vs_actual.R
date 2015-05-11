library(readr)
library(ggplot2)
library(scales)
source("src/theme.R")
source("src/arg_helpers.R")
source("src/metrics.R")

args <- command_args_unless_interactive(c("working/test_predictions.csv", "working/predicted_vs_actual.png"))

predictions_file <- args[1]
output_plot <- args[2]

predictions <- read_csv(predictions_file)
mae_string <- comma_format(digits=0)(mae$Evaluate(predictions$SalePrice, predictions$Predicted))

actual_predicted_plot <- 
  ggplot(predictions) + 
  geom_point(aes(x=SalePrice, y=Predicted), alpha=.01) +
  ggtitle(sprintf("Actual vs. Predicted Sale Price\nMAE: $%s", mae_string)) +
  xlab("Actual Sale Price ($)") +
  ylab("Predicted Sale Price ($)") +
  scale_y_continuous(labels = comma, limits=range(predictions$SalePrice)) +
  scale_x_continuous(labels = comma, limits=range(predictions$SalePrice)) +
  coord_fixed()

ggsave(filename = output_plot, plot = actual_predicted_plot)
 