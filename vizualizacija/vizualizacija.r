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

#Zemljevid število štipendij skupaj podeljenim dijakom za leto 2008
ggplot() + geom_polygon (data = tidy2 %>%
                          filter(vrsta == vrsta[1], leto == 2008,
                                 kategorija == "Dijaki") %>%
                          inner_join(slo, by = c("regija" = "NAME_1")),
                        aes(x=long, y=lat, group=group, fill=stevilo),
                        color="grey") +
                        scale_fill_gradient(low="#00FF00", high="#3F7F3F") +
                        guides(fill = guide_colorbar
                               (title = "Število dijakom za 2008"))

#Zemljevid število štipendij skupaj podeljenim dijakom za leto 214
zem <- ggplot() + geom_polygon (data = tidy2 %>%
                           filter(vrsta == vrsta[1], leto == 2014,
                                  kategorija == "Dijaki") %>%
                           inner_join(slo, by = c("regija" = "NAME_1")),
                         aes(x=long, y=lat, group=group, fill=stevilo),
                         color="grey") +
  scale_fill_gradient(low="#00FF00", high="#3F7F3F") +
  guides(fill = guide_colorbar
         (title = "Število dijakom za 2014"))


zem + geom_point(data = stevilo %>% inner_join(slo, by = c("regija" = "NAME_1")) %>%
               group_by(regija, prebivalstvo) %>%
               summarise(x = mean(long), y = mean(lat)),
             aes(x = x, y = y, size = prebivalstvo/1000), color = "Blue")


#ggplot() + geom_polygon (data = tidy2 %>%
#                           filter(vrsta == vrsta[1], leto == 2008,
#                                  kategorija == "Štipendije - SKUPAJ") %>%
#                           inner_join(slo, by = c("regija" = "NAME_1")),
#                         aes(x=long, y=lat, group=group, fill=stevilo),
#                         color="grey") +
#  scale_fill_gradient(low="#00FF00", high="#3F7F3F") +
#  guides(fill = guide_colorbar
#         (title = "Število skupaj za 2008"))
