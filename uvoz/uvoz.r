#2.FAZA
#Izberemo različne pakete
require(dplyr)
require(rvest)
require(gsubfn)

#spletni naslov na katerem se nahaja tabela (SURS)
url <- "http://pxweb.stat.si/pxweb/Dialog/viewplus.asp?ma=H111S&ti=&path=../Database/Hitre_Repozitorij/&lang=2"

#kodna tabela
stran <- html_session(url) %>% read_html(encoding="UTF-8")
tabela <- stran %>% html_node(xpath = "//table[@class='pxtable']") %>% html_table()
Encoding(tabela[[1]]) <- "UTF-8"
names(tabela) <- tabela[1,]

tabela[2,2:8]<-"NaN"
tabela[12,2:8]<-"NaN"
tabela[22,2:8]<-"NaN"
tabela[32,2:8]<-"NaN"

#Pretvorba nizov v character,integer
tabela[,1]<-as.character(tabela[,1])
tabela[,2:8] <- apply(tabela[,2:8], 2, as.integer)

#locimo od velike tabele, na vec manjsih tabel (skupaj, dijaki, studenti, neznano)

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

