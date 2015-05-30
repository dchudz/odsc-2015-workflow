library(ggplot2)
library(magrittr)
library(readr)

library(pipelinehelpers)

source("src/metrics.R")
source("src/theme.R")
 
args <- command_args_unless_interactive(c("working/models/rf/test_predictions.csv working/models/lm/test_predictions.csv", 
                                          "working/models/model_performance.png"))

prediction_paths <- pipeline_input_file_vector(args[1])
output_plot <- pipeline_output_file(args[2])

performance_df <- data.frame(PredictionPath = prediction_paths, ModelName = prediction_paths %>% dirname %>% basename)

performance_df$MAE <- 
  prediction_paths %>% 
  Map(read_csv, .) %>%
  Map(function(prediction_df) mae$Evaluate(prediction_df$SalePrice, prediction_df$Predicted), .) %>%
  unlist

performance_plot <- ggplot(performance_df) + 
  geom_bar(aes(x=ModelName, fill=ModelName, y=MAE), stat="identity") +
  ggtitle("Test Set Model Performance")
ggsave(filename = output_plot, plot = performance_plot)
