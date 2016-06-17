DF = read.csv('~/Desktop/OCP/BackUPS/Final_Database.csv')
library(ggplot2)
DF.NC = DF[which(DF$Cumulated.Not.Cumulated == 'Not Cumulated'),]
DF.NC = DF[which(DF$AGG.DET.ANN == 'DET'),]
DF.NC = DF[which(DF$P2O5.Product == 'Product'),]
summary(DF.NC$kT)
DF.NC.TR = DF.NC[which(DF.NC$kT > 0),]
attach(DF.NC.TR)
#DF.NC.TR = head(order(DF.NC.TR,kT),n=floor(0.8*length(DF.NC.TR$kT)))
DF.NC.TR$logkT = log(DF.NC.TR$kT)
OCP_Index = which(DF.NC.TR$Exporting.countries=="Morocco")
USA_Index = which(DF.NC.TR$Exporting.countries=="USA")
China_Index = which(DF.NC.TR$Exporting.countries=="China")
Russia_Index = which(DF.NC.TR$Exporting.countries=="Russia")
DF.NC.TR$Big_Players="Non"
DF.NC.TR$Big_Players[USA_Index]="USA"
DF.NC.TR$Big_Players[China_Index]="China"
DF.NC.TR$Big_Players[OCP_Index]="Morocco"
DF.NC.TR$Big_Players[Russia_Index]="Russia"
attach(DF.NC.TR)


boxplot(logkT ~ Product, data =DF.NC.TR, col = "blue")
boxplot(logkT ~ Product, data =DF.NC.TR[OCP_Index,], col = "blue")
#--------------------------------------------
qplot(logkT,data=DF.NC.TR,fill=Product)
qplot(logkT,data=DF.NC.TR,fill=Big_Players)
qplot(logkT,data=DF.NC.TR[OCP_Index,],fill=Product)

qplot(logkT,data=DF.NC.TR,fill=Big_Players,facets = .~Product)
qplot(logkT,data=DF.NC.TR[OCP_Index,],facets = .~Product,fill=Region..OCP.)

qplot(logkT,data=DF.NC.TR,color=Product,geom="density")
qplot(logkT,data=DF.NC.TR[OCP_Index,],color=Product,geom="density")
#--------------------------------------------
qplot(Quarter,logkT, data = DF.NC.TR, facets = Product~Region..OCP.)
qplot(Quarter,logkT, data = DF.NC.TR, facets = Product~Region..OCP.,col=Big_Players)

#--------------------------------------------
with(DF.NC.TR,qplot(logkT,Region..OCP.,col=Product))
with(DF.NC.TR[OCP_Index,],qplot(logkT,Region..OCP.,col=Product))


#qplot(Region..OCP.,data=DF.NC.TR,fill=Product)
#qplot(Region..OCP.,data=DF.NC.TR[OCP_Index,],fill=Product)

qplot(Quarter,logkT, data = DF.NC.TR, facets = .~Product,col=Region..OCP.)
qplot(Quarter,logkT, data = DF.NC.TR[OCP_Index,], facets = .~Product,col=Region..OCP.)


