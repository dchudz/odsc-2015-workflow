library(readr)
library(ggplot2)
library(scales)
source("src/theme.R")
source("src/arg_helpers.R")

args <- command_args()
stop("Not ready to run!")







# actual_predicted_plot <- ggplot(test) + 
#   geom_point(aes(x=SalePrice, y=Predicted), alpha=.03) +
#   ggtitle("Actual vs. Predicted Sale Price") +
#   xlab("Actual Sale Price ($)") +
#   ylab("Predicted Sale Price ($)") +
#   scale_y_continuous(labels = comma, limits=range(test$SalePrice)) +
#   scale_x_continuous(labels = comma, limits=range(test$SalePrice)) +
#   coord_fixed()
# 
# ggsave(filename = output_file, plot = actual_predicted_plot)
