library(shiny)

#if ("server.R" %in% dir()) {
#  setwd("..")
#}


shinyServer(function(input, output) {
  output$Grafstipendije2 <- renderPlot({
     
    stipendijeleto <- filter(data, leto==input$izberi,
                             delitev == input$izb, regija !="SLOVENIJA")
    
    ggplot()+
      geom_bar(data=stipendijeleto,aes(x = regija, y = stevilo), 
               stat="identity",fill="blue",size=10)+
      coord_flip()
  })
})
    