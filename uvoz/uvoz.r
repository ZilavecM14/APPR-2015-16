#2.FAZA
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

tabela[,1]<-as.character(tabela[,1])
tabela[,2]<-as.integer(tabela[,2])
tabela[,3]<-as.integer(tabela[,3])
tabela[,4]<-as.integer(tabela[,4])
tabela[,5]<-as.integer(tabela[,5])
tabela[,6]<-as.integer(tabela[,6])
tabela[,7]<-as.integer(tabela[,7])
tabela[,8]<-as.integer(tabela[,8])

#locimo od velike tabele, na vec manjsih tabel (skupaj, dijaki, studenti, neznano)

skupaj <- tabela[3:11,] #izberemo iz glavne tabele št vrstic in vsi stolpci
rownames(skupaj) <-skupaj[[1]] #iz tabele dobimo vrsto štipendije 
skupaj <- skupaj[,-1]#brez prvega stolpca iz tabele, da se ne ponovi

skupaj14 <- skupaj[1:9,7] #izberemo podeljene štipendije v letu 2014

dijaki <- tabela[13:21,]
rownames(dijaki) <- dijaki[[1]]
dijaki<-dijaki[,-1]

dijaki14 <- dijaki[1:9,6:7]

studenti <- tabela[23:31,]
rownames(studenti) <- studenti [[1]]
studenti <- studenti[,-1]

studenti14 <- studenti[1:9,6:7]

neznano <- tabela[33:41,]
rownames(neznano) <- neznano[[1]]
neznano <- neznano[,-1]

neznano14 <- neznano[1:9,6:7]

