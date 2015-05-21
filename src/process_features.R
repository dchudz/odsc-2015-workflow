library(lubridate)

process_features <- function(df) {
  df$SaleDate <- as.Date(df$saledate, "%m/%d/%Y")
  df$SaleMonth <- month(df$SaleDate)
  df$SaleDate <- as.double(df$SaleDate)
  df$ProductGroupDesc <- as.factor(df$ProductGroupDesc)
  return(df)
}