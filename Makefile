all: Best_Worest_countries_each_continents_estimation.tsv est.tsv HW06.Rmd

gDat_cl.tsv lifeExp*.png gdpPercap*.png: Hw06 script01.R
        Rscript Hw06 script01.R

Best_Worest_Countries*.png est.tsv Best_Worest_countries_each_continents_estimation.tsv: gDat_cl.tsv Hw06 script02.R
        Rscript Hw06 script02.R
        
HW06.html: HW06.Rmd
        Rscript -e "knitr::knit2html('HW06.Rmd')"; rm -r HW06.md figure

clean:
        rm -f gDat_cl.tsv est.tsv Best_Worest_countries_each_continents_estimation.tsv *.png *.html figure
