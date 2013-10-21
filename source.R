## clean out any previous work
outputs <- c("gDat_cl.tsv", 
             "ests.tsv.tsv", 
             "Best_Worest_countries_each_continents_estimation.tsv"
             list.files(pattern = "*.png$"))
file.remove(outputs)


## run scripts
source("Hw06 script01.R")
source("Hw06 script02.R")
