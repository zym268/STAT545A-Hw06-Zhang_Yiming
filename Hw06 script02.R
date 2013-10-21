##clear the work space
rm(list=ls())

## load the data

##If you have run script, you can import the data from the current wording directory
gDat <- read.delim("gDat_cl.tsv")


##load the needed packages, if you don't have these packages use "install.packages("lattice",dependencies = TRUE)",etc.
library(lattice)
library(plyr)
library(xtable)
library(ggplot2)

##check if the new continent order is still in force
View(gDat)
## Yes!

##quick check of the data
str(gDat) 

##Oops, the factor order seems doesn't work for a new script, so we should do it again
gDat <- within(gDat, continent <- reorder(continent, lifeExp, mean))
gDat <- within(gDat, country <- reorder(country, lifeExp,mean))

##Use a function to get the intercept and slope of linear regression of life expectancy on year within each country
jFun <- function(x) {
  jFit<- lm(lifeExp ~ I(year - min(gDat$year)), x)
  est <- c(coef(jFit),sd(jFit$residuals))
  names(est) <- c("intercept", "slope","sd")
  return(est)
}

##Use the function above get the intercept and slope within each country
( ests<- ddply(gDat,~country,jFun))

##Print it to file
write.table(ests, "ests.tsv", quote = FALSE,
            sep = "\t", row.names = FALSE)

##merge the estimated data with the original data
jDat <- merge(gDat,ests)

## Use function choose the best 3 countries as the maximum slope(The Most Improved Awards), the maximum intercept(Best country in the past), 
##, and the minimum standard deviation(The Most Stable Improvement Awards)
BestFun <- function(x){
  max_slope <- which.max(x$slope)
  max_intercept <- which.max(x$intercept)
  min_sd <- which.min(x$sd)
x[c(max_slope,max_intercept,min_sd),]
}

## Use function choose the worest 3 countries as the minimum slope, the minimum intercept, and the maximum standard deviation
WorestFun <- function(x){
  min_slope <- which.min(x$slope)
  min_intercept <- which.min(x$intercept)
  max_sd <- which.max(x$sd)
  x[c(min_slope,min_intercept,max_sd),]
}

##Get the best and worest countries in Afica and merge into one data frame
(Best_Africa <- BestFun(subset(jDat,subset=continent=="Africa")))
(Worest_Africa <- WorestFun(subset(jDat,subset=continent=="Africa")))
(merge_Africa<- merge(Best_Africa,Worest_Africa,all=TRUE))
BestandWorest_Afria<-subset(gDat,subset=country %in% merge_Africa$country)

##Get the best and worest countries in Asia and merge into one data frame
(Best_Asia <- BestFun(subset(jDat,subset=continent=="Asia")))
(Worest_Asia <- WorestFun(subset(jDat,subset=continent=="Asia")))
( merge_Asia<- merge(Best_Asia,Worest_Asia,all=TRUE))
BestandWorest_Asia<-subset(gDat,subset=country %in% merge_Asia$country)

##Get the best and worest countries in Americas and merge into one data frame
(Best_Americas <- BestFun(subset(jDat,subset=continent=="Americas")))
(Worest_Americas <- WorestFun(subset(jDat,subset=continent=="Americas")))
( merge_Americas<- merge(Best_Americas,Worest_Americas,all=TRUE))
BestandWorest_Americas<-subset(gDat,subset=country %in% merge_Americas$country)

##Get the best and worest countries in Europe and merge into one data frame
(Best_Europe <- BestFun(subset(jDat,subset=continent=="Europe")))
(Worest_Europe <- WorestFun(subset(jDat,subset=continent=="Europe")))
(merge_Europe<- merge(Best_Europe,Worest_Europe,all=TRUE))
BestandWorest_Europe<-subset(gDat,subset=country %in% merge_Europe$country)

##put it all togather
all_Best_Worest <- rbind(BestandWorest_Afria,BestandWorest_Asia,BestandWorest_Americas,BestandWorest_Europe)

 ests_Best_Worest<- ddply(all_Best_Worest,~country,jFun)

##Print it to file
write.table(ests_Best_Worest, "Best_Worest_countries_each_continents_estimation.tsv", quote = FALSE,
            sep = "\t", row.names = FALSE)

##For Africa
ggplot(BestandWorest_Afria,aes(x=year,y=lifeExp,colour=country))+geom_point()+geom_line()+stat_smooth(method = "lm")+facet_wrap(~country)+ggtitle("The Best And Worest countries in Africa ")
dev.print(pdf,"Best_Worest_Countries_Africa")

##For Asia
ggplot(BestandWorest_Asia,aes(x=year,y=lifeExp,colour=country))+geom_point()+geom_line()+stat_smooth(method = "lm")+facet_wrap(~country)+ggtitle("The Best And Worest countries in Asia ")
dev.print(pdf,"Best_Worest_Countries_Asia")

##For Americas
ggplot(BestandWorest_Americas,aes(x=year,y=lifeExp,colour=country))+geom_point()+geom_line()+stat_smooth(method = "lm")+facet_wrap(~country)+ggtitle("The Best And Worest countries in Americas ")
dev.print(pdf,"Best_Worest_Countries_Americas")

##For Europe
ggplot(BestandWorest_Europe,aes(x=year,y=lifeExp,colour=country))+geom_point()+geom_line()+stat_smooth(method = "lm")+facet_wrap(~country)+ggtitle("The Best And Worest countries in Europe ")
dev.print(pdf,"Best_Worest_Countries_Europe")
