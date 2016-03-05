library(shiny)

if ("server.R" %in% dir()) {
  setwd("..")
}
source("lib/libraries.r", encoding = "UTF-8")
source("uvoz/uvoz.r", encoding = "UTF-8")
source("vizualizacija/vizualizacija.r", encoding = "UTF-8")
source("analiza/analiza.r", encoding = "UTF-8")

shinyServer(function(input, output) {
  output$Grafstipendije <- renderPlot({
     
    stipendijeleto <- razberi(input$izberi,"kratko",data)
    
    podatek <- input$izb
    
    stip1 <- subset(stipendijeleto,podatek >= 0)
    stip2 <- subset(stipendijeleto,podatek < 0)
    
    ggplot()+
      geom_bar(data=stip1,aes_string("kratko", podatek), 
               stat="identity",fill="deeppink3",size=10)+
      geom_bar(data=stip2,aes_string("kratko", podatek), 
               stat="identity",fill="deeppink3",size=10)+
      coord_flip()
  })
})
    