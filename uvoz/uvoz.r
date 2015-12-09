require(dplyr)
require(rvest)
require(gsubfn)

url <- "http://pxweb.stat.si/pxweb/Dialog/viewplus.asp?ma=H111S&ti=&path=../Database/Hitre_Repozitorij/&lang=2"

stran <- html_session(url) %>% read_html(encoding="UTF-8")
tabela <- stran %>% html_node(xpath = "//table[@class='pxtable']") %>% html_table()
Encoding(tabela[[1]]) <- "UTF-8"
names(tabela) <- tabela[1,]

skupaj <- tabela[3:11,]
rownames(skupaj) <-skupaj[[1]]
skupaj <- skupaj[,-1]

dijaki <- tabela[13:21,]
rownames(dijaki) <- dijaki[[1]]
dijaki <- dijaki[,-1]             

studenti <- tabela[23:31,]
rownames(studenti) <- studenti [[1]]
studenti <- studenti[,-1]

neznano <- tabela[33:41,]
rownames(neznano) <- neznano[[1]]
neznano <- neznano[,-1]


