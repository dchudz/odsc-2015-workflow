library(dplyr)
library(readr)
library(pipelinehelpers)

args <- command_args_unless_interactive(
  c("working/cleaned_input.csv", "input/Train.csv", "input/Machine_Appendix.csv"))

cleaned_input_file <- pipeline_output_file(args[1])
original_train_file <- pipeline_input_file(args[2])
machine_file <- pipeline_input_file(args[3])

original_train <- read_csv(original_train_file)
machine <- read_csv(machine_file)

cols_to_keep <- c("SalesID", "SalePrice", "MachineID", "datasource", "auctioneerID", "YearMade", "MachineHoursCurrentMeter", "UsageBand", "saledate", "ProductSize", "state")

selected_columns_and_joined <- original_train[cols_to_keep] %>% left_join(machine, by="MachineID")

subset_to_keep <- subset(selected_columns_and_joined, PrimarySizeBasis == "Horsepower")

subset_to_keep$HorsePower <- (subset_to_keep$PrimaryLower + subset_to_keep$PrimaryUpper)/2

product_groups_to_keep <- subset_to_keep$ProductGroupDesc %>% table %>% Filter(function(x) x > 100, .) %>% names

subset_to_keep <- subset(subset_to_keep, ProductGroupDesc %in% product_groups_to_keep)
subset_to_keep <- subset(subset_to_keep, YearMade != 1000)

write_csv(subset_to_keep, cleaned_input_file)
