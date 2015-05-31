# Helpers:

weighted_mean <- function(x, weight) {
  sum(x*weight)/sum(weight)
}

weighted_covariance <- function(x,y,w=NULL) {
  if(is.null(w)) {    
    w <- rep.int(1.0, length(x))
  }
  sum(w*(x-weighte_mean(x,w))*(y-weighte_mean(y,w)))/sum(w)
}

# Metrics: metrics should be a function of (actual, predicted, weight)
mae <- list(
  ShortName = "MAE",
  LongName = "Mean Absolute Error",
  SmallerIsBetter = TRUE,
  Evaluate = function(actual, prediction, weight=rep.int(1.0,length(prediction))){
    deviation <- prediction - actual
    return(weighted_mean(abs(deviation),weight))
  }
)

mape <- list(
  ShortName = "MAPE",
  LongName = "Mean Absolute Percentage Error",
  SmallerIsBetter = TRUE,
  Evaluate = function(actual, prediction, weight=rep.int(1.0,length(prediction))){
    percentageDeviation <- (prediction - actual)/actual
    percentageDeviation <- ifelse(is.infinite(percentageDeviation), NA, percentageDeviation)
    return(weighted_mean(abs(percentageDeviation),weight))
  }
)

medape <- list(
  ShortName = "MAPE",
  LongName = "Mean Absolute Percentage Error",
  SmallerIsBetter = TRUE,
  Evaluate = function(actual, prediction, weight=rep.int(1.0,length(prediction))){
    percentageDeviation <- (prediction - actual)/actual
    percentageDeviation <- ifelse(is.infinite(percentageDeviation), NA, percentageDeviation)
    return(median(abs(percentageDeviation)))
  }
)

Rmse <- list(
  ShortName = "RMSE",
  LongName = "Root Mean Squared Error",
  SmallerIsBetter = TRUE,
  Evaluate = function(actual, prediction, weight=rep.int(1.0,length(prediction))){
    deviation <- prediction - actual
    return(sqrt(weighted_mean(deviation**2,weight)))
  }
)

# Weighted correlation
pearson <- list(
  ShortName = "pearson",
  LongName = "pearson Correlation",
  SmallerIsBetter = FALSE,
  Evaluate = function(actual,prediction,weight=rep.int(1.0, length(actual))) {
    return(CovW(actual,prediction,weight) /
             sqrt(CovW(actual,actual,weight)*
                    CovW(prediction,prediction,weight)))
  }
)

# Weighted  rank correlation
spearman <- list(
  ShortName = "Spearman",
  LongName = "Spearman Rank Correlation",
  SmallerIsBetter = FALSE,
  Evaluate = function(actual,prediction,weight=rep.int(1.0, length(actual))) {
    return(pearson$Evaluate(rank(actual), rank(prediction), weight))
  }
)