# install.packages("quantmod")

# paste code from datahub R tab
library(jsonlite)

json_file <- 'https://datahub.io/core/s-and-p-500-companies/datapackage.json'
json_data <- fromJSON(paste(readLines(json_file), collapse=""))

# get list of all resources:
print(json_data$resources$name)

for(i in 1:length(json_data$resources$datahub$type)){
  if(json_data$resources$datahub$type[i]=='derived/csv'){
    path_to_file = json_data$resources$path[i]
    data <- read.csv(url(path_to_file))
    print(data)
  }
}


# now data holds stock symbols for Fortune 500

# inspired by https://financetrain.com/lessons/downloading-stock-data-in-r-using-quantmod/
library(quantmod)

stocks_symbols <- data$Symbol
bad_symbols <- c("BRK.B", "BF.B", "VNT")
stocks_symbols <- stocks_symbols[!stocks_symbols %in% bad_symbols]
myStocks <-lapply(stocks_symbols, function(x) {
  getSymbols(x, from = "2020/09/27", to = "2021/02/23",
             periodicity = "daily", auto.assign=FALSE)} )
names(myStocks) <- stocks_symbols
head(myStocks$AAPL)

adjustedPrices <- lapply(myStocks, Ad)
adjustedPrices <- do.call(merge, adjustedPrices)
head(adjustedPrices)
dim(adjustedPrices)
sum(is.na(adjustedPrices))

norm_max_min <- function(x) {
  (x - min(x)) / (max(x) - min(x)) * 2 -1
}

adj_prices_normalized <- t(apply(adjustedPrices, 2, norm_max_min))
dim(adj_prices_normalized)
plot(adj_prices_normalized[1,])

write.csv(adj_prices_normalized, file = "fortune500_100_days.csv")
