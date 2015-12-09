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

#locimo od velike tabele, na vec manjsih tabel (skupaj, dijaki, studenti, neznano)

skupaj <- tabela[3:11,] #izberemo iz glavne tabele št vrstic in vsi stolpci
rownames(skupaj) <-skupaj[[1]] 
skupaj <- skupaj[,-1] #brez prvega stolpca iz tabele 

skupaj14 <- skupaj[2:10,8]
rownames(skupaj14)<-skupaj14[[1]]

dijaki <- tabela[13:21,]
rownames(dijaki) <- dijaki[[1]]
dijaki <- dijaki[,-1]             

studenti <- tabela[23:31,]
rownames(studenti) <- studenti [[1]]
studenti <- studenti[,-1]

neznano <- tabela[33:41,]
rownames(neznano) <- neznano[[1]]
neznano <- neznano[,-1]


