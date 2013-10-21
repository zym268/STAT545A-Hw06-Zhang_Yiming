## data import from URL
gdURL <- "http://www.stat.ubc.ca/~jenny/notOcto/STAT545A/examples/gapminder/data/gapminderDataFiveYear.txt" 
gDat <- read.delim(file=gdURL)

##load the needed packages, if you don't have these packages use "install.packages("lattice",dependencies = TRUE)",etc.
library(lattice)
library(plyr)
library(xtable)
library(ggplot2)

##quick check of the data
str(gDat) 

##get the number of unique country in every continent in gDat 
(countcountry <- ddply(gDat,~continent,summarize,count_country=length(unique(country))))

##drop Oceania since it has only 2 contries
gDat <- droplevels(subset(gDat,continent !="Oceania")) 

##check out the general picture of life expectancy in these four continents 
stripplot(lifeExp ~ continent, gDat, jitter.data = TRUE, grid = "h", 
          type = c("p", "a"), fun = median) 

## print the plot to file
dev.print(pdf,"lifeExp_in_continent.pdf")   

##plot and print life expectancy varing by time
stripplot(lifeExp ~ factor(year) | reorder(continent, lifeExp), gDat,
          jitter.data = TRUE,
          type = c("p", "a"), fun = median, alpha = 0.4, grid = "h", 
          ## use alpha to control the transparency 
          main = paste("Life expectancy varies in time in four continents"),
          scales = list(x = list(rot = c(45, 0))))
dev.print(pdf,"lifeExp_in_continent_by_time_4plots.pdf")

#plot and print the life expectancy varing trend for the four continents
LifeExpchgebyCont_tall <- ddply(gDat, ~year + continent, summarize, MedianLifeExp = median(lifeExp))
xyplot(MedianLifeExp ~ year, LifeExpchgebyCont_tall, groups = continent, 
       main = paste("Life expectancy by median in four continents"),
       auto.key = TRUE, type = c("p", "a")) 
dev.print(pdf,"lifeExp_in_continent_by_time_1polts.pdf")

##plot and print the density plot on gdpPercap for four coninents in 2007
select_year <- "2007" # avoid the magic number
gDat_select_year <- subset(gDat,subset=year==select_year)
ggplot(gDat_select_year,aes(x=gdpPercap,colour=continent))+geom_density()
dev.print(pdf,"gdpPercap_in_continent_densitypolts.pdf")

##plot the density plot on lifeExp for four coninents in 2007
ggplot(gDat_select_year,aes(x=lifeExp,colour=continent))+geom_density()
dev.print(pdf,"lifeExp_in_continent_densitypolts.pdf")

## plot with gdpPercap as x asis, lifeExp as y asis and square root of population as size of each plot
ggplot(subset(gDat, year == select_year), aes(x = gdpPercap, y = lifeExp, colour = continent, 
                                              size = sqrt(pop))) + geom_point() + scale_x_log10()
dev.print(pdf,"plot4country_gdpPercap_lifeExp_population_as_size.pdf")


##reorder and arrange the gapminder data

##first reorder the continent factor based on their mean of life expectancy
gDat <- within(gDat, continent <- reorder(continent, lifeExp, mean))

##then reorder the country factor in each continent based on their mean of life expectancy
gDat <- within(gDat, country <- reorder(country, lifeExp,mean))

##arrange and reorder the data itself by continent, then country and finally year
gDat <- arrange(gDat, continent, country, year)

##write the arranged gapminder data to file
write.table(gDat, "gDat_cl.tsv", quote = FALSE,
            sep = "\t", row.names = FALSE)



