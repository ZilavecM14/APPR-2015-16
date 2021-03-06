#2.FAZA
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

#graf, s katerim delimo število štipendij glede na državne in ostale štipendije
graf0 <- ggplot(data=tidy %>% filter(kategorija != kategorija[1], vrsta != vrsta[1], leto == 2008),
                aes(x=drzavna,y=stevilo,fill=kategorija))+
  geom_bar(stat = "identity")+
  ggtitle("Državne in ostale štipendije za leto 2008")

#graf - število štipendij brez državnih štipendij
graf1 <- ggplot(data=tidy %>% filter(kategorija != kategorija[1], ! vrsta %in% vrsta[c(1,6)], leto ==2008),
                aes(x=vrsta_kratka,y=stevilo,fill=kategorija))+
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + 
  ggtitle ("Število štipendij za leto 2008")

#graf, s katerim delimo število štipendij glede na državne in ostale štipendije
graf2 <- ggplot(data=tidy %>% filter(kategorija != kategorija[1], vrsta != vrsta[1], leto == 2014),
       aes(x=drzavna,y=stevilo,fill=kategorija))+
  geom_bar(stat = "identity")+
  ggtitle("Državne in ostale štipendije za leto 2014")

#graf - število štipendij brez državnih štipendij
graf3 <- ggplot(data=tidy %>% filter(kategorija != kategorija[1], ! vrsta %in% vrsta[c(1,6)], leto ==2014),
       aes(x=vrsta_kratka,y=stevilo,fill=kategorija))+
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + 
  ggtitle ("Število štipendij za leto 2014")

#graf - število štipendij po vrstah za dijake za leta 2008-2014
graf4 <- ggplot(data=dijaki, 
       aes(x=leto, y=stevilo,color=vrsta_kratka))+
  geom_line(size=0.5)+
  geom_point(size=3, fill="black")+
  ggtitle("Spreminjanje stevila stipendij za dijake")

#graf - število štipendij po vrstah za študente za leta 2008-2014
graf5 <- ggplot(data=studenti,
       aes(x=leto, y=stevilo,color=vrsta_kratka))+
  geom_line(size=0.5)+
  geom_point(size=3, fill="black")+
  ggtitle("Spreminjanje stevila stipendij za studente")

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
stipendije <- stipendije[c("regija", "kategorija", "vrsta", paste0("skupaj", 2008:2014))]

tidy2 <- melt(stipendije, value.name = "stevilo", variable.name = "leto")
tidy2$leto <- tidy2$leto %>% as.character() %>% strapplyc("([0-9]+)") %>% as.numeric()

#UVOZ2A
#http://pxweb.stat.si/pxweb/Dialog/Saveshow.asp
uvozi.stevilo <-function() {
  return (read.csv2("podatki/stpreb.csv", sep=";",
                   na.strings = "-",
                   fileEncoding = "Windows-1250"))
}
stevilo <- uvozi.stevilo()

#UVOZ2B
#http://pxweb.stat.si/pxweb/Dialog/Saveshow.asp
uvozi.stevilo8 <-function() {
  return (read.csv2("podatki/stpreb8.csv", sep=";",
                    na.strings = "-",
                    fileEncoding = "UTF-8"))
}
stevilo8 <- uvozi.stevilo8()

#delitev na ostale in državne
tidy2$delitev <- ifelse (tidy2$vrsta == tidy2$vrsta[6], "Državne",
                        "Ostale")
tidy2$deli <- ifelse (tidy2$vrsta == tidy2$vrsta[1], "Skupaj",
                         "Posamezno")

#krajšanje imen
tidy2$kratko <- c("Druge štipendije" = "Druge",
                       "Državne štipendije" = "Državne", 
                       "Kadrovske štipendije - Skupaj" = "Kadrovske skupaj",
                       "Kadrovske štipendije nesofinancirane" = "Kadrovske nesofinan.",
                       "Kadrovske štipendije sofinancirane neposredno" = "Kadrovske sof. nepos.",
                       "Kadrovske štipendije sofinancirane posredno" = "Kadrovske sof. pos.",
                       "Neznano" = "Neznano",
                       "Štipendije za Slovence v zamejstvu in po svetu" = "V zamejstvu in po svetu",
                       "Vrsta štipendije - SKUPAJ" = "Skupaj",
                       "Zoisove štipendije" = "Zoisove")[tidy2$vrsta]

