#2.FAZ
#spletni naslov na katerem se nahaja tabela (SURS)
url <- "http://pxweb.stat.si/pxweb/Dialog/viewplus.asp?ma=H111S&ti=&path=../Database/Hitre_Repozitorij/&lang=2"

#kodna tabela
stran <- html_session(url) %>% read_html(encoding="UTF-8")
tabela <- stran %>% html_node(xpath = "//table[@class='pxtable']") %>% html_table()
Encoding(tabela[[1]]) <- "UTF-8"
names(tabela) <- tabela[1,]
names(tabela)[1] <- "vrsta" #Poimenovan drugi stolpec tabele
tabela <- tabela[-c(1, nrow(tabela)),] 
tabela <- data.frame(kategorija = tabela[,1], tabela)

kategorije <- factor(tabela$kategorija[seq(1,nrow(tabela),10)])
tabela$kategorija <- as.vector(t(matrix(rep(kategorije, 10), nrow=4)))
tabela <- tabela[-seq(1, nrow(tabela), 10),]

#Pretvorba nizov v character,integer
tabela[,2]<-factor(tabela[,2])
tabela[,3:9] <- apply (tabela[,3:9], 2, . %>% strapplyc("([0-9]*)") %>% unlist() %>% as.integer())

#levels(tabela$vrsta) <- c("Drugo","Državne", "Kadrov. skupaj","Kadrov. nesofin.", "Kadrov. sof. nepos.", "Kadrov. sof. pos.","Zamejci in svet", "Zoisove")

#locimo od velike tabele, na vec manjsih tabel
#skupaj
skupaj <- filter(tabela, kategorija == kategorije[1]) #izberemo po prvi kategoriji
skupaj14 <- select(skupaj, vrsta, X2014) #ločimo na leto 2014
skupaj141 <- skupaj[1:9,9] #izberemo podeljene štipendije v letu 2014 v obliki vektorja

#dijaki
dijaki <- filter (tabela, kategorija == kategorije[2])
dijaki14 <- select(dijaki, vrsta, X2014)
dijaki141 <- dijaki[1:9,9]

#studenti
studenti <- filter (tabela, kategorija == kategorije[3])
studenti14<-select(studenti, vrsta, X2014)
studenti141 <- studenti[1:9,9]

#neznano
neznano <- filter (tabela, kategorija == kategorija [4])
neznano14 <-select(neznano, vrsta, X2014)
neznano141 <- neznano[1:9,9]

tabela$drzavna <- ifelse(tabela$vrsta == tabela$vrsta[6], "Državne štipendije",
                         "Ostale štipendije")

ggplot(data=tabela %>% filter(kategorija != kategorija[1], vrsta != vrsta[1]),
       aes(x=drzavna,y=X2014,fill=kategorija))+geom_bar(stat = "identity") 

ggplot(data=tabela %>% filter(kategorija != kategorija[1], ! vrsta %in% vrsta[c(1,6)]),
       aes(x=vrsta,y=X2014,fill=kategorija))+geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) 

#http://pxweb.stat.si/pxweb/Dialog/Saveshow.asp
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

#pobrisemo prazne stolpce 
stipendije <- stipendije [,-c(7,11,15,19,23,31)]

#ggplot(data=stipendije,aes(x=regija,y=skupaj2008,color=kategorija))+geom_point()




