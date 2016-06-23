# Importation de packages necessaires à l'analyse
library("TTR"); 
# Importation du package utilisé 
library("forecast");
# Chargement des données
load("donnees/vmat.RData"); 
# Fonction de visualisation des erreurs
plotForecastErrors <- function(forecasterrors){
	mybinsize <- IQR(forecasterrors)/4
    mysd   <- sd(forecasterrors)
    mymin  <- min(forecasterrors) - mysd*5
    mymax  <- max(forecasterrors) + mysd*3
    mynorm <- rnorm(10000, mean=0, sd=mysd)
    mymin2 <- min(mynorm)
    mymax2 <- max(mynorm)
    if (mymin2 < mymin) { mymin <- mymin2 }
    if (mymax2 > mymax) { mymax <- mymax2 }
    mybins <- seq(mymin, mymax, mybinsize)
    hist(forecasterrors, col="red", freq=FALSE, breaks=mybins)
    myhist <- hist(mynorm, plot=FALSE, breaks=mybins)
    points(myhist$mids, myhist$density, type="l", col="blue", lwd=2)
}
# Transformation et normalisation des données
ventes_liste <-vector("numeric"); 
for(i in 1:20){
	ventes_liste <- c(ventes_liste,ventes_matrice[i,]);
}
names(ventes_liste) <- NULL;
#Construction d'un objet de type série temporelle
ventes_serie <- ts(ventes_liste,frequency = 4,start = c(2007,1));
#############################Determination du type du modele###############################""

#Visualisation graphique de la série
png("graphique/vismatrice.png");
plot.ts(ventes_serie,main = "Visualisation de la série",ylab = "Ventes",xlab = "Année",col = "blue");
dev.off();

#Determination du modele à l'aide de la méthode analytique
detmodele<-matrix(nrow = 9,ncol = 2,byrow = TRUE);
for(i in 1:9){
	detmodele[i,1]<-mean(ventes_matrice[i,]);
	detmodele[i,2]<-sd(ventes_matrice[i,]);
}
#Calcul de la relation qui existe entre les variances et les moyennes
modele<-lm(detmodele[,2]~detmodele[,1]);
#extraction du coefficient de mesure
indicemodele <- modele[[1]][2];
print("Correlation entre moyennes et variances");
print(indicemodele);
if(indicemodele < 0.5){
	print("Le modele est additif");
}else{
	print("Le modele est multiplicatif");
}

##################################Decomposition de la série#####################################
#Décomposition de la série
estimemodele <- decompose(ventes_serie);
png("graphique/decompositionserie.png")
plot(estimemodele,col = "blue");
dev.off();
#Caclul des la série corrigé des variations saisionnière
scorrige <- vector("numeric");
for(i in 1:36){
	scorrige[i]<-ventes_serie[i]-estimemodele$seasonal[i];
}

#irregularite <- vector("numeric")
#irregularite <- estimemodele$random;
#irregularite[1] <-0;
#irregularite[40]<-0;


#intermediaire <- vector("numeric");
#for(i in 1:40){
#	intermediaire[i] <- scorrige[i]-irregularite[i];
#}


#Ajustement de la droite de regression par la méthode des moindres carrées
#temps <- rep(c(1,2),20);
temps <- c(1:36);
correlation <- cor(scorrige,temps);
estimetendance <- lm(formula = scorrige ~ temps);
#Estimation de la tendance par la méthode des moindres carrées
tendance <- vector("numeric");
for(i in 1:36){
	tendance[i] <- estimetendance[[1]][[2]]*temps[i]+estimetendance[[1]][[1]];
}

#Calcul de la série sans saisonnalité et sans tendance
stendance_ssaiso <- vector("numeric");
for(i in 1:36){
	stendance_ssaiso[i] <- (scorrige[i]-tendance[i]);
}

#Calcul de la série entière avec tendance et composante saisonnière
serie_entiere <- stendance_ssaiso + tendance + estimemodele$seasonal;

####################################Prevision par lissage exponenetiel simple#################################"""
#Conversion de l'objet stendance_ssaison en objet de type serie
stendance_ssaiso_serie <- ts(stendance_ssaiso,start = c(2007),frequency = 4);
png("graphique/stendance_ssaiso.png");
plot.ts(stendance_ssaiso_serie,main = "Visualisation de la série sans tendance et sans saisonnalité",ylab = "Valeur",xlab = "Temps",col = "blue");
dev.off();

#prediction à l'aide de lissage exponenetiel simple
stendssaisoforecasts <- HoltWinters(stendance_ssaiso_serie,gamma = FALSE,beta = FALSE,l.start = stendance_ssaiso_serie[1]);
png("graphique/lissagesimple.png");
plot(stendssaisoforecasts,col = "blue",main = "lissage simple",xlab = "Temps",ylab ="Valeur" );
dev.off();

