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

ggplot(DF.NC.TR,
       aes(x = Product, y = logkT)) + 
  geom_jitter(alpha = 0.4) + 
  geom_boxplot(color = "yellow", outlier.colour = "Red",fill=NA) + ylab("Transformée logarithmique des volumes échangés à l'international") + xlab("Produits phosphatés dérivés")

ggplot(DF.NC.TR[OCP_Index,],
       aes(x = Product, y = logkT)) + 
  geom_jitter(alpha = 0.4) + 
  geom_boxplot(color = "yellow", outlier.colour = "Red",fill=NA)+ ylab ("Transformée logarithmiques des volumes exportés par le Maroc") + xlab("Produits phosphatés dérivés")

#--------------------------------------------
qplot(logkT,data=DF.NC.TR,fill=Product,bins=45,ylab="Nombre des échanges internationaux par produit",xlab="Transformée logartihmique des volumes échangés")
qplot(logkT,data=DF.NC.TR,color=Product,geom="density",ylab="Distribution des échanges internationaux par produit",xlab="Transformée logartihmique des volumes échangés")

qplot(logkT,data=DF.NC.TR,fill=Big_Players,bins=45,ylab="Nombre d'échanges internationaux par exportateur majeur",xlab="Transformée logartihmique des volumes échangés")
qplot(logkT,data=DF.NC.TR,color=Big_Players,geom="density",ylab="Distribution des échanges internationaux par exportateur majeur",xlab="Transformée logartihmique des volumes échangés")

qplot(logkT,data=DF.NC.TR[OCP_Index,],color=Product,geom="density",ylab="Distribution des exports marocains par produit",xlab="Transformée logartihmique des volumes échangés")

qplot(logkT,data=DF.NC.TR,facets = .~Product,xlim = c(0,7.5),ylim=c(0,160))
qplot(logkT,data=DF.NC.TR[OCP_Index,],facets = .~Product,xlim = c(0,7.5),bins=15,ylim=c(0,50))


#--------------------------------------------
qplot(Quarter,logkT, data = DF.NC.TR, facets = Product~Region..OCP.,alpha = I(0.1))
qplot(Quarter,logkT, data = DF.NC.TR, facets = Product~Region..OCP.,col=Big_Players,alpha = I(0.7))

#--------------------------------------------
with(DF.NC.TR,qplot(logkT,Region..OCP.,col=Product,alpha = I(0.7)))
with(DF.NC.TR[OCP_Index,],qplot(logkT,Region..OCP.,col=Product),alpha = I(0.6))
#--------------------------------------------

multiplot(plot_cons_trim_region("DAP"),plot_cons_trim_region("MAP"),plot_cons_trim_region("PA"),plot_cons_trim_region("TSP"))


#---------------------------------------------


qplot(Quarter,logkT, data = DF.NC.TR, facets = .~Product,col=Region..OCP.)
qplot(Quarter,logkT, data = DF.NC.TR[OCP_Index,], facets = .~Product,col=Region..OCP.)

#--------------------------------------------------
#--------------------------------------------------


#--------------------------------------------------
#--------------------------------------------------

plot_cons_trim_region = function(produit){
  MAP.CD=DF.NC.TR[which(DF.NC.TR$Product==produit),c(4,8,14)]
  MAP.SM = group_by(MAP.CD,Region..OCP.)
  MAP.SM$Region_Quarter = paste(MAP.SM$Region..OCP.,MAP.SM$Quarter,sep="_")
  MAP.SM$Quarter=as.numeric(as.factor(MAP.SM$Quarter))
  MAP.SM = MAP.SM[,-1]
  MAP.SM = MAP.SM[,-1]
  by_Ind = group_by(MAP.SM,Region_Quarter)
  MAP.FN=summarise(by_Ind,ML = sum(logkT))
  library(stringr)
  MAP.FN$Time = as.numeric(str_sub(MAP.FN$Region_Quarter,-1,-1))
  MAP.FN$Region=matrix(unlist(strsplit(MAP.FN$Region_Quarter,"_")),ncol=2,byrow=TRUE)[,1]
  MAP.FN=MAP.FN[,-1]
  titre=paste("Courbe des consomations trimestrielles ",paste(produit," par région du Monde"))
  return(ggplot(MAP.FN, aes(x=Time, y=ML, colour=Region, group=Region)) + geom_line() + ggtitle(titre))
}

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}