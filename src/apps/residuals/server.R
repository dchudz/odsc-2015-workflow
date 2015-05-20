setwd("../../..")

library(ggplot2)
library(dplyr)
library(readr)
source("src/arg_helpers.R")
source("src/theme.R")


prediction_paths <- pipeline_input_file_vector(args[1])
output_plot <- pipeline_output_file(args[2])

predictions_key <- data_frame(Path = prediction_paths, ModelName = prediction_paths %>% dirname %>% basename)
print(predictions_key)

read_path_and_add_path_column <- function(path) {
	df <- read_csv(path)
	df$Path <- path
	return(df)
}

predictions_list <- Map(read_path_and_add_path_column, predictions_key$Path)
predictions <- rbind_all(predictions_list) %>% inner_join(predictions_key, by = "Path")
print(table(predictions$ModelName))

shinyServer(function(input, output) {
	
	output$feature_selection <- renderUI({
		feature_names <- names(predictions)
		stopifnot(length(feature_names) > 0)
		selectInput("feature_name", "Choose Feature:", feature_names)
	})
	
	output$model_selection <- renderUI({
		model_names <- unique(predictions$ModelName)
		stopifnot(length(model_names) > 0)
		checkboxGroupInput("model_names", "Choose Models:", model_names, selected = model_names)		
# 		selectInput("model_name", "Choose Model:", model_names)
	})
	
	
	output$main_plot <- renderPlot({
		
		print(nrow(predictions))
		if (input$should_sample) {
			predictions <- subset(predictions, runif(nrow(predictions)) < .01)
			print("sampled")
		}
		print(nrow(predictions))
		predictions <- subset(predictions, ModelName %in% input$model_names)
		predictions$Residual <- predictions$Predicted - predictions$SalePrice
		feature_name <- input$feature_name
		if (class(predictions[[feature_name]]) %in% c("character", "factor")) {
			sorted_levels <- predictions[[feature_name]] %>% table %>% sort %>% rev %>% names
			print(sorted_levels)
			predictions[[feature_name]] <- factor(predictions[[feature_name]], levels = sorted_levels)
			
			elements_that_depend_on_class <- list(
				theme(axis.text.x = element_text(angle = 90, hjust = 1)),
				violin <- geom_violin(aes_string(x=input$feature_name, y="Residual"))
			)
		} else {
			elements_that_depend_on_class  <- list()
		}
		
		ggplot(predictions) + 
			elements_that_depend_on_class +
			geom_point(aes_string(x=feature_name, y="Residual"), alpha=.1, color = "blue") +
			facet_grid(ModelName ~ .)
		
	
	})
})