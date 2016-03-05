library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Štipendije na leto in vrsto"),
  
  sidebarLayout(
    sidebarPanel(
      
      helpText("Izberi leto in vrsto"),
      
      sliderInput(inputId ="izberi", label="Izberi leto:",
                  value=2008, min=2008, max=2014, step=1, sep=""),
      
      selectInput(inputId="izb", label ="Izberi kategorijo:",
                   choices = list ("Državne", "Zoisove"), 
                   selected = "Državne")),
  mainPanel(plotOutput(outputId ="Grafstipendije"))
  )))
  
  