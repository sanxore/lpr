DF = read.csv('~/Desktop/OCP/BackUPS/Final_Database.csv')
library(ggplot2)
DF.NC = DF[which(DF$Cumulated.Not.Cumulated == 'Not Cumulated'),]
summary(DF.NC$kT)
DF.NC.TR = DF.NC[which(DF.NC$kT > 0),]
attach(DF.NC.TR)
DF.NC.TR = head(order(DF.NC.TR,kT),n=floor(0.8*length(DF.NC.TR$kT)))
DF.NC.TR$logkT = log(DF.NC.TR$kT)
Client_Index = which(DF.NC.TR$Exporting.countries=="Morocco")
DF.NC.TR$Client_OCP="non"
DF.NC.TR$Client_OCP[Client_Index]="oui"
attach(DF.NC.TR)
boxplot(logkT ~ Product, data =DF.NC.TR, col = "blue")
boxplot(logkT ~ Product, data =DF.NC.TR[Client_Index,], col = "blue")
qplot(logkT,data=DF.NC.TR,fill=Product)
qplot(logkT,data=DF.NC.TR[Client_Index,],fill=Product)
qplot(logkT,data=DF.NC.TR,color=Product,geom="density")
qplot(logkT,data=DF.NC.TR[Client_Index,],color=Product,geom="density")
with(DF.NC.TR,qplot(logkT,Region..OCP.,col=Product))
with(DF.NC.TR[Client_Index,],qplot(logkT,Region..OCP.,col=Product))
qplot(Region..OCP.,data=DF.NC.TR,fill=Product)
qplot(Region..OCP.,data=DF.NC.TR[Client_Index,],fill=Product)
qplot(logkT,data=DF.NC.TR,facets = .~Product)
qplot(logkT,data=DF.NC.TR[Client_Index,],facets = .~Product)
qplot(Quarter,logkT, data = DF.NC.TR, facets = .~Product,col=Region..OCP.)
qplot(Quarter,logkT, data = DF.NC.TR[Client_Index,], facets = .~Product,col=Region..OCP.)
DF.NC[which(DF.NC$Product == "Rock" && DF.NC$Quarter == "Q3"),]
qplot(Quarter,logkT, data = DF.NC.TR, facets = Product~Region..OCP.,col=Client_OCP)
qplot(Quarter,logkT, data = DF.NC.TR, facets = Product~Region..OCP.,col=Exporting.countries)
