library(shiny)

#if ("server.R" %in% dir()) {
#  setwd("..")
#}


shinyServer(function(input, output) {
  output$Grafstipendije <- renderPlot({
     
    stipendijeleto <- filter(data, leto==input$izberi,
                             kratko == input$izb, regija !="SLOVENIJA")
    
    #podatek <- input$izb
    
    #stip1 <- subset(stipendijeleto,podatek >= 0)
    #stip2 <- subset(stipendijeleto,podatek < 0)
    
    #ggplot()+
      #geom_bar(data=stip1,aes_string("kratko", podatek), 
       #        stat="identity",fill="deeppink3",size=10)+
      #geom_bar(data=stip2,aes_string("kratko", podatek), 
       #        stat="identity",fill="deeppink3",size=10)+
      #coord_flip()
    
    ggplot()+
      geom_bar(data=stipendijeleto,aes(x = regija, y = stevilo), 
               stat="identity",fill="deeppink3",size=10)+
      coord_flip()
  })
})
    