library(ggplot2)
library(dplyr)
library(readr)
source("src/arg_helpers.R")
source("src/metrics.R")
source("src/theme.R")

args <- command_args_unless_interactive(c("working/models/rf/test_predictions.csv working/models/lm/test_predictions.csv", 
                                          "working/models/model_performance.png"))


prediction_paths <- pipeline_input_file_vector(args[1])
output_plot <- pipeline_output_file(args[2])

predictions_key <- data_frame(Path = prediction_paths, ModelName = prediction_paths %>% dirname %>% basename)

read_path_and_add_path_column <- function(path) {
  df <- read_csv(path)
  df$Path <- path
  return(df)
}

predictions_list <- Map(read_path_and_add_path_column, predictions_key$Path)
predictions <- rbind_all(predictions_list) %>% inner_join(predictions_key, by = "Path")

qplot(predictions$MachineHoursCurrentMeter) + xlim(c(0,2e4))
ggplot(predictions, aes(x=MachineHoursCurrentMeter, y=Predicted-SalePrice)) + geom_point(alpha=.1) + facet_grid(ModelName ~ .) + xlim(c(0,2e4)) + geom_smooth()





ggplot(predictions) + geom_hex(aes(x=Predicted, y=Predicted-SalePrice)) + facet_grid(ModelName ~ .)

ggplot(predictions) + geom_bin2d(aes(x=Predicted, y=Predicted-SalePrice), bins=50, drop=FALSE) + facet_grid(ModelName ~ .)
  

ggplot(predictions) + geom_bin2d(aes(x=YearMade, y=Predicted-SalePrice), bins=50, drop=FALSE) + facet_grid(ModelName ~ .)


ggplot(predictions) + geom_violin(aes(x=UsageBand, y=Predicted-SalePrice)) + facet_grid(ModelName ~ .)

ggplot(predictions) + geom_point(aes(x=HorsePower, y=Predicted-SalePrice), alpha=.1) + facet_grid(ModelName ~ .)

ggplot(predictions) + geom_histogram(aes(x=HorsePower)) + facet_grid(ModelName ~ ProductGroupDesc)

ggplot(predictions) + geom_violin(aes(x=ProductGroupDesc, y=HorsePower)) + facet_grid(ModelName ~ .)
ggplot(predictions) + geom_boxplot(aes(x=ProductGroupDesc, y=HorsePower)) + facet_grid(ModelName ~ .)




?geom_hex
?stat_bin2d
