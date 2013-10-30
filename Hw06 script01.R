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
(countcountry <- ddply(gDat, ~ continent, summarize, count_country = length( unique( country))))

##drop Oceania since it has only 2 contries
gDat <- droplevels( subset( gDat, continent !="Oceania")) 

##check out the general picture of life expectancy in these four continents 
stripplot(lifeExp ~ continent, gDat, jitter.data = TRUE, grid = "h", 
          type = c("p", "a"), fun = median) 

#plot the life expectancy varing trend for the four continents
LifeExpchgebyCont_tall <- ddply( gDat, ~ year + continent, summarize, MedianLifeExp = median(lifeExp))
ggplot(LifeExpchgebyCont_tall, aes( x = year, y = MedianLifeExp,
                                  colour = continent)) + geom_point() + geom_line() + stat_smooth(method = "lm") + facet_wrap(~ continent) + ggtitle("Life expectancy by median in four continents")
ggsave("lifeExp_in_continent_by_time_4polts.png")
ggplot(LifeExpchgebyCont_tall, aes( x = year, y = MedianLifeExp, 
                                  colour = continent)) + geom_point() + geom_line() + ggtitle("Life expectancy by median in four continents")
ggsave("lifeExp_in_continent_by_time_1polts.png")

##plot and print the density plot on gdpPercap for four coninents in 2007
select_year <- "2007" # avoid the magic number
gDat_select_year <- subset( gDat, subset = year == select_year)
ggplot(gDat_select_year, aes(x = gdpPercap, colour = continent)) + geom_density()
ggsave("gdpPercap_in_continent_densitypolts.png")

##plot the density plot on lifeExp for four coninents in 2007
ggplot(gDat_select_year, aes( x = lifeExp, colour = continent)) + geom_density()
ggsave("lifeExp_in_continent_densitypolts.png")

## plot with gdpPercap as x asis, lifeExp as y asis and square root of population as size of each plot
ggplot(subset(gDat, year == select_year), aes(x = gdpPercap, y = lifeExp, colour = continent, 
                                              size = sqrt(pop))) + geom_point() + scale_x_log10()
ggsave("plot4country_gdpPercap_lifeExp_population_as_size.png")

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



