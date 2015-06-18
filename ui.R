library(shiny)

# Define UI for random distribution application 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Global EarthquakeVisualization"),
  
  # Sidebar with controls to select the random distribution type
  # and number of observations to generate. Note the use of the
  # br() element to introduce extra vertical spacing
  sidebarLayout(
    sidebarPanel(
      
      dateRangeInput("range", label = h3("Date range to display"), start = as.Date("1980-01-01"),
                     startview = "year"),
      
      hr(),
      fluidRow(textOutput("text1")), 
      
      br(),
      
      fluidRow(sliderInput("mag_range", label = "Select the range of magnitudes to display",
                  min = 6, max = 10, value = c(6,10))),
      fluidRow(textOutput("text2"))
      
    ),
    
    # Show a tabset that includes a plot, summary, and table view
    # of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("About", verbatimTextOutput("About")),
                  tabPanel("Map", plotOutput("map")), 
                  tabPanel("Histogram", plotOutput("hist")), 
                  tabPanel("Table", tableOutput("table"))
      )
    )
  )
))