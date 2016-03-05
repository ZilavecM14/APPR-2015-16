require(dplyr)
require(rvest)
require(gsubfn)
library(knitr)
library(dplyr)
library(reshape2)
library (ggplot2)
library(XML)
library(eeptools)
library(labeling)
library(extrafont)

# Uvozimo funkcije za delo z datotekami XML.
source("lib/xml.r", encoding = "UTF-8")

# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding = "UTF-8")

