#2.FAZA
#Izberemo razlicne pakete
require(dplyr)
require(rvest)
require(gsubfn)
library(dplyr)

#spletni naslov na katerem se nahaja tabela (SURS)
url <- "http://pxweb.stat.si/pxweb/Dialog/viewplus.asp?ma=H111S&ti=&path=../Database/Hitre_Repozitorij/&lang=2"

#kodna tabela
stran <- html_session(url) %>% read_html(encoding="UTF-8")
tabela <- stran %>% html_node(xpath = "//table[@class='pxtable']") %>% html_table()
Encoding(tabela[[1]]) <- "UTF-8"
names(tabela) <- tabela[1,]
names(tabela)[2] <- "vrsta"
tabela <- tabela[-c(1, nrow(tabela)),]
tabela <- data.frame(kategorija = tabela[,1], tabela)

kategorije <- factor(tabela$kategorija[seq(1,nrow(tabela),10)])
tabela$kategorija <- as.vector(t(matrix(rep(kategorije, 10), nrow=4)))
tabela <- tabela[-seq(1, nrow(tabela), 10),]

#Pretvorba nizov v character,integer
tabela[,2]<-as.character(tabela[,2])
tabela[,3:9] <- apply (tabela[,3:9], 2, . %>% strapplyc("([0-9]*)") %>% unlist() %>% as.integer())

#locimo od velike tabele, na vec manjsih tabel (skupaj, dijaki, studenti, neznano)

skupaj <- filter(tabela, kategorija == kategorije[1])
skupaj14 <- select(skupaj, vrsta, X2014)

skupaj <- tabela[3:11,] #izberemo iz glavne tabele št vrstic in vsi stolpci
rownames(skupaj) <-skupaj[[1]] #iz tabele dobimo vrsto štipendije 
skupaj <- skupaj[,-1]#brez prvega stolpca iz tabele, da se ne ponovi

skupaj14 <- skupaj[1:9,7] #izberemo podeljene štipendije v letu 2014 v obliki vektorja
skupaj141 <- select(skupaj[1:9,], 7) #izberemo podeljene štipendije v letu 2014 v obliki stolpca

dijaki <- tabela[13:21,]
rownames(dijaki) <- dijaki[[1]]
dijaki<-dijaki[,-1]

dijaki14 <- dijaki[1:9,7]
dijaki141 <- select(dijaki[1:9,], 7)

studenti <- tabela[23:31,]
rownames(studenti) <- studenti [[1]]
studenti <- studenti[,-1]

studenti14 <- studenti[1:9,7]
studenti141<-select(studenti[1:9,], 7)

neznano <- tabela[33:41,]
rownames(neznano) <- neznano[[1]]
neznano <- neznano[,-1]

neznano14 <- neznano[1:9,7]
neznano141<-select(neznano[1:9,], 7)

#Funkcija, ki uvozi podatke iz datoteke stipendije.csv
uvozi.stipendije <-function() {
  return(read.csv2("podatki/stipendije.csv", sep=";", as.is=TRUE,
                    na.strings = "-", header = FALSE,
                    fileEncoding = "Windows-1250",
         col.names = c("regija", "kategorija", "vrsta",
                       as.vector(outer(c("skupaj", "moski", "zenske", "neznano"),
                                       2008:2014, paste0)))))
}

#Zapisemo podatke v razpredelnico stipendije
stipendije <- uvozi.stipendije ()





