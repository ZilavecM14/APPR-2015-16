# 3. faza: Izdelava zemljevida

pretvori.zemljevid <- function(zemljevid) {
  fo <- fortify(zemljevid)
  data <- zemljevid@data
  data$id <- as.character(0:(nrow(data)-1))
  return(inner_join(fo, data, by="id"))
}

# Uvozimo zemljevid
zemljevid <- uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/SVN_adm_shp.zip",
                             "SVN_adm1", encoding = "UTF-8")

skupaj2008 <- tidy2 %>% filter(vrsta == vrsta[1], leto == 2008)
skupaj2014 <- tidy2 %>% filter(vrsta == vrsta[1], leto == 2014)

slo <- pretvori.zemljevid(zemljevid)

#Zemljevid za število štipendij skupaj po regijah za leto 2008
kategorije <- unique(tidy2$kategorija)
skupaj2008 <- ggplot() + geom_polygon (data = tidy2 %>%
                           filter(vrsta == vrsta[1], leto == 2008,
                                  kategorija == kategorije[1]) %>%
                           inner_join(slo, by = c("regija" = "NAME_1")),
                         aes(x=long, y=lat, group=group, fill=stevilo),
                         color="grey") +
  scale_fill_gradient(low="#56B1F7", high="#132B43") +
  guides(fill = guide_colorbar
         (title = "Število skupaj za 2008")) + xlab("") + ylab("")

#Zemljevid skupaj s številom prebivalcev po regijah
zem <- skupaj2008 + geom_point(data=stevilo8 %>% inner_join(slo, by = c("regija" = "NAME_1")) %>%
                        group_by(regija, prebivalstvo) %>%
                        summarise(x=mean(long), y=mean(lat)),
                      aes(x = x,y = y, size =prebivalstvo/1000), color="orange")

#Zemljevid - kvocient med številom podeljenih štipendij in številom prebivalstva po regijah za 2008
zem1 <- ggplot () + geom_polygon (data =tidy2 %>% inner_join(stevilo) %>%
                            filter(vrsta == vrsta[1], leto == 2008,
                                   kategorija == kategorije[1]) %>%
                            inner_join(slo, by= c("regija" = "NAME_1")),
                          aes(x=long, y=lat, group=group, fill=stevilo/prebivalstvo),
                          color="grey") +
  scale_fill_gradient(low="#E69F00", high="purple") +
  guides(fill = guide_colorbar
         (title = "Kvocient za leto 2008")) + xlab("") + ylab("")

#Zemljevid za število štipendij skupaj po regijah za leto 2014
skupaj2014 <- ggplot () + geom_polygon (data =tidy2 %>% 
                                          filter(vrsta == vrsta[1], leto == 2014,
                                                 kategorija == kategorije[1]) %>%
                                          inner_join(slo, by= c("regija" = "NAME_1")),
                                        aes(x=long, y=lat, group=group, fill=stevilo),
                                        color="grey") +
  scale_fill_gradient(low="#56B1F7", high="#132B43") +
  guides(fill = guide_colorbar
         (title = "Število skupaj za 2014")) + xlab("") + ylab("")

#Zemljevid skupaj s številom prebivalcev po regijah
zem2 <- skupaj2014 + geom_point(data = stevilo %>% inner_join(slo, by = c("regija" = "NAME_1")) %>%
                          group_by(regija, prebivalstvo) %>%
                          summarise(x = mean(long), y = mean(lat)),
                        aes(x = x, y = y, size = prebivalstvo/1000), color = "orange")

#Zemljevid - kvocient med številom podeljenih štipendij in številom prebivalstva po regijah za 2014
zem3 <- ggplot () + geom_polygon (data =tidy2 %>% inner_join(stevilo) %>%
                            filter(vrsta == vrsta[1], leto == 2014,
                                   kategorija == kategorije[1]) %>%
                            inner_join(slo, by= c("regija" = "NAME_1")),
                          aes(x=long, y=lat, group=group, fill=stevilo/prebivalstvo),
                          color="grey") +
  scale_fill_gradient(low="#E69F00", high="purple") +
  guides(fill = guide_colorbar
         (title = "Kvocient za leto 2014")) + xlab("") + ylab("")

#Razlika v podeljenih štipendijah med letoma 2008 in 2014
podatki08 <- tidy2 %>%
  filter(vrsta == vrsta[1], leto == 2008,
         kategorija == kategorije[1]) %>% select(regija, kategorija, vrsta, stevilo08 = stevilo)
