DF = read.csv('~/Desktop/OCP/BackUPS/Final_Database.csv')
DF.NC = DF[which(DF$Cumulated.Not.Cumulated == 'Not Cumulated'),]
summary(DF.NC$kT)
DF.NC.TR = DF.NC[which(DF.NC$kT > 0),]
DF.NC.TR = head(order(DF.NC.TR,kT),n=floor(0.8*length(DF.NC.TR$kT)))
DF.NC.TR$logkT = log(DF.NC.TR$kT)
boxplot(logkT ~ Product, data =DF.NC.TR, col = "blue")
qplot(logkT,data=DF.NC.TR,fill=Product)
qplot(logkT,data=DF.NC.TR,color=Product,geom="density")
with(DF.NC.TR,qplot(logkT,Region..OCP.,col=Product))
qplot(Region..OCP.,data=DF.NC.TR,fill=Product)
qplot(logkT,data=DF.NC.TR,facets = .~Product)