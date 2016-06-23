DF=read.csv('~/Desktop/ACPMission/TrimmedUlti++.csv')
DF=na.omit(DF)
VarList =  read.csv("~/Desktop/ACPMission/VARIMP.csv")
options(stringsAsFactors = FALSE)
Features =  VarList[1:12,2]
Features = factor(Features)
Features = as.list(levels(Features))
DF.actifs = DF[,colnames(DF) %in% Features]
DF.illus = DF[,"Fertilizer.consumption..kilograms.per.hectare.of.arable.land."]
library(pls)
library(s20x)
DF.actifs=scale(DF.actifs)
DF.illus=scale(DF.illus)
pairs20x(DF.actifs,cex.labels = 0.68)
DF.cor=cor(DF.actifs)
write.csv(cor(DF.actifs),'~/Desktop/DF.cor.csv')
#library(corrplot)
#corrplot(DF.cor,order="hclust",hclust.method="complete")
heatmap(DF.cor)
eigenDF = eigen(DF.cor)
attributes(eigenDF)
eigenDF$values
sum(eigenDF$values)
sum(eigenDF$values[1:4]/12)
sum(eigenDF$values[1:5]/12)
z1 = scale(DF.actifs)%*%eigenDF$vectors[,1]
z2 = scale(DF.actifs)%*%eigenDF$vectors[,2]
z3 = scale(DF.actifs)%*%eigenDF$vectors[,3]
z4 = scale(DF.actifs)%*%eigenDF$vectors[,4]

var(cbind(z1,z2,z3,z4))
cor(cbind(z1,z2,z3,z4))

DF_PC=data.frame(DF.illus,z1,z2,z3,z4)
pairs20x(DF_PC)

DF.pcr = lm(DF.illus~.,data = DF_PC)
summary(DF.pcr)

val.propres <- eigenDF$values
print(val.propres)
#scree plot (graphique des éboulis des valeurs propres)
plot(1:12,val.propres,type="b",ylab="Valeurs propres",xlab="Composante",main="Scree plot")
#intervalle de confiance des val.propres à 95% 
val.basse <- val.propres * exp(-1.96 * sqrt(2.0/(n-1)))
val.haute <- val.propres * exp(+1.96 * sqrt(2.0/(n-1)))
#affichage sous forme de tableau
tableau <- cbind(val.basse,val.propres,val.haute)
colnames(tableau) <- c("B.Inf.","Val.","B.Sup")
print(tableau,digits=3)

#**** corrélation variables-facteurs ****
c1 <- acp.df$loadings[,1]*val.propres[1]
c2 <- acp.df$loadings[,2]*val.propres[2]
c3 <- acp.df$loadings[,3]*val.propres[3]
c4 <- acp.df$loadings[,4]*val.propres[4]
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

#------
plot(acp.df$scores[,1],acp.df$scores[,2],type="n",xlab="Comp.1 -
     %",ylab="Comp.2 - %")
abline(h=0,v=0)
text(acp.df$scores[,1],acp.df$scores[,2],labels=DF$Country.Name,cex=0.75)
#------
index = sample(n,0.1*n,replace=FALSE)
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









pairs.plus <<- function(dat, max.ncat=8, jitter=.3, extra=.1, 
                        lims=NULL, cex=0.8, pch=16, col="black", gap=0, ...) {
  # Turn factors into numeric:
  for(j in 1:ncol(dat)) if(is.factor(dat[,j])) dat[,j] <- as.numeric(dat[,j])
  # Jitter:
  for(i in 1:ncol(dat)) {
    x <- dat[,i];  xvals <- unique(x);  xvals <- xvals[!is.na(xvals)]
    if(length(xvals) < max.ncat)
    { space <- min(diff(sort(xvals)))
    dat[,i] <- x + runif(length(x), -space*jitter, space*jitter) }
  }
  # Add extra space around the points by adding two points that are not drawn:
  if(is.null(lims)) {
    mins <- apply(dat, 2, min, na.rm=T)
    maxs <- apply(dat, 2, max, na.rm=T);  ranges <- maxs-mins
    dat <- rbind(mins-extra*ranges, maxs+extra*ranges, dat)  
  } else {
    dat <- rbind(lims[1], lims[2], dat)  
  }
  # Handle addition of two points in col, cex, pch:
  col <- c(rep(par()$bg,2), rep(col,len=nrow(dat)-2))
  pch <- c(rep(1,2), rep(pch,len=nrow(dat)-2))
  # Finally:
  pairs(dat, cex=cex, pch=pch, col=col, gap=gap, ...)
}