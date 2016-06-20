DF = read.csv('~/Desktop/OCP/BackUPS/Final_Database.csv')
library(ggplot2)
DF.NC = DF[which(DF$Cumulated.Not.Cumulated == 'Not Cumulated'),]
DF.NC = DF.NC[which(DF.NC$AGG.DET.ANN == 'DET'),]
DF.NC = DF.NC[which(DF.NC$P2O5.Product == 'Product'),]
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

p1 = ggplot(DF.NC.TR,
       aes(x = Product, y = logkT)) + 
  geom_jitter(alpha = 0.7) + 
  theme(text = element_text(size=20),
        axis.text.x = element_text(angle=90, vjust=1)) +
  geom_boxplot(color = "Red", outlier.colour = "Orange",fill=NA) + ylab("Volumes échangés à l'international : log(kilotonnes)") + xlab("Produits phosphatés dérivés")

p2=ggplot(DF.NC.TR[OCP_Index,],
       aes(x = Product, y = logkT)) + 
  geom_jitter(alpha = 0.9) + 
  theme(text = element_text(size=20),
        axis.text.x = element_text(angle=90, vjust=1)) +
  geom_boxplot(color = "Red", outlier.colour = "Orange",fill=NA)+ ylab ("Volumes exportés par le Maroc : log(kilotonnes)") + xlab("Produits phosphatés dérivés")

#--------------------------------------------
qplot(logkT,data=DF.NC.TR,fill=Product,bins=45,ylab="Nombre des échanges internationaux par produit",xlab="Transformée logartihmique des volumes échangés") + theme(text = element_text(size=20),
                                                                                                                                                                    axis.text.x = element_text(angle=0, vjust=1))
qplot(logkT,data=DF.NC.TR,color=Product,geom="density",ylab="Distribution des échanges internationaux par produit",xlab="Transformée logartihmique des volumes échangés")  + theme(text = element_text(size=20),
                                                                                                                                                                                   axis.text.x = element_text(angle=0, vjust=1))

qplot(logkT,data=DF.NC.TR,fill=Big_Players,bins=45,ylab="Echanges internationaux par exportateur majeur",xlab="Transformée logartihmique des volumes échangés") + theme(text = element_text(size=20),
                                                                                                                                                                                 axis.text.x = element_text(angle=0, vjust=1))
qplot(logkT,data=DF.NC.TR,color=Big_Players,geom="density",ylab="Distribution des échanges par exportateur majeur",xlab="Transformée logartihmique des volumes échangés") + theme(text = element_text(size=20),
                                                                                                                                                                                                 axis.text.x = element_text(angle=0, vjust=1))

qplot(logkT,data=DF.NC.TR[OCP_Index,],color=Product,geom="density",ylab="Distribution des exports marocains par produit",xlab="Transformée logartihmique des volumes échangés") +  theme(text = element_text(size=20),
                                                                                                                                                                                       axis.text.x = element_text(angle=0, vjust=1))

qplot(logkT,data=DF.NC.TR,facets = .~Product,ylab="Echanges internationaux par produit",xlab="Volumes échangés :  log(kilotonnes)")  +  theme(text = element_text(size=20),
                                                                                                                                              axis.text.x = element_text(angle=0, vjust=1))
qplot(logkT,data=DF.NC.TR[OCP_Index,],facets = .~Product,ylab="Nombre des exports marocains par produit",xlab="Volumes échangés :  log(kilotonnes)")  +  theme(text = element_text(size=20),
                                                                                                                                                               axis.text.x = element_text(angle=0, vjust=1))


#--------------------------------------------
qplot(Quarter,logkT, data = DF.NC.TR, facets = Product~Region..OCP.,alpha = I(0.4),ylab="Volumes échangés = f(produit,région de destination)",xlab = "Trimestre des échanges") 

qplot(Quarter,logkT, data = DF.NC.TR, facets = Product~Region..OCP.,col=Big_Players,alpha = I(0.5),ylab="Volumes échangés = f(produit,Destination,Exportateur)",xlab = "Trimestre des échanges")  +  theme(text = element_text(size=20),
                                                                                                                                                                                                                            axis.text.x = element_text(angle=0, vjust=1))

#--------------------------------------------
with(DF.NC.TR,qplot(logkT,Region..OCP.,col=Product,alpha = I(0.7),ylab="Région de destination des exports mondiaux",xlab = "Transformée logarithmique des échanges par produit"))  +  theme(text = element_text(size=20),
                                                                                                                                                                                            axis.text.x = element_text(angle=0, vjust=1))
with(DF.NC.TR[OCP_Index,],qplot(logkT,Region..OCP.,col=Product,alpha = I(0.6),ylab="Région de destination des exports Marocains",xlab = "Transformée logarithmique des échanges par produit"))  +  theme(text = element_text(size=20),
                                                                                                                                                                                                           axis.text.x = element_text(angle=0, vjust=1))
#--------------------------------------------

multiplot(plot_cons_trim_region("DAP"),plot_cons_trim_region("MAP"),plot_cons_trim_region("PA"),plot_cons_trim_region("TSP"))



#---------------------------------------------


qplot(Quarter,logkT, data = DF.NC.TR, facets = .~Product,col=Region..OCP.,ylab="Transformée logarithmique des échanges mondiaux par produit et par région de desination",xlab = "Trimestre des échanges")
qplot(Quarter,logkT, data = DF.NC.TR[OCP_Index,], facets = .~Product,col=Region..OCP.,ylab="Transformée logarithmique des exports Marocains par produit et par région de desination",xlab = "Trimestre des échanges")

#--------------------------------------------------
#--------------------------------------------------


#--------------------------------------------------
#--------------------------------------------------

plot_cons_trim_region = function(produit){
  library(dplyr)
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
  titre=paste("Courbe des consommations trimestrielles ",paste(produit," par région du Monde"))
  return(ggplot(MAP.FN, aes(x=Time, y=ML, colour=Region, group=Region)) + geom_line() + ggtitle(titre) + ylab("Somme des Conso/Trim. des régions") + xlab("Trimestre des consommations") +  theme(text = element_text(size=14),
                                                                                                                                                                                                  axis.text.x = element_text(angle=0, vjust=1)))
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
                     ncol = 2, nrow = 2)
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