podatki14 <- tidy2 %>%
  filter(vrsta == vrsta[1], leto == 2014,
         kategorija == kategorije[1]) %>% select(regija, kategorija, vrsta, stevilo14 = stevilo)
razlike <- inner_join(podatki08, podatki14) %>% mutate(razlika = stevilo14 - stevilo08)
zem4 <- ggplot() + geom_polygon (data = razlike %>%
                           inner_join(slo, by = c("regija" = "NAME_1")),
                         aes(x=long, y=lat, group=group, fill=razlika),
                         color="grey") +
  scale_fill_gradient(low="#56B1F7", high="#132B43") +
  guides(fill = guide_colorbar
         (title = "Razlika v številu med 2008/2014")) + xlab("") + ylab("")

#Zemljevid število štipendij skupaj podeljenim dijakom za leto 2008
dijaki2008 <- ggplot() + geom_polygon (data = tidy2 %>%
                           filter(vrsta == vrsta[1], leto == 2008,
                                  kategorija == "Dijaki") %>%
                           inner_join(slo, by = c("regija" = "NAME_1")),
                         aes(x=long, y=lat, group=group, fill=stevilo),
                         color="grey") +
  scale_fill_gradient(low="#00FF00", high="#3F7F3F") +
  guides(fill = guide_colorbar
         (title = "Število dijakom za 2008")) + xlab("") + ylab("")

#Zemljevid dijaki 2008 + imena regij
zem6 <- dijaki2008 + geom_text(data=stevilo8 %>% inner_join(slo, by = c("regija" = "NAME_1")) %>%
                         group_by(regija, prebivalstvo) %>%
                         summarise(x=mean(long), y=mean(lat)),
                       aes(x = x,y = y, label = regija), color="Black") 

#Zemljevid število štipendij skupaj podeljenim dijakom za leto 214
dijaki2014 <-ggplot() + geom_polygon (data = tidy2 %>%
                                  filter(vrsta == vrsta[1], leto == 2014,
                                         kategorija == "Dijaki") %>%
                                  inner_join(slo, by = c("regija" = "NAME_1")),
                                aes(x=long, y=lat, group=group, fill=stevilo),
                                color="grey") +
  scale_fill_gradient(low="#00FF00", high="#3F7F3F") +
  guides(fill = guide_colorbar
         (title = "Število dijakom za 2014")) + xlab("") + ylab("")

#Zemljevid dijaki 2014 + imena regij
zem7 <- dijaki2014 + geom_text(data=stevilo %>% inner_join(slo, by = c("regija" = "NAME_1")) %>%
                         group_by(regija, prebivalstvo) %>%
                         summarise(x=mean(long), y=mean(lat)),
                       aes(x = x,y = y, label = regija), color="Black") 

#Zemljevid število štipendij skupaj podeljenim študentom za leto 2008
studenti2008 <- ggplot() + geom_polygon (data=tidy2 %>%
                           filter (vrsta==vrsta[1], leto == 2008,
                                   kategorija == "Študentje") %>%
                           inner_join(slo, by = c("regija" = "NAME_1")),
                         aes(x=long, y=lat, group=group, fill=stevilo),
                         color="grey") +
  scale_fill_gradient(low="red", high="darkred") +
  guides(fill = guide_colorbar
         (title = "Število študentom za 2008")) + xlab("") + ylab("")

#Zemljevid studenti 2008 + imena regij
zem8 <- studenti2008 + geom_text(data=stevilo8 %>% inner_join(slo, by = c("regija" = "NAME_1")) %>%
                         group_by(regija, prebivalstvo) %>%
                         summarise(x=mean(long), y=mean(lat)),
                       aes(x = x,y = y, label = regija), color="Black") 

#Zemljevid število štipendij skupaj podeljenim študentom za leto 2008
studenti2014 <- ggplot() + geom_polygon (data=tidy2 %>%
                           filter (vrsta==vrsta[1], leto == 2014,
                                   kategorija == "Študentje") %>%
                           inner_join(slo, by = c("regija" = "NAME_1")),
                         aes(x=long, y=lat, group=group, fill=stevilo),
                         color="grey") +
  scale_fill_gradient(low="red", high="darkred") +
  guides(fill = guide_colorbar
         (title = "Število študentom za 2014")) + xlab("") + ylab("")

#Zemljevid studenti 2014 + imena regij
zem9 <- studenti2014 + geom_text(data=stevilo %>% inner_join(slo, by = c("regija" = "NAME_1")) %>%
                           group_by(regija, prebivalstvo) %>%
                           summarise(x=mean(long), y=mean(lat)),
                         aes(x = x,y = y, label = regija), color="Black") 


