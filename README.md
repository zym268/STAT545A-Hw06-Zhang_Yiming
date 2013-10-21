STAT545A-Hw06-Zhang_Yiming
==========================

Homework 06 for STAT545A-Zhang_Yiming

Demonstration data: the number of words spoken by various characters in the Lord of the Rings trilogy. Each observation gives total word count for a character in a specific scene of a single movie. Variables are character, race (hobbit vs. dwarf, etc.), film, chapter ("scene"), number of words spoken. JB will document general cleaning, analyses, etc. of that data [here](https://github.com/jennybc/lotr); these scripts are deliberately simple.

How to replicate my analysis

  * Clone the report from Rpubs.
  * Download into an empty directory:
    - Scripts: [`Hw06 script01.R`](https://raw.github.com/zym268/STAT545a-2013-hw06_Zhang-yiming/blob/master/Hw06%20script01.R) and [`Hw06 script02.R`](https://raw.github.com/zym268/STAT545a-2013-hw06_Zhang-yiming/blob/master/Hw06%20script02.R)
    - Makefile: [`Makefile`]()
  * In a shell: `make all`. Or just: `make`. 
  * New files you should see after running the pipeline:
    - [`gDat_cl.tsv`](https://raw.github.com/zym268/STAT545a-2013-hw06_Zhang-yiming/master/gDat_cl.tsv)
    
  * To remove the output and get a clean slate, in a shell: `make clean`
