library(forecast)
brazil = read.csv("tardes_brazil.csv")
brazil.series = ts(brazil, start = 2007, frequency = 4)
load(file = "test.RData")
logcook = log(cook)
cook.series = ts(logcook, start=2007, frequency = 12)
ratio = mean(brazil.series)/mean(cook.series)
cook2 = ratio * cook.series
brazil.series = cook2

#errors hist plot function
plotForecastErrors <- function(forecasterrors) {
  # make a histogram of the forecast errors:
  mybinsize <- IQR(forecasterrors)/4
  mysd <- sd(forecasterrors)
  mymin <- min(forecasterrors) - mysd * 5
  mymax <- max(forecasterrors) + mysd * 3
  # generate normally distributed data with mean 0 and standard deviation
  # mysd
  mynorm <- rnorm(10000, mean = 0, sd = mysd)
  mymin2 <- min(mynorm)
  mymax2 <- max(mynorm)
  if (mymin2 < mymin) {
    mymin <- mymin2
  }
  if (mymax2 > mymax) {
    mymax <- mymax2
  }
  
  # make a red histogram of the forecast errors, with the normally
  mybins <- seq(mymin, mymax, mybinsize)
  hist(forecasterrors, col = "red", freq = FALSE, breaks = mybins)
  # freq=FALSE ensures the area under the histogram = 1 generate normally
  # distributed data with mean 0 and standard deviation mysd
  myhist <- hist(mynorm, plot = FALSE, breaks = mybins)
  # plot the normal curve as a blue line on top of the histogram of forecast
  # errors:
  points(myhist$mids, myhist$density, type = "l", col = "blue", lwd = 2)
}
#plot de la serie original
plot(brazil.series, ylab="demande en kilo-tonne")

# Etude tendance et saisonalite (decomposition)
brazil.series.comp = decompose(brazil.series)
plot(brazil.series.comp)

# Hlt-Winters forecast
brazil.series.hw = HoltWinters(log(brazil.series))
plot(brazil.series.hw)
brazil.series.hw
brazil.series.hw$SSE
pred = forecast.HoltWinters(brazil.series.hw, h=48)
plot.forecast(pred, ylab = "demande en kilo-tonne")

# Correlogramm
acf(pred$residuals, lag.max=20)

# test Ljung-Box
Box.test(pred$residuals, lag=20, type="Ljung-Box")

# Etude des erreur
plot.ts(pred$residuals) 
plotForecastErrors(pred$residuals) 
