library(readr)
library(ggplot2)
library(scales)
library(pipelinehelpers)
source("src/theme.R")

args <- command_args()
stop("Not ready to run!")







# actual_predicted_plot <- ggplot(predictions) + 
#   geom_point(aes(x=SalePrice, y=Predicted), alpha=.03) +
#   ggtitle("Actual vs. Predicted Sale Price") +
#   xlab("Actual Sale Price ($)") +
#   ylab("Predicted Sale Price ($)") +
#   scale_y_continuous(labels = comma, limits=range(test$SalePrice)) +
#   scale_x_continuous(labels = comma, limits=range(test$SalePrice)) +
#   coord_fixed()
# 
# ggsave(filename = output_file, plot = actual_predicted_plot)


# source("src/metrics.R")
# mae_string <- comma_format(digits=0)(mae$Evaluate(predictions$SalePrice, predictions$Predicted))
# 
# actual_predicted_plot <- 
#   ggplot(predictions) + 
#   geom_point(aes(x=SalePrice, y=Predicted), alpha=.01) +
#   ggtitle(sprintf("Actual vs. Predicted Sale Price\nMAE: $%s", mae_string)) +
#   xlab("Actual Sale Price ($)") +
#   ylab("Predicted Sale Price ($)") +
#   scale_y_continuous(labels = comma, limits=range(predictions$SalePrice)) +
#   scale_x_continuous(labels = comma, limits=range(predictions$SalePrice)) +
#   coord_fixed()
