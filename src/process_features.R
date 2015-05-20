process_features <- function(df) {
  df$SaleDate <- as.Date(df$saledate, "%m/%d/%Y")
  df$SaleDate <- as.double(df$saledate)
  df$ProductGroupDesc <- as.factor(df$ProductGroupDesc)
  df$SaleMonth <- month(df$SaleDate)
  return(df)
}