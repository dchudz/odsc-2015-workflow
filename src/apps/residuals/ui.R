shinyUI(bootstrapPage(
	
	inputPanel(htmlOutput("feature_selection"),
						 htmlOutput("model_selection"),
						 checkboxInput("should_sample", "Sample 5%?", value = TRUE)
	),

	plotOutput(outputId = "main_plot", height = "600px")
	
	
))