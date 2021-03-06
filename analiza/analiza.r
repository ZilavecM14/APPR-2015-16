# 4. faza: Analiza podatkov

novo <- skupaj %>% filter(vrsta_kratka == "Skupaj")

#Izriše graf na katerem so napovedi do leta 2022 za vse štipendije skupaj
analiza1<-ggplot(data=novo, aes(x=leto, y=stevilo))+ xlim(2008, 2022) +
  geom_line(size=0.5)+
  geom_point(size=3, fill="black")+
  ggtitle("Napoved števila štipendij do leta 2022")+
  geom_smooth(method = "lm",formula = y ~ x+I(x^2)+I(x^3),
              size = 1, fullrange = TRUE)

#Izpiše koeficient, prosti člen
lin <- lm(stevilo ~ leto, data = novo)

#Izpiše število štipendij od leta 2015 do leta 2022
predict(lin, data.frame(leto = c(2015:2022)))

novo1 <- studenti %>% filter(vrsta_kratka == "Skupaj")

lin <- lm(stevilo ~ leto, data=novo1)
predict(lin, data.frame(leto = c(2015:2022)))

# izriše območje premikanja od leta 2008-2014 za študente
g <- ggplot (novo1, aes(x=leto, y=stevilo))+ geom_point(fill = "black")
z <- lowess(novo1$leto, novo1$stevilo)
m <- g + geom_line(color="red")
loess(data = novo1, stevilo ~ leto, color="red")
m + geom_smooth(method = "loess", size=1,fullrange = TRUE) 

# napoved do leta 2022
gam (data = novo1, leto ~ stevilo, color = "red")
analiza2 <- ggplot (novo1, aes(x=leto, y=stevilo))+ xlim (2008,2022) +
  geom_line () + geom_point(fill="black") +
  geom_smooth (method = "gam",formula = y ~ splines::bs(x, 3),
               fullrange = TRUE)

novo2 <- dijaki %>% filter(vrsta_kratka == "Skupaj")

lin <- lm(stevilo ~ leto, data=novo2)
predict(lin, data.frame(leto = c(2015:2022)))

# izriše območje premikanja od leta 2008-2014 za dijake
g <- ggplot (novo2, aes(x=leto, y=stevilo))+ geom_point(fill = "black")
z <- lowess(novo2$leto, novo2$stevilo)
m <- g + geom_line(color="red")
loess(data = novo2, stevilo ~ leto, color="red")
m + geom_smooth(method = "loess", size=1,fullrange = TRUE) 

# napoved do leta 2022
gam (data = novo2, leto ~ stevilo, color = "red")
analiza3 <- ggplot (novo2, aes(x=leto, y=stevilo))+ xlim (2008,2022) +
  geom_line () + geom_point(fill="black") +
  geom_smooth (method = "gam",formula = y ~ splines::bs(x, 4),
               fullrange = TRUE)

#Filter po višini štipendij za dijake
novo3 <- dijakivisina %>% filter (vrsta_kratka == "Skupaj")

#Izpiše število štipendij
lin <- lm(visina ~ leto, data=novo3)
predict(lin, data.frame(leto = c(2015:2022)))

#Napoved do leta 2022
analiza4 <- ggplot(data=novo3, aes(x=leto, y=visina))+ xlim (2008,2022) +
  geom_point(size=3, fill="black")+
  ggtitle("Napoved višine štipendij za dijake do leta 2022")+
  geom_smooth(method ="lm",formula = y ~ x+I(x^2)+I(x^3),
              fill ="blue", colour="darkblue", size=1, alpha=0.2,
              fullrange=TRUE)

#Filter po višini štipendij za študente
novo4 <- studentivisina %>% filter (vrsta_kratka == "Skupaj")

#Izpiše število štipendij
lin <- lm(visina ~ leto, data=novo4)
predict(lin, data.frame(leto = c(2015:2022)))

#Napoved do leta 2022
analiza5 <- ggplot(data=novo4, aes(x=leto, y=visina))+ xlim (2008,2022) +
  geom_point(size=3, fill="black")+
  ggtitle("Napoved višine štipendij za študente do leta 2022")+
  geom_smooth(method="gam",formula = y ~ x+I(x^2)+I(x^3),
              fill ="red", colour="orange", size=1, alpha=0.2,
              fullrange=TRUE)
