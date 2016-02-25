# 4. faza: Analiza podatkov

novo <- studenti %>% filter(vrsta_kratka == "Zoisove")

#Izriše graf na katerem so napovedi do leta 2022
ggplot(data=novo,
       aes(x=leto, y=stevilo))+ xlim(2008, 2022) +
  geom_line(size=0.5)+
  geom_point(size=3, fill="black")+
  ggtitle("Spreminjanje stevila stipendij za studente")+
  geom_smooth(method = "lm", size = 1, fullrange = TRUE)

#Izpiše koeficient, prosti člen
lin <- lm(stevilo ~ leto, data = novo)

#Izpiše število štipendij od leta 2015 do leta 2020
predict(lin, data.frame(leto = c(2015:2020)))

novo1 <- studenti %>% filter(vrsta_kratka == "Skupaj")
g <- ggplot (novo1, aes(x=leto, y=stevilo))+ xlim(2008,2022) + geom_point()
z <- lowess(novo1$leto, novo1$stevilo)
m <- g + geom_line(color="red")
loess(data = novo1, stevilo ~ leto, color="red")
m + geom_smooth(method = "loess", size=1,fullrange = TRUE) 




