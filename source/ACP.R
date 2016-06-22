DF=read.csv('~/Desktop/ACPMission/TrimmedUlti++.csv')
DF=na.omit(DF)
VarList =  read.csv("~/Desktop/ACPMission/VARIMP.csv")
options(stringsAsFactors = FALSE)
Features =  VarList[1:12,2]
Features = factor(Features)
Features = as.list(levels(Features))
DF.actifs = DF[,colnames(DF) %in% Features]
DF.illus = DF[,"Fertilizer.consumption..kilograms.per.hectare.of.arable.land."]
DF.actifs$Fertilizer.consumption..kilograms.per.hectare.of.arable.land.=DF.illus
n <- nrow(DF.actifs)
#centrage et réduction des données --> cor = T
#calcul des coordonnées factorielles --> scores = T
acp.df = princomp(DF.actifs, cor = T, scores = T)
#print
print(acp.df)
#summary
print(summary(acp.df))
#quelles les propriétés associées à l'objet ?
print(attributes(acp.df))
#obtenir les variances associées aux axes c.-à-d. les valeurs propres
val.propres <- acp.df$sdev^2
print(val.propres)
#scree plot (graphique des éboulis des valeurs propres)
plot(1:13,val.propres,type="b",ylab="Valeurs
     propres",xlab="Composante",main="Scree plot")
#intervalle de confiance des val.propres à 95% 
val.basse <- val.propres * exp(-1.96 * sqrt(2.0/(n-1)))
val.haute <- val.propres * exp(+1.96 * sqrt(2.0/(n-1)))
#affichage sous forme de tableau
tableau <- cbind(val.basse,val.propres,val.haute)
colnames(tableau) <- c("B.Inf.","Val.","B.Sup")
print(tableau,digits=3)

#**** corrélation variables-facteurs ****
c1 <- acp.df$loadings[,1]*acp.df$sdev[1]
c2 <- acp.df$loadings[,2]*acp.df$sdev[2]
c3 <- acp.df$loadings[,3]*acp.df$sdev[3]
c4 <- acp.df$loadings[,4]*acp.df$sdev[4]
#affichage
correlation <- cbind(c1,c2,c3,c4)
print(correlation,digits=2)
#carrés de la corrélation (cosinus²)
print(correlation^2,digits=2)
#cumul carrés de la corrélation
print(t(apply(correlation^2,1,cumsum)),digits=2)
#*** cercle des corrélations - variables actives ***
plot(c1,c2,xlim=c(-1,+1),ylim=c(-1,+1),type="n")
abline(h=0,v=0)
text(c1,c2,labels=colnames(DF.actifs),cex=0.5)
symbols(0,0,circles=1,inches=F,add=T)

#***carte des individus***
#l'option "scores" demandé dans princomp est très important ici
index = sample(length(acp.df$scores[,1]),length(acp.df$scores[,1])/50,replace=FALSE)
#------
plot(acp.df$scores[,1],acp.df$scores[,2],type="n",xlab="Comp.1 -
     %",ylab="Comp.2 - %")
abline(h=0,v=0)
text(acp.df$scores[,1],acp.df$scores[,2],labels=DF$Country.Name,cex=0.75)
#------
plot(acp.df$scores[index,1],acp.df$scores[index,2],type="n",xlab="Comp.1 -
     %",ylab="Comp.2 - %")
abline(h=0,v=0)
text(acp.df$scores[,1],acp.df$scores[,2],labels=DF$Country.Name,cex=0.75)




#*** représentation simultanée : individus x variables
#*****************************************************
biplot(acp.df,cex=0.75)

#que faut-il penser de la consommation ?
#*******************************************
#corrélation de la consommation avec le premier axe
ma_cor_1 <- function(x){return(cor(x,acp.df$scores[,1]))}
s1 =ma_cor_1(DF.illus)
#corrélation de la consommation avec le second axe
ma_cor_2 <- function(x){return(cor(x,acp.df$scores[,2]))}
s2 =ma_cor_2(DF.illus)
#position sur le cercle
plot(s1,s2,xlim=c(-1,+1),ylim=c(-1,+1),type="p",col="Red",main="Variables
     illustratives",xlab="Comp.1",ylab="Comp.2")
abline(h=0,v=0)
text(s1,80*s2,labels="Consommation fertilisants par Hectare Arable",cex=0.75)
symbols(0,0,circles=1,inches=F,add=T)
#représentation simultanée (avec les variables actives)
plot(c(c1,s1),c(c2,s2),xlim=c(-1,+1),ylim=c(-1,+1),type="p",main="Variables
     illustratives",xlab="Comp.1",ylab="Comp.2")
text(1.1*c1,1.1*c2,labels=colnames(DF.actifs),cex=0.75)
text(s1,80*s2,labels="Consommation fertilisants par Hectare Arable",cex=0.75,col="red")
abline(h=0,v=0)
symbols(0,0,circles=1,inches=F,add=T)