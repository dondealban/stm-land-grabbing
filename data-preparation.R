# This script prepares the text corpus for structural topic modeling using the stm R
# package (Roberts et al. 2016).
# 
# Script by:      Jose Don T. De Alban
# Date created:   16 Sept 2017
# Date modified:  


# LOAD DATA -------------------------


data <- read.csv("wos-test.csv", header=TRUE, sep=",")
