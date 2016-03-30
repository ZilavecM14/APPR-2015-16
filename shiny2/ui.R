library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Število štipendij po letih in vrsti štipendije"),
  
  sidebarLayout(
    sidebarPanel(
      
      helpText("Izberi leto in vrsto"),
      
      sliderInput(inputId ="izberi", label="Izberi leto:",
                  value=2008, min=2008, max=2014, step=1, sep=""),
      
      selectInput(inputId="izb", label ="Izberi kategorijo:",
                   choices = list ("Državne", "Ostale"), 
                   selected = "Državne")),
  mainPanel(plotOutput(outputId ="Grafstipendije2"))
  )))
  
  