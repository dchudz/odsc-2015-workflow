library(dplyr)
library(readr)
source("src/arg_helpers.R")

args <- command_args_unless_interactive(
  c("working/cleaned_input.csv", "input/Train.csv", "input/Machine_Appendix.csv"))

cleaned_input_file <- pipeline_output_file(args[1])
original_train_file <- pipeline_input_file(args[2])
machine_file <- pipeline_input_file(args[3])

original_train <- read_csv(original_train_file)
machine <- read_csv(machine_file)

cols_to_keep <- c("SalesID", "SalePrice", "MachineID", "datasource", "auctioneerID", "YearMade", "MachineHoursCurrentMeter", "UsageBand", "saledate", "ProductSize", "state")

selected_columns_and_joined <- original_train[cols_to_keep] %>% left_join(machine, by="MachineID")

selected_columns_and_joined_horsepower <- subset(selected_columns_and_joined, PrimarySizeBasis == "Horsepower")

selected_columns_and_joined_horsepower$HorsePower <- 
  (selected_columns_and_joined_horsepower$PrimaryLower + selected_columns_and_joined_horsepower$PrimaryUpper)/2

product_groups_to_keep <- selected_columns_and_joined_horsepower$ProductGroupDesc %>% table %>% Filter(function(x) x > 100, .) %>% names

selected_columns_and_joined_horsepower_prodgroups <- subset(selected_columns_and_joined_horsepower, ProductGroupDesc %in% product_groups_to_keep)

write_csv(selected_columns_and_joined_horsepower_prodgroups, cleaned_input_file)
