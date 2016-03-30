library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Število štipendij po letih in višini štipendije"),
  
  sidebarLayout(
    sidebarPanel(
      
      helpText("Izberi leto in kategorijo"),
      
      sliderInput(inputId ="izberi", label="Izberi leto:",
                  value=2008, min=2008, max=2014, step=1, sep=""),
      
      selectInput(inputId="izb", label ="Izberi kategorijo:",
                   choices = list ("Štipendije - SKUPAJ", "Dijaki",
                                   "Študentje", "Neznano"), 
                   selected = "Štipendije - SKUPAJ")),
  mainPanel(plotOutput(outputId ="Grafstipendije3"))
  )))
  
  