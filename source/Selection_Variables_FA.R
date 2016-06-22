DF = read.csv('~/Desktop/ACPMission/NormalizedUlti++.csv')
D2 = read.csv('~/Desktop/ACPMission/TrimmedUlti++.csv')
DF=DF[,-1]
DF=DF[,-c(1,3,6,7,10,12,20,21,23,24,26,27,28,29,30,35,36,40,41,43,45,46,47,48,49,50,51)]
D2=D2[,colnames(DF)]
library(randomForest)
library(mlbench)
library(caret)
control <- trainControl(method="repeatedcv", number=10, repeats=3)
metric="Rsquared"
mtry <- sqrt(ncol(DF))
tunegrid <- expand.grid(.mtry=mtry)
rf_default <- train(Fertilizer.consumption..kilograms.per.hectare.of.arable.land.~., data=DF, method="rf", metric=metric, tuneGrid=tunegrid, trControl=control)
print(rf_default)

# Random Search
control <- trainControl(method="repeatedcv", number=10, repeats=3, search="random")
mtry <- sqrt(ncol(DF))
rf_random <- train(Fertilizer.consumption..kilograms.per.hectare.of.arable.land.~., data=DF, method="rf", metric=metric, tuneLength=15, trControl=control)
print(rf_random)
plot(rf_random)
# Grid Search
control <- trainControl(method="repeatedcv", number=10, repeats=3, search="grid")
tunegrid <- expand.grid(.mtry=c(1:15))
rf_gridsearch <- train(Fertilizer.consumption..kilograms.per.hectare.of.arable.land.~., data=DF, method="rf", metric=metric, tuneGrid=tunegrid, trControl=control)
print(rf_gridsearch)
plot(rf_gridsearch)







library(data.table)  
library(h2o)
train = data.table(D2)
h2o.init(nthreads=-1,max_mem_size='6G')
trainHex<-as.h2o(train)
features<-colnames(train)[!(colnames(train) %in% c("Fertilizer.consumption..kilograms.per.hectare.of.arable.land."))]
rfHex <- h2o.randomForest(x=features,
                          y="Fertilizer.consumption..kilograms.per.hectare.of.arable.land.", 
                          ntrees = 50000,
                          mtries = -1,
                          training_frame=trainHex)





train.ind <- sample(nrow(D2), ceiling(nrow(D2))/2)
y.test <- D2$lpsa[-train.ind]; x.test <- x[-train.ind,]
y <- D2$lpsa[train.ind]; x <- x[train.ind,]
p <- length(covnames)
rss <- list()
for (i in 1:p) {
Index <- combn(p,i)
rss[[i]] <- apply(Index, 2, function(is) {
form <- as.formula(paste("y~", paste(covnames[is], collapse="+"), sep=""))
isfit <- lm(form, data=x)
yhat <- predict(isfit)
train.rss <- sum((y - yhat)^2)
yhat <- predict(isfit, newdata=x.test)
test.rss <- sum((y.test - yhat)^2)
c(train.rss, test.rss)
})
}
# set up plot with labels, title, and proper x and y limits
plot(1:p, 1:p, type="n", ylim=range(unlist(rss)), xlim=c(0,p),
xlab="Number of Predictors", ylab="Residual Sum of Squares",
main="")
for (i in 1:p) {
points(rep(i, ncol(rss[[i]])), rss[[i]][1, ], col="black", cex = 0.5)
points(rep(i, ncol(rss[[i]])), rss[[i]][2, ], col="red", cex = 0.5)
}
minrss <- sapply(rss, function(x) min(x[1,]))
lines((1:p), minrss, col="blue", lwd=1.7)
minrss <- sapply(rss, function(x) min(x[2,]))
lines((1:p), minrss, col="red", lwd=1.7)
legend("topright", c("Train", "Test"), col=c("blue", "red"), pch=1)


library(VSURF)
library(mlbench)
v22 = VSURF(formula = Fertilizer.consumption..kilograms.per.hectare.of.arable.land.~.,ntree = 15000,parallel = TRUE,ncores = 4,data=D2)
