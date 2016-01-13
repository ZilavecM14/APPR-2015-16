#2.FAZ
#spletni naslov na katerem se nahaja tabela (SURS)
url <- "http://pxweb.stat.si/pxweb/Dialog/viewplus.asp?ma=H111S&ti=&path=../Database/Hitre_Repozitorij/&lang=2"

#UVOZ 1
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

# pretvorba samo na število štipendij in leto
tidy <- melt(tabela, value.name = "stevilo", variable.name = "leto")
tidy$leto <- tidy$leto %>% as.character() %>% strapplyc("([0-9]+)") %>% as.numeric()

#locimo od velike tabele, na vec manjsih tabel
#skupaj
skupaj <- filter(tidy, kategorija == kategorije[1]) #izberemo po prvi kategoriji
skupaj14 <- filter(skupaj, leto == 2014) #ločimo na leto 2014
skupaj141 <- skupaj[55:63,4] #izberemo podeljene štipendije v letu 2014 v obliki vektorja

#dijaki
dijaki <- filter (tidy, kategorija == kategorije[2])
dijaki14 <- filter (dijaki, leto == 2014)
dijaki141 <- dijaki[55:63,4]

#studenti
studenti <- filter (tidy, kategorija == kategorije[3])
studenti14<-filter (studenti, leto == 2014)
studenti141 <- studenti[55:63,4]

#neznano
neznano <- filter (tidy, kategorija == kategorije[4])
neznano14 <-filter (neznano, leto == 2014)
neznano141 <- neznano[55:63,4]

tidy$drzavna <- ifelse (tidy$vrsta == tidy$vrsta[6], "Državne štipendije",
                        "Ostale štipendije")

tidy$vrsta_kratka <- c("Drugo",
                         "Državne štipendije" = "Državne",                            
                         "Kadrovske štipendije - Skupaj" = "Kadrovske skupaj",
                         "Kadrovske štipendije nesofinancirane" = "Kadrovske nesofinan.",
                         "Kadrovske štipendije sofinancirane neposredno" = "Kadrovske sof. nepos.",
                         "Kadrovske štipendije sofinancirane posredno" = "Kadrovske sof. pos.",   
                         "Štipendije za Slovence v zamejstvu in po svetu" = "V zamejstvu in po svetu",
                         "Vrsta štipendije - SKUPAJ" = "Skupaj",
                         "Zoisove štipendije" = "Zoisove")[tidy$vrsta]

ggplot(data=tidy %>% filter(kategorija != kategorija[1], vrsta != vrsta[1], leto == 2014),
       aes(x=drzavna,y=stevilo,fill=kategorija))+geom_bar(stat = "identity")

ggplot(data=tidy %>% filter(kategorija != kategorija[1], ! vrsta %in% vrsta[c(1,6)], leto ==2014),
       aes(x=vrsta_kratka,y=stevilo,fill=kategorija))+geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) 

#UVOZ 2
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

tidy2 <- melt(stipendije, value.name = "stevilo", variable.name = "leto")
tidy2$leto <- tidy2$leto %>% as.character() %>% strapplyc("([0-9]+)") %>% as.numeric()

#ggplot(data=stipendije,aes(x=regija,y=skupaj2008,color=kategorija))+geom_point()

#UVOZ 3
#http://pxweb.stat.si/pxweb/Dialog/Saveshow.asp
uvozi.visina <- function(){
  return(read.csv2("podatki/visina.csv", sep=";", as.is=TRUE,
                   na.strings ="-", header=FALSE,
                   fileEncoding = "Windows-1250",
          col.names = c("Slovenija","kategorija", "vrsta",
                        as.vector(outer(c("leto"),
                                        2008:2014,paste0)))))
}

visina <- uvozi.visina()

tidy3 <- melt(visina, value.name = "povprecna visina", variable.name = "leto")
tidy3$leto <- tidy3$leto %>% as.character() %>% strapplyc("([0-9]+)") %>% as.numeric()