srednja <- filter (tidy2, kategorija == kategorije[2], deli=="Skupaj")
srednja1 <- filter (tidy2, kategorija == kategorije[2], kratko  %in% kratko[c(6,7)])
data <- srednja1[-c(27,28,56,83,167,195), ]
srednja0814 <- filter (srednja, leto==2008| leto == 2014)
s84 <- srednja0814 %>% filter(!regija %in% regija[1])

univerza <- filter (tidy2, kategorija == kategorije[3], deli=="Skupaj")
univerza0814<-filter (univerza, leto==2008|leto == 2014)
u84 <- univerza0814  %>% filter(!regija %in% regija[1])

# graf - število državnih in ostalih štipendij  za dijake za leto 2014
graf6 <- ggplot(data=s84, aes(x=regija,y=stevilo))+
  geom_step() + geom_point(aes(color = factor(leto))) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  ggtitle("Število podeljenih štipendij za leti 2008-2014 za dijake")

graf7 <- ggplot(data=u84, aes(x=regija,y=stevilo))+
  geom_step() + geom_point(aes(color = factor(leto))) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) +
  ggtitle("Število podeljenih štipendij za leti 2008-2014 za študente")

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

tidy3 <- melt(visina, value.name = "visina", variable.name = "leto")
tidy3$leto <- tidy3$leto %>% as.character() %>% strapplyc("([0-9]+)") %>% as.numeric

tidy3$vrsta_kratka <- c("Drugo"="Drugo",
                       "Državne štipendije" = "Državne",                            
                       "Kadrovske štipendije - Skupaj" = "Kadrovske skupaj",
                       "Kadrovske štipendije nesofinancirane" = "Kadrovske nesofinan.",
                       "Kadrovske štipendije sofinancirane neposredno" = "Kadrovske sof. nepos.",
                       "Kadrovske štipendije sofinancirane posredno" = "Kadrovske sof. pos.",   
                       "Štipendije za Slovence v zamejstvu in po svetu" = "V zamejstvu in po svetu",
                       "Vrsta štipendije - SKUPAJ" = "Skupaj",
                       "Zoisove štipendije" = "Zoisove")[tidy3$vrsta]

dijakivisina <- filter (tidy3, kategorija == kategorije[2])
dijakivisina0814 <- filter (dijakivisina, leto == 2008| leto==2014)

studentivisina <- filter (tidy3, kategorija == kategorije[3])
studentivisina0814<-filter (studentivisina, leto == 2008|leto==2014)

#graf 
graf8 <- ggplot(data=dijakivisina %>% filter(!vrsta %in% vrsta[c(1)]),
       aes(x=vrsta_kratka,y=visina, fill=leto))+ 
  geom_bar(stat = "identity",colour="black")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + 
  ggtitle("Povprecna visina stipendije dijakom glede na vrsto od leta 2008 do leta 2014")

#graf
graf9 <- ggplot(data=dijakivisina0814 %>% filter(!vrsta %in% vrsta[c(1)]),
       aes(x=vrsta_kratka,y=visina, fill=leto))+ 
  geom_bar(stat="identity",colour="black")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + 
  ggtitle("Povprecna visina stipendije dijakom glede na vrsto za leti 2008 in 2014")

#graf
graf10 <- ggplot(data=studentivisina %>% filter(!vrsta %in% vrsta[c(1)]),
       aes(x=vrsta_kratka,y=visina, fill=leto))+ 
  geom_bar(stat = "identity",colour="black")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + 
  ggtitle("Povprecna visina stipendije studentom glede na vrsto od leta 2008 do leta 2014")

#graf
graf11 <- ggplot(data=studentivisina0814 %>% filter(!vrsta %in% vrsta[c(1)]),
       aes(x=vrsta_kratka,y=visina,fill=leto))+ 
  geom_bar(stat = "identity",colour="black")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5)) + 
  ggtitle("Povprecna visina stipendije studentom glede na vrsto za leti 2008 in 2014")

# Funkcija za razbiranje natančnejših tabele:
razberi <- function(x,y,podatki){
  return(podatki[podatki[y] == x, names(podatki) != y])
}