#Prévision à l'horizon 8 (2 ans) 
stendssaisoforecasts2 <- forecast.HoltWinters(stendssaisoforecasts,h = 8);
png("graphique/lissagehorizon.png");
plot.forecast(stendssaisoforecasts2,main = "Prédiction par lissage simple");
dev.off();
#Visualisation des residus du lissage simple
png("graphique/residuslissagesimple.png");
acf(stendssaisoforecasts2$residuals,lag.max = 20,main = "Fonction d'autocorrélation");
dev.off();
#Visualisation des résidus
png("graphique/testnormaliteresidus.png");
plotForecastErrors(stendssaisoforecasts2$residuals);
dev.off();

#Test de la non autocorrelation des résidus
testlissagesimple <- Box.test(stendssaisoforecasts2$residuals,lag = 20,type = "Ljung-Box");

################################################Lissage exponentiel double#################################
tendance_serie <- ts(scorrige,frequency = 4,start = c(2007,1));
png("graphique/visualisationtendancemoindrecaree.png");
plot.ts(tendance_serie,col = "blue",main = "Série avec tendance");
dev.off();

#lissage de la série avec la tendance
tendanceforecast <- HoltWinters(tendance_serie,gamma = FALSE,l.start = tendance_serie[2]-tendance_serie[1],b.start = tendance_serie[2]);
png("graphique/lissagedoubletendance.png");
plot(tendanceforecast);
dev.off();

#Prévision sur un horizon de 8 (2 ans)
tendanceforecast2 <- forecast.HoltWinters(tendanceforecast,h = 8);
png("graphique/lissagedoublehorizon.png");
plot.forecast(tendanceforecast2);
dev.off();

#Visualisation des résidus après lissage double
png("graphique/residuslissagedouble.png");
acf(tendanceforecast2$residuals,lag.max = 20);
dev.off();

png("graphique/testnormaliteresiduslissagedouble.png");
plotForecastErrors(tendanceforecast2$residuals);
dev.off();

testlissagedouble <- Box.test(tendanceforecast2$residuals,lag = 20,type = "Ljung-Box");


################################################Lissage HOLT-WINTERS avec saisonnalité##############################""
serie_entiere_serie <-ts(serie_entiere,frequency = 4,start = c(2007,1));
serie_entiere_forcast <- HoltWinters(serie_entiere_serie);
png("graphique/serieentiere.png");
plot(serie_entiere_forcast);
dev.off();

#Previosn à l'horizon 8 (2 ans)
serie_entiere_forcast2 <- forecast.HoltWinters(serie_entiere_forcast,h = 8);
png("graphique/serie_entiere_forcast.png");
plot.forecast(serie_entiere_forcast2);
dev.off();

#Etude des résidus(Fonction d'autocorrelation);
png("graphique/residulissageholt.png");
acf(serie_entiere_forcast2$residuals,lag.max= 20);
dev.off();

#Test de normalite;
png("graphique/normaliteholt.png");
plotForecastErrors(serie_entiere_forcast2$residuals);
dev.off();
#Test de Ljung-Box
testlissageholtsaiso <- Box.test(serie_entiere_forcast2$residuals,lag = 20,type = "Ljung-Box");

##############################################Processus ARIMA##############################################
#Elimination de la méthode
tend_erreur_diff <- diff(tendanceforecast2$residuals,difference = 1);

#Visualisation des diagrammes d'autocorrelation et au-correlation partielle pour determiner p,q
#Auto-correlation
png("graphique/correlationarima.png"); # Pour estimer le q
acf(tend_erreur_diff,lag.max = 20);
dev.off();

#Auto-correlation partielle
png("graphique/pcorrelarima.png"); # Pour estimer le p
pacf(tend_erreur_diff,lag.max = 20);
dev.off();

#Estimsation des parametres
outarimatend <- arima(tendanceforecast2$residuals,order = c(1,1,2));

#Prévision à l'horizon 8 (2 ans)
outarimatendforecast <- forecast.Arima(outarimatend,h = 8);

#Etude des erreurs résidus suite à l'utilisation du modele ARIMA
png("graphique/erreursarimatend.png");
acf(outarimatendforecast$residuals,lag.max = 20);
dev.off();
#Test de normaliste
png("graphique/erreursarimatendnormailte.png");
plotForecastErrors(outarimatendforecast$residuals);
dev.off();

#Test de Ljung-box
testearimatendance <- Box.test(outarimatendforecast$residuals,lag = 20,type = "Ljung-Box");

##########################################################Processus SARIMA appliquée à la série entière#################################################
outsarima <- arima(serie_entiere_forcast2$residuals,order = c(1,1,2),seasonal = list(order = c(1,1,2),period = 4));

#Construction du modele
outsarimaforecast <- forecast.Arima(outsarima,h = 8);


#Viualisation des prédiction à l'horizon 24
png("graphique/sarimaforecast.png");
plot.forecast(outsarimaforecast);
dev.off();

#Etude des rédisus
png("graphique/sarimaautocerrel.png");
acf(outsarimaforecast$residuals,lag.max = 20);
dev.off();

#Test de normalité
png("graphique/sarimanormalite.png");
plotForecastErrors(outsarimaforecast$residuals);
dev.off();

#Test de box
testsarima <- Box.test(outarimatendforecast$residuals,lag = 20,type = "Ljung-Box");
