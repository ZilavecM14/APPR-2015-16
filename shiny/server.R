library(shiny)

#if ("server.R" %in% dir()) {
#  setwd("..")
#}


shinyServer(function(input, output) {
  output$Grafstipendije <- renderPlot({
     
    stipendijeleto <- filter(data, leto==input$izberi,
                             kratko == input$izb, regija !="SLOVENIJA")
    
    ggplot()+
      geom_bar(data=stipendijeleto,aes(x = regija, y = stevilo), 
               stat="identity",fill="deeppink3",size=10)+
      coord_flip()
  })
})
    