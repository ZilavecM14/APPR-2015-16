library(shiny)

#if ("server.R" %in% dir()) {
#  setwd("..")
#}


shinyServer(function(input, output) {
  output$Grafstipendije3 <- renderPlot({
     
    stipendijeleto3 <- filter(tidy3, leto==input$izberi,
                             kategorija == input$izb, 
                             vrsta_kratka !="Drugo")
    
    ggplot()+
      geom_bar(data=stipendijeleto3,aes(x = vrsta_kratka, y = visina), 
               stat="identity", fill="firebrick3",size=10)+
      coord_flip()
  })
})
    