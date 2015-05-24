library(shiny)
library(methods)

library(pipelinehelpers)

args <- command_args_unless_interactive(c("residuals", "working/models/rf/test_predictions.csv working/models/lm/test_predictions.csv"))
app_to_run <- args[1]
args <- args[-1]
cat(sprintf("Starting app %s\n", app_to_run))
runApp(file.path("src", "apps", app_to_run), launch.browser=TRUE